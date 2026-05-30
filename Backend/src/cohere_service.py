"""
Cohere AI Service for Chat Assistant
Provides bilingual (Arabic/English) chat support for DDI results
"""

import os
import json
from typing import List, Dict, Optional
from datetime import datetime

import cohere


class CohereChatService:
    """
    Service for handling AI chat using Cohere (command-r model by default).
    """
    
    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize Cohere service
        
        Args:
            api_key: Cohere API key (if None, reads from env `COHERE_API_KEY`)
        """
        # Prefer explicit api_key, otherwise read from env
        self.api_key = api_key or os.getenv('COHERE_API_KEY')
        if not self.api_key:
            raise ValueError("COHERE_API_KEY not found in environment variables")
        
        # Initialize Cohere client
        self.client = cohere.Client(self.api_key)
        
        # Default model - can be overridden via env if needed.
        # Latest recommended chat model: `command-a-03-2025`
        self.model = os.getenv('COHERE_MODEL', 'command-a-03-2025')
        
        # System prompt for DDI assistant
        self.system_prompt = """You are a helpful medical AI assistant specialized in Drug-Drug Interactions (DDI).
Your role is to help users understand drug interaction results and answer their questions clearly.

IMPORTANT GUIDELINES:
1. Always provide responses in BOTH Arabic and English
2. Format your response with clear sections: "🇬🇧 English:" and "🇦🇪 Arabic:"
3. Use markdown formatting for better readability:
   - Use **bold** for important terms
   - Use bullet points (•) for lists
   - Use numbered lists for steps
   - Keep paragraphs short and clear
4. Answer the user's SPECIFIC question - don't just repeat the summary
5. Be conversational and natural - if they ask about side effects, talk about side effects
6. If they ask about alternatives, dosage, timing, or anything else, answer that directly
7. Always emphasize consulting healthcare professionals for medical decisions
8. Be empathetic and understanding

When the user asks a question:
- Answer their SPECIFIC question first
- Provide relevant details
- Give practical advice
- Only mention the interaction context if relevant to their question

Remember: You are providing information, not medical advice. Be helpful and conversational."""

    def generate_initial_summary(self, interaction_data: Dict) -> Dict[str, str]:
        """
        Generate bilingual summary of interaction result
        
        Args:
            interaction_data: Dictionary containing interaction details
            
        Returns:
            Dictionary with 'english' and 'arabic' summaries
        """
        try:
            # Extract key information
            drug_pair = interaction_data.get('drug_pair', 'Unknown drugs')
            severity = interaction_data.get('severity', 'Unknown')
            description = interaction_data.get('description', '')
            risk_score = interaction_data.get('risk_score', 0)
            recommendations = interaction_data.get('recommendations', [])
            
            # Create prompt for summary
            prompt = f"""Please provide a clear, bilingual summary of this drug interaction result.

INTERACTION DETAILS:
- Drug Pair: {drug_pair}
- Severity: {severity}
- Risk Score: {risk_score:.2f}
- Description: {description}
- Recommendations: {', '.join(recommendations)}

Please create a summary that:
1. Starts with a greeting
2. Explains what was analyzed
3. States the severity level clearly
4. Explains what this means for the user
5. Provides key recommendations
6. Encourages questions

Format your response with:
🇬🇧 English:
[Your English summary here]

🇦🇪 Arabic:
[Your Arabic summary here]"""

            # Generate response using Cohere
            response = self.client.chat(
                model=self.model,
                message=prompt,
                temperature=0.7,
            )
            
            # Parse response
            full_text = response.text
            
            # Split into English and Arabic
            english_summary = ""
            arabic_summary = ""
            
            if "🇬🇧 English:" in full_text and "🇦🇪 Arabic:" in full_text:
                parts = full_text.split("🇦🇪 Arabic:")
                english_part = parts[0].replace("🇬🇧 English:", "").strip()
                arabic_part = parts[1].strip() if len(parts) > 1 else ""
                
                english_summary = english_part
                arabic_summary = arabic_part
            else:
                # Fallback if format not followed
                english_summary = full_text
                arabic_summary = "الرجاء طرح سؤالك وسأجيب باللغة العربية"
            
            return {
                'english': english_summary,
                'arabic': arabic_summary,
                'full_text': full_text,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            print(f"Error generating summary: {e}")
            return {
                'english': "Hello! I'm here to help you understand this drug interaction. Please feel free to ask any questions.",
                'arabic': "مرحباً! أنا هنا لمساعدتك في فهم هذا التفاعل الدوائي. لا تتردد في طرح أي أسئلة.",
                'full_text': "",
                'error': str(e)
            }
    
    def chat(self, message: str, interaction_context: Dict, chat_history: List[Dict] = None) -> Dict[str, str]:
        """
        Handle chat message with context
        
        Args:
            message: User's message
            interaction_context: Current interaction data for context
            chat_history: Previous chat messages
            
        Returns:
            Dictionary with AI response
        """
        try:
            # Build context
            drug_pair = interaction_context.get('drug_pair', 'Unknown drugs')
            severity = interaction_context.get('severity', 'Unknown')
            description = interaction_context.get('description', '')
            
            # Create conversation context
            context = f"""CURRENT INTERACTION CONTEXT:
- Drugs: {drug_pair}
- Severity: {severity}
- Details: {description}

The user is asking about this specific interaction. Please provide helpful, accurate information in both Arabic and English."""

            # Build a simple conversation history string (Cohere can take previous messages,
            # but to keep it simple and robust we just include recent turns in the prompt)
            history_text = ""
            if chat_history:
                for msg in chat_history[-5:]:  # Last 5 messages for context
                    role = "User" if msg.get('role') == 'user' else "Assistant"
                    content = msg.get('content', '')
                    history_text += f"{role}: {content}\n"
            
            full_prompt = (
                f"{self.system_prompt}\n\n"
                f"{context}\n\n"
                f"{history_text}User: {message}\nAssistant:"
            )
            
            # Send message via Cohere
            response = self.client.chat(
                model=self.model,
                message=full_prompt,
                temperature=0.8,
            )
            
            return {
                'response': response.text,
                'timestamp': datetime.now().isoformat(),
                'success': True
            }
            
        except Exception as e:
            print(f"Error in chat: {e}")
            return {
                'response': f"🇬🇧 English: I apologize, but I encountered an error. Please try again.\n\n🇦🇪 Arabic: أعتذر، لكن حدث خطأ. يرجى المحاولة مرة أخرى.",
                'timestamp': datetime.now().isoformat(),
                'success': False,
                'error': str(e)
            }
    
    def detect_language(self, text: str) -> str:
        """
        Detect if text is primarily Arabic or English
        
        Args:
            text: Input text
            
        Returns:
            'ar' for Arabic, 'en' for English
        """
        arabic_chars = sum(1 for c in text if '\u0600' <= c <= '\u06FF')
        total_chars = len([c for c in text if c.isalpha()])
        
        if total_chars == 0:
            return 'en'
        
        arabic_ratio = arabic_chars / total_chars
        return 'ar' if arabic_ratio > 0.3 else 'en'


# Test function
if __name__ == "__main__":
    # Test the service
    try:
        service = CohereChatService()
        
        # Test interaction data
        test_interaction = {
            'drug_pair': 'Aspirin and Warfarin',
            'severity': 'Severe',
            'risk_score': 0.92,
            'description': 'High risk of bleeding when combined',
            'recommendations': [
                'Consult your doctor immediately',
                'Monitor for signs of bleeding',
                'Do not adjust doses without medical supervision'
            ]
        }
        
        print("Testing Cohere Chat Service...")
        print("\n" + "="*60)
        print("Generating initial summary...")
        print("="*60)
        
        summary = service.generate_initial_summary(test_interaction)
        print("\n🇬🇧 English Summary:")
        print(summary['english'])
        print("\n🇦🇪 Arabic Summary:")
        print(summary['arabic'])
        
        print("\n" + "="*60)
        print("Testing chat...")
        print("="*60)
        
        response = service.chat(
            "What should I do if I'm already taking both?",
            test_interaction
        )
        print("\nResponse:")
        print(response['response'])
        
        print("\n✅ Service test completed successfully!")
        
    except Exception as e:
        print(f"❌ Test failed: {e}")
