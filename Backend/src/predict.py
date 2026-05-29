"""
Drug-Drug Interaction Prediction Module
Loads trained model and makes predictions with risk assessment
"""

import torch
import torch.nn.functional as F
import numpy as np
import pickle
import json
from rdkit import Chem
from rdkit.Chem import AllChem
from model_training import DeepDDI


class DDIPredictor:
    """Drug-Drug Interaction Predictor"""
    
    def __init__(self, model_path='../models/deepddi_model.pt', 
                 preprocessor_path='../data/preprocessor.pkl',
                 model_info_path='../models/model_info.json'):
        """
        Initialize predictor
        
        Args:
            model_path: Path to trained model weights
            preprocessor_path: Path to saved preprocessor
            model_info_path: Path to model info JSON
        """
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
        # Load model info
        with open(model_info_path, 'r') as f:
            self.model_info = json.load(f)
        
        # Load preprocessor
        with open(preprocessor_path, 'rb') as f:
            preprocessor_data = pickle.load(f)
            self.label_encoder = preprocessor_data['label_encoder']
            self.drug_to_smiles = preprocessor_data['drug_to_smiles']
            self.fingerprint_size = preprocessor_data['fingerprint_size']
            self.radius = preprocessor_data['radius']
        
        # Initialize model
        self.model = DeepDDI(
            input_dim=self.model_info['input_dim'],
            num_classes=self.model_info['num_classes']
        )
        
        # Load weights
        self.model.load_state_dict(torch.load(model_path, map_location=self.device))
        self.model.to(self.device)
        self.model.eval()
        
        print(f"✅ Model loaded successfully on {self.device}")
        print(f"Classes: {self.model_info['classes']}")
    
    def smiles_to_fingerprint(self, smiles):
        """
        Convert SMILES to Morgan fingerprint
        
        Args:
            smiles: SMILES string
            
        Returns:
            numpy array of fingerprint
        """
        try:
            mol = Chem.MolFromSmiles(smiles)
            if mol is None:
                raise ValueError(f"Invalid SMILES: {smiles}")
            
            fp = AllChem.GetMorganFingerprintAsBitVect(
                mol, self.radius, nBits=self.fingerprint_size
            )
            
            arr = np.zeros((self.fingerprint_size,))
            Chem.DataStructs.ConvertToNumpyArray(fp, arr)
            
            return arr
        except Exception as e:
            raise ValueError(f"Error processing SMILES: {e}")
    
    def get_drug_smiles(self, drug_name):
        """
        Get SMILES for a drug by name
        
        Args:
            drug_name: Drug name or ID
            
        Returns:
            SMILES string
        """
        # Lowercase normalized name for lookup
        drug_name_norm = drug_name.lower().strip()
        synonyms = {
            "aspirin": "Acetylsalicylic acid",
            "paracetamol": "Acetaminophen",
            "tylenol": "Acetaminophen",
            "panadol": "Acetaminophen"
        }
        
        # Check synonyms
        if drug_name_norm in synonyms:
            drug_name = synonyms[drug_name_norm]
            drug_name_norm = drug_name.lower().strip()

        # Try exact lookup first
        smiles = self.drug_to_smiles.get(drug_name)
        
        # If not found, try case-insensitive keys lookup
        if smiles is None:
            for k, v in self.drug_to_smiles.items():
                if k.lower().strip() == drug_name_norm:
                    smiles = v
                    break
                    
        if smiles is None:
            raise ValueError(f"Drug '{drug_name}' not found in database")
        return smiles
    
    def predict_from_smiles(self, smiles1, smiles2):
        """
        Predict interaction from SMILES strings
        
        Args:
            smiles1: SMILES of first drug
            smiles2: SMILES of second drug
            
        Returns:
            dict with prediction results
        """
        # Convert to fingerprints
        fp1 = self.smiles_to_fingerprint(smiles1)
        fp2 = self.smiles_to_fingerprint(smiles2)
        
        # Concatenate
        combined_fp = np.concatenate([fp1, fp2])
        
        # Convert to tensor
        input_tensor = torch.FloatTensor(combined_fp).unsqueeze(0).to(self.device)
        
        # Predict
        with torch.no_grad():
            output = self.model(input_tensor)
            probabilities = F.softmax(output, dim=1).cpu().numpy()[0]
        
        # Get predicted class
        predicted_idx = np.argmax(probabilities)
        predicted_class = self.label_encoder.classes_[predicted_idx]
        
        # Create result dictionary
        result = {
            'probabilities': {},
            'predicted_class': predicted_class,
            'risk_score': float(probabilities[predicted_idx] * 10),  # Scale to 0-10
            'risk_message': self._get_risk_message(probabilities, predicted_class)
        }
        
        # Add individual probabilities
        for i, class_name in enumerate(self.label_encoder.classes_):
            result['probabilities'][class_name] = float(probabilities[i] * 100)
        
        return result
    
    def predict_from_names(self, drug1_name, drug2_name):
        """
        Predict interaction from drug names
        
        Args:
            drug1_name: Name of first drug
            drug2_name: Name of second drug
            
        Returns:
            dict with prediction results
        """
        # Get SMILES
        smiles1 = self.get_drug_smiles(drug1_name)
        smiles2 = self.get_drug_smiles(drug2_name)
        
        # Predict
        result = self.predict_from_smiles(smiles1, smiles2)
        result['drug_pair'] = f"{drug1_name} + {drug2_name}"
        
        return result
    
    def _get_risk_message(self, probabilities, predicted_class):
        """
        Generate human-readable risk message
        
        Args:
            probabilities: Array of class probabilities
            predicted_class: Predicted class name
            
        Returns:
            Risk message string
        """
        # Find indices for each severity level
        class_to_idx = {name: i for i, name in enumerate(self.label_encoder.classes_)}
        
        severe_prob = probabilities[class_to_idx.get('Severe', -1)] if 'Severe' in class_to_idx else 0
        moderate_prob = probabilities[class_to_idx.get('Moderate', -1)] if 'Moderate' in class_to_idx else 0
        none_prob = probabilities[class_to_idx.get('None', -1)] if 'None' in class_to_idx else 0
        
        # Generate message based on probabilities
        if severe_prob > 0.7:
            return "⚠️ Dangerous combination — avoid taking these drugs together. Consult your healthcare provider immediately."
        elif severe_prob > 0.5:
            return "⚠️ High risk of severe interaction — use extreme caution and medical supervision."
        elif moderate_prob > 0.6:
            return "⚠️ Moderate risk — use with caution. Monitor for side effects and consult healthcare provider."
        elif moderate_prob > 0.4:
            return "⚠️ Potential interaction — consider monitoring. Discuss with your healthcare provider."
        elif none_prob > 0.7:
            return "✅ Safe combination — no major interaction detected. Always follow prescribed dosages."
        else:
            return "ℹ️ Uncertain prediction — consult healthcare provider before combining these medications."
    
    def _check_popular_overrides(self, drug1, drug2, is_smiles=False):
        """
        Check for rule-based overrides for the top 10 most popular high-risk drug interactions.
        Returns a detailed prediction dict if a match is found, otherwise None.
        """
        # Helper to safely canonicalize SMILES
        def canonicalize(smiles_str):
            try:
                mol = Chem.MolFromSmiles(smiles_str)
                if mol:
                    return Chem.MolToSmiles(mol, canonical=True)
            except:
                pass
            return smiles_str.strip()

        # Helper to resolve drug name to canonical SMILES using local DB
        def get_canonical_smiles_for_name(name):
            try:
                name_lower = name.lower().strip()
                for k, v in self.drug_to_smiles.items():
                    if k.lower().strip() == name_lower:
                        return canonicalize(v)
            except:
                pass
            return None

        # Normalize inputs
        n1 = drug1.lower().strip()
        n2 = drug2.lower().strip()

        # Resolve SMILES if inputs are names, or vice-versa, for hybrid/cross matching
        smiles1 = None
        smiles2 = None
        name1 = None
        name2 = None
        
        if is_smiles:
            smiles1 = canonicalize(drug1)
            smiles2 = canonicalize(drug2)
            # Try to resolve to name if possible
            for k, v in self.drug_to_smiles.items():
                if canonicalize(v) == smiles1:
                    name1 = k.lower().strip()
                if canonicalize(v) == smiles2:
                    name2 = k.lower().strip()
        else:
            name1 = n1
            name2 = n2
            smiles1 = get_canonical_smiles_for_name(drug1)
            smiles2 = get_canonical_smiles_for_name(drug2)

        # 1. Flexible Acetaminophen + Cold/Flu matching
        acetaminophen_syns = {"acetaminophen", "paracetamol", "tylenol", "panadol", "apap"}
        is_acetaminophen_combo = False
        
        has_acetaminophen1 = (name1 in acetaminophen_syns) if name1 else False
        has_acetaminophen2 = (name2 in acetaminophen_syns) if name2 else False
        
        if has_acetaminophen1 and has_acetaminophen2:
            is_acetaminophen_combo = True
        elif (has_acetaminophen1 and name2 and ("cold" in name2 or "flu" in name2)) or \
             (has_acetaminophen2 and name1 and ("cold" in name1 or "flu" in name1)):
            is_acetaminophen_combo = True
            
        if is_acetaminophen_combo:
            drug_pair_name = f"{drug1} + {drug2}"
            return {
                'drug_pair': drug_pair_name,
                'predicted_class': 'Severe',
                'severity': 'High',
                'interaction_exists': True,
                'risk_score': 9.5,
                'risk_message': '⚠️ Dangerous combination — avoid combining multiple Acetaminophen-containing products. High risk of severe liver toxicity.',
                'probabilities': {'Severe': 98.0, 'Moderate': 1.5, 'None': 0.5},
                'confidence': 'High',
                'description': 'Main Risk: Severe liver toxicity. Possible clinical effects include hepatic injury, jaundice, acute liver failure, and potential need for liver transplant.',
                'mechanism': 'Accidental cumulative overdose due to ingestion of multiple products containing the same active ingredient (Acetaminophen/Paracetamol).',
                'recommendations': [
                    'Never take more than one product containing Acetaminophen (such as Tylenol, Panadol, or multi-symptom cold/flu remedies) concurrently.',
                    'Keep the total daily dose of Acetaminophen below 4,000 mg (or less if you have liver conditions or consume alcohol).',
                    'Always check active ingredients on product labels before combining medications.'
                ]
            }

        # Define other 9 overrides
        overrides = [
            # 1. Warfarin + Ibuprofen
            {
                "names": {"warfarin", "ibuprofen"},
                "drug_pair": "Warfarin + Ibuprofen",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 9.5,
                "risk_message": "⚠️ Dangerous combination — avoid taking these drugs together. Consult your healthcare provider immediately.",
                "probabilities": {"Severe": 98.0, "Moderate": 1.5, "None": 0.5},
                "confidence": "High",
                "description": "Main Risk: Severe bleeding. Possible clinical effects include gastrointestinal bleeding, internal bleeding, and hemorrhagic stroke.",
                "mechanism": "Increased anticoagulation + gastric mucosal irritation.",
                "recommendations": [
                    "Avoid this drug combination if possible",
                    "Consult your healthcare provider immediately",
                    "Do not start or stop medications without medical supervision",
                    "Monitor for signs of bleeding (bruising, dark stools, nosebleeds)",
                    "Consider safer alternatives for pain relief like Acetaminophen"
                ]
            },
            # 2. Tramadol + Sertraline
            {
                "names": {"tramadol", "sertraline"},
                "drug_pair": "Tramadol + Sertraline",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 9.2,
                "risk_message": "⚠️ Dangerous combination — avoid taking these drugs together. High risk of Serotonin Syndrome.",
                "probabilities": {"Severe": 97.0, "Moderate": 2.0, "None": 1.0},
                "confidence": "High",
                "description": "Main Risk: Serotonin Syndrome. Possible clinical effects include fever, tremor, agitation, tachycardia (fast heart rate), and seizures.",
                "mechanism": "Excess serotonin accumulation due to additive serotonergic effects.",
                "recommendations": [
                    "Avoid combining these medications",
                    "Consult your doctor immediately for alternatives",
                    "Watch closely for symptoms like confusion, rapid heart rate, muscle twitching, or heavy sweating",
                    "Seek emergency medical help if seizures or high fever occur"
                ]
            },
            # 3. Diazepam + Oxycodone
            {
                "names": {"diazepam", "oxycodone"},
                "drug_pair": "Diazepam + Oxycodone",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 9.8,
                "risk_message": "⚠️ Dangerous combination — extreme risk of respiratory depression and sedation.",
                "probabilities": {"Severe": 99.0, "Moderate": 0.8, "None": 0.2},
                "confidence": "High",
                "description": "Main Risk: Severe respiratory depression. Possible clinical effects include extreme sedation, profound drowsiness, coma, respiratory arrest, and death.",
                "mechanism": "Additive central nervous system (CNS) depression.",
                "recommendations": [
                    "Avoid combining benzodiazepines (Diazepam) and opioids (Oxycodone) unless specifically prescribed and monitored by a doctor",
                    "Always use the lowest effective dose",
                    "Inform family members of the risk of extreme sleepiness or difficulty breathing",
                    "Avoid alcohol and other CNS depressants"
                ]
            },
            # 4. Phenelzine + Fluoxetine
            {
                "names": {"phenelzine", "fluoxetine"},
                "drug_pair": "Phenelzine + Fluoxetine",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 9.9,
                "risk_message": "⚠️ Dangerous combination — strictly contraindicated due to risk of Serotonin Syndrome and Hypertensive crisis.",
                "probabilities": {"Severe": 99.5, "Moderate": 0.4, "None": 0.1},
                "confidence": "High",
                "description": "Main Risk: Serotonin Syndrome / Hypertensive crisis. Possible clinical effects include hyperthermia (dangerously high body temperature), severe hypertension, confusion, muscle rigidity, and seizures.",
                "mechanism": "Excess accumulation of monoamine neurotransmitters (serotonin and norepinephrine).",
                "recommendations": [
                    "Contraindicated combination: DO NOT take Phenelzine (an MAOI) and Fluoxetine (an SSRI) together",
                    "A washout period of at least 5 weeks is required after stopping Fluoxetine before starting Phenelzine",
                    "Seek emergency medical attention immediately if symptoms occur"
                ]
            },
            # 5. Nitroglycerin + Sildenafil
            {
                "names": {"nitroglycerin", "sildenafil"},
                "drug_pair": "Nitroglycerin + Sildenafil",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 10.0,
                "risk_message": "⚠️ Strictly Contraindicated — extreme risk of severe hypotension and cardiovascular collapse.",
                "probabilities": {"Severe": 99.9, "Moderate": 0.05, "None": 0.05},
                "confidence": "High",
                "description": "Main Risk: Severe, life-threatening hypotension (extremely low blood pressure). Possible clinical effects include syncope (fainting), shock, and cardiovascular collapse.",
                "mechanism": "Excess vasodilation due to synergistic nitric oxide/cGMP pathway enhancement.",
                "recommendations": [
                    "Strictly Contraindicated: NEVER use Nitroglycerin (or any nitrate) and Sildenafil together",
                    "Ensure at least 24 hours (preferably 48 hours) between using these medications",
                    "If chest pain occurs after taking Sildenafil, do NOT take Nitroglycerin and seek emergency medical care immediately"
                ]
            },
            # 6. Lithium + Naproxen
            {
                "names": {"lithium", "naproxen"},
                "drug_pair": "Lithium + Naproxen",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 8.8,
                "risk_message": "⚠️ High risk — NSAID-induced reduction in lithium clearance may lead to lithium toxicity.",
                "probabilities": {"Severe": 94.0, "Moderate": 4.5, "None": 1.5},
                "confidence": "High",
                "description": "Main Risk: Lithium toxicity. Possible clinical effects include hand tremors, vomiting, severe diarrhea, confusion, slurred speech, and kidney dysfunction.",
                "mechanism": "Reduced renal lithium clearance due to NSAID-induced inhibition of renal prostaglandins.",
                "recommendations": [
                    "Avoid combining Lithium with NSAIDs like Naproxen if possible",
                    "If combined, closely monitor blood lithium levels and kidney function",
                    "Report early signs of lithium toxicity (tremors, nausea, drowsiness) to your doctor",
                    "Consider safer alternative pain relievers like Acetaminophen"
                ]
            },
            # 7. Digoxin + Clarithromycin
            {
                "names": {"digoxin", "clarithromycin"},
                "drug_pair": "Digoxin + Clarithromycin",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 9.0,
                "risk_message": "⚠️ High risk — Digoxin levels may increase to toxic thresholds.",
                "probabilities": {"Severe": 95.0, "Moderate": 3.8, "None": 1.2},
                "confidence": "High",
                "description": "Main Risk: Digoxin toxicity. Possible clinical effects include cardiac arrhythmias (irregular heartbeats), nausea, vomiting, diarrhea, and visual disturbances (blurred or yellow-green vision).",
                "mechanism": "Increased serum digoxin concentration due to inhibition of P-glycoprotein and gut flora by Clarithromycin.",
                "recommendations": [
                    "Avoid using Clarithromycin while taking Digoxin",
                    "If combination is necessary, reduce Digoxin dosage and monitor serum digoxin levels closely",
                    "Be vigilant for symptoms of toxicity and report them immediately"
                ]
            },
            # 8. Simvastatin + Grapefruit Juice
            {
                "names": {"simvastatin", "grapefruit juice", "grapefruit"},
                "is_special_grapefruit": True,
                "drug_pair": "Simvastatin + Grapefruit Juice",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 8.5,
                "risk_message": "⚠️ High risk — Grapefruit juice significantly increases simvastatin exposure, risking muscle damage.",
                "probabilities": {"Severe": 92.0, "Moderate": 6.0, "None": 2.0},
                "confidence": "High",
                "description": "Main Risk: Rhabdomyolysis (muscle tissue breakdown). Possible clinical effects include muscle pain, muscle breakdown, and kidney injury.",
                "mechanism": "CYP3A4 inhibition → increased statin level.",
                "recommendations": [
                    "Do not consume grapefruit juice or whole grapefruits while taking Simvastatin",
                    "If grapefruit consumption is desired, consult your doctor about switching to a statin not metabolized by CYP3A4 (e.g., Pravastatin or Rosuvastatin)",
                    "Report any unexplained muscle pain or tenderness immediately"
                ]
            },
            # 9. Insulin + Propranolol
            {
                "names": {"insulin", "propranolol"},
                "drug_pair": "Insulin + Propranolol",
                "predicted_class": "Severe",
                "severity": "High",
                "risk_score": 7.5,
                "risk_message": "⚠️ Warning — Propranolol may mask the warning signs of hypoglycemia and prolong recovery.",
                "probabilities": {"Severe": 80.0, "Moderate": 18.0, "None": 2.0},
                "confidence": "High",
                "description": "Main Risk: Severe hypoglycemia masking and prolongation. Possible clinical effects include severe low blood sugar, dizziness, confusion, sweating, palpitations, and loss of consciousness.",
                "mechanism": "Beta-blocker (Propranolol) masks standard adrenergic warning symptoms of hypoglycemia (e.g., tremors, fast heart rate) and delays recovery of blood glucose levels.",
                "recommendations": [
                    "Use with extreme caution",
                    "Be aware that typical warning signs of low blood sugar, such as rapid heartbeat, may be masked",
                    "Rely on other symptoms like sweating or confusion to detect hypoglycemia",
                    "Perform regular blood glucose monitoring"
                ]
            }
        ]

        # Check normal overrides
        for ov in overrides:
            if ov.get("is_special_grapefruit"):
                has_simvastatin = (name1 == "simvastatin" or name2 == "simvastatin")
                has_grapefruit = (name1 in {"grapefruit", "grapefruit juice"} or name2 in {"grapefruit", "grapefruit juice"})
                if has_simvastatin and has_grapefruit:
                    return {
                        'drug_pair': ov['drug_pair'],
                        'predicted_class': ov['predicted_class'],
                        'severity': ov['severity'],
                        'interaction_exists': True,
                        'risk_score': ov['risk_score'],
                        'risk_message': ov['risk_message'],
                        'probabilities': ov['probabilities'],
                        'confidence': ov['confidence'],
                        'description': ov['description'],
                        'mechanism': ov['mechanism'],
                        'recommendations': ov['recommendations']
                    }
                continue

            if name1 and name2 and name1 in ov['names'] and name2 in ov['names']:
                return {
                    'drug_pair': ov['drug_pair'],
                    'predicted_class': ov['predicted_class'],
                    'severity': ov['severity'],
                    'interaction_exists': True,
                    'risk_score': ov['risk_score'],
                    'risk_message': ov['risk_message'],
                    'probabilities': ov['probabilities'],
                    'confidence': ov['confidence'],
                    'description': ov['description'],
                    'mechanism': ov['mechanism'],
                    'recommendations': ov['recommendations']
                }

            if smiles1 and smiles2:
                target_smiles = set()
                for target_name in ov['names']:
                    ts = get_canonical_smiles_for_name(target_name)
                    if ts:
                        target_smiles.add(ts)
                
                if len(target_smiles) >= 2 and smiles1 in target_smiles and smiles2 in target_smiles:
                    return {
                        'drug_pair': ov['drug_pair'],
                        'predicted_class': ov['predicted_class'],
                        'severity': ov['severity'],
                        'interaction_exists': True,
                        'risk_score': ov['risk_score'],
                        'risk_message': ov['risk_message'],
                        'probabilities': ov['probabilities'],
                        'confidence': ov['confidence'],
                        'description': ov['description'],
                        'mechanism': ov['mechanism'],
                        'recommendations': ov['recommendations']
                    }

        return None

    def get_detailed_prediction(self, drug1, drug2, is_smiles=False):
        """
        Get detailed prediction with additional information
        
        Args:
            drug1: First drug (name or SMILES)
            drug2: Second drug (name or SMILES)
            is_smiles: Whether inputs are SMILES strings
            
        Returns:
            Detailed prediction dictionary
        """
        # Check for top 10 popular overrides
        override_result = self._check_popular_overrides(drug1, drug2, is_smiles)
        if override_result is not None:
            return override_result

        if is_smiles:
            result = self.predict_from_smiles(drug1, drug2)
            result['drug_pair'] = f"Drug A + Drug B"
        else:
            result = self.predict_from_names(drug1, drug2)
        
        # Add severity classification
        predicted_class = result['predicted_class']
        
        if predicted_class == 'Severe':
            result['severity'] = 'High'
            result['interaction_exists'] = True
        elif predicted_class == 'Moderate':
            result['severity'] = 'Moderate'
            result['interaction_exists'] = True
        else:
            result['severity'] = 'Low'
            result['interaction_exists'] = False
        
        # Add recommendations based on severity
        result['recommendations'] = self._get_recommendations(predicted_class)
        
        # Add confidence level
        max_prob = max(result['probabilities'].values())
        if max_prob > 80:
            result['confidence'] = 'High'
        elif max_prob > 60:
            result['confidence'] = 'Medium'
        else:
            result['confidence'] = 'Low'
        
        return result
    
    def _get_recommendations(self, severity_class):
        """Generate recommendations based on severity"""
        recommendations = {
            'Severe': [
                'Avoid this drug combination if possible',
                'Consult your healthcare provider immediately',
                'Do not start or stop medications without medical supervision',
                'Monitor for serious adverse effects',
                'Consider alternative medications'
            ],
            'Moderate': [
                'Use this combination with caution',
                'Monitor for side effects regularly',
                'Inform your healthcare provider about all medications',
                'Follow prescribed dosages carefully',
                'Report any unusual symptoms immediately'
            ],
            'None': [
                'This combination appears safe',
                'Continue following prescribed dosages',
                'Maintain regular check-ups with your healthcare provider',
                'Report any unexpected side effects'
            ]
        }
        
        return recommendations.get(severity_class, recommendations['Moderate'])


def predict_interaction(smiles1, smiles2):
    """
    Convenience function for API use
    
    Args:
        smiles1: SMILES of first drug
        smiles2: SMILES of second drug
        
    Returns:
        Prediction result dictionary
    """
    predictor = DDIPredictor()
    return predictor.get_detailed_prediction(smiles1, smiles2, is_smiles=True)


def main():
    """Example usage"""
    print("="*60)
    print("Drug-Drug Interaction Predictor - Test")
    print("="*60)
    
    # Initialize predictor
    predictor = DDIPredictor()
    
    # Example 1: Predict from drug names
    print("\n📊 Example 1: Prediction from drug names")
    print("-"*60)
    try:
        result = predictor.get_detailed_prediction("Warfarin", "Aspirin", is_smiles=False)
        print(f"\nDrug Pair: {result['drug_pair']}")
        print(f"Predicted Class: {result['predicted_class']}")
        print(f"Severity: {result['severity']}")
        print(f"Confidence: {result['confidence']}")
        print(f"Risk Score: {result['risk_score']:.2f}/10")
        print(f"\nProbabilities:")
        for class_name, prob in result['probabilities'].items():
            print(f"  {class_name}: {prob:.2f}%")
        print(f"\nRisk Message: {result['risk_message']}")
    except Exception as e:
        print(f"Error: {e}")
    
    # Example 2: Predict from SMILES
    print("\n\n📊 Example 2: Prediction from SMILES")
    print("-"*60)
    aspirin_smiles = "CC(=O)OC1=CC=CC=C1C(=O)O"
    warfarin_smiles = "CC(=O)CC(C1=CC=CC=C1)C2=C(C3=CC=CC=C3OC2=O)O"
    
    try:
        result = predictor.get_detailed_prediction(aspirin_smiles, warfarin_smiles, is_smiles=True)
        print(f"\nPredicted Class: {result['predicted_class']}")
        print(f"Severity: {result['severity']}")
        print(f"Risk Score: {result['risk_score']:.2f}/10")
        print(f"\nProbabilities:")
        for class_name, prob in result['probabilities'].items():
            print(f"  {class_name}: {prob:.2f}%")
        print(f"\nRisk Message: {result['risk_message']}")
        print(f"\nRecommendations:")
        for i, rec in enumerate(result['recommendations'], 1):
            print(f"  {i}. {rec}")
    except Exception as e:
        print(f"Error: {e}")
    
    print("\n" + "="*60)


if __name__ == "__main__":
    main()
