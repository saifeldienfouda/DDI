class TranslationHelper {
  // Description Translations
  static final Map<String, String> _descriptions = {
    // 1. Warfarin + Ibuprofen
    "Main Risk: Severe bleeding. Possible clinical effects include gastrointestinal bleeding, internal bleeding, and hemorrhagic stroke.":
        "الخطر الرئيسي: نزيف حاد. تشمل الآثار السريرية المحتملة نزيف الجهاز الهضمي، والنزيف الداخلي، والسكتة الدماغية النزفية.",
    
    // 2. Tramadol + Sertraline
    "Main Risk: Serotonin Syndrome. Possible clinical effects include fever, tremor, agitation, tachycardia (fast heart rate), and seizures.":
        "الخطر الرئيسي: متلازمة السيروتونين. تشمل الآثار السريرية المحتملة الحمى، والرعشة، والاضطراب، وتسارع ضربات القلب (Tachycardia)، والنوبات التشنجية.",
    
    // 3. Diazepam + Oxycodone
    "Main Risk: Severe respiratory depression. Possible clinical effects include extreme sedation, profound drowsiness, coma, respiratory arrest, and death.":
        "الخطر الرئيسي: تثبيط تنفسي حاد. تشمل الآثار السريرية المحتملة التخدير الشديد، النعاس العميق، الغيبوبة، توقف التنفس، والوفاة.",
    
    // 4. Phenelzine + Fluoxetine
    "Main Risk: Serotonin Syndrome / Hypertensive crisis. Possible clinical effects include hyperthermia (dangerously high body temperature), severe hypertension, confusion, muscle rigidity, and seizures.":
        "الخطر الرئيسي: متلازمة السيروتونين / نوبة ارتفاع ضغط الدم الحادة. تشمل الآثار السريرية المحتملة الارتفاع الشديد في درجة حرارة الجسم، ارتفاع ضغط الدم الحاد، الارتباك، تشنج العضلات، والنوبات التشنجية.",
    
    // 5. Nitroglycerin + Sildenafil
    "Main Risk: Severe, life-threatening hypotension (extremely low blood pressure). Possible clinical effects include syncope (fainting), shock, and cardiovascular collapse.":
        "الخطر الرئيسي: انخفاض حاد ومهدد للحياة في ضغط الدم. تشمل الآثار السريرية المحتملة الإغماء (Syncope)، الصدمة الطبية، والانهيار القلبي الوعائي.",
    
    // 6. Lithium + Naproxen
    "Main Risk: Lithium toxicity. Possible clinical effects include hand tremors, vomiting, severe diarrhea, confusion, slurred speech, and kidney dysfunction.":
        "الخطر الرئيسي: تسمم الليثيوم. تشمل الآثار السريرية المحتملة رعشة اليدين، القيء، الإسهال الشديد، الارتباك، صعوبة الكلام، واعتلال وظائف الكلى.",
    
    // 7. Digoxin + Clarithromycin
    "Main Risk: Digoxin toxicity. Possible clinical effects include cardiac arrhythmias (irregular heartbeats), nausea, vomiting, diarrhea, and visual disturbances (blurred or yellow-green vision).":
        "الخطر الرئيسي: تسمم الديجوكسين. تشمل الآثار السريرية المحتملة عدم انتظام ضربات القلب، الغثيان، القيء، الإسهال، واضطرابات الرؤية (رؤية ضبابية أو صفراء وخضراء).",
    
    // 8. Simvastatin + Grapefruit Juice
    "Main Risk: Rhabdomyolysis (muscle tissue breakdown). Possible clinical effects include muscle pain, muscle breakdown, and kidney injury.":
        "الخطر الرئيسي: انحلال العضلات المخططة (تلف الأنسجة العضلية). تشمل الآثار السريرية المحتملة ألم العضلات، تكسر العضلات، وإصابة الكلى الحادة.",
    
    // 9. Insulin + Propranolol
    "Main Risk: Severe hypoglycemia masking and prolongation. Possible clinical effects include severe low blood sugar, dizziness, confusion, sweating, palpitations, and loss of consciousness.":
        "الخطر الرئيسي: إخفاء وإطالة أمد هبوط السكر الحاد في الدم. تشمل الآثار السريرية المحتملة انخفاضاً حاداً في سكر الدم، الدوخة، الارتباك، التعرق، خفقان القلب، وفقدان الوعي.",
    
    // 10. Acetaminophen + Acetaminophen / Cold / Flu
    "Main Risk: Severe liver toxicity. Possible clinical effects include hepatic injury, jaundice, acute liver failure, and potential need for liver transplant.":
        "الخطر الرئيسي: تسمم كبدي حاد. تشمل الآثار السريرية المحتملة إصابة الكبد، اليرقان، الفشل الكبدي الحاد، والحاجة المحتملة لزراعة الكبد."
  };

  // Mechanism Translations
  static final Map<String, String> _mechanisms = {
    // 1. Warfarin + Ibuprofen
    "Increased anticoagulation + gastric mucosal irritation.":
        "زيادة تثبيط تخثر الدم + تهيج الغشاء المخاطي للمعدة.",
    
    // 2. Tramadol + Sertraline
    "Excess serotonin accumulation due to additive serotonergic effects.":
        "تراكم السيروتونين الزائد بسبب التأثيرات السيروتونينية التراكمية المشتركة.",
    
    // 3. Diazepam + Oxycodone
    "Additive central nervous system (CNS) depression.":
        "تثبيط تراكمي مضاعف للجهاز العصبي المركزي (CNS).",
    
    // 4. Phenelzine + Fluoxetine
    "Excess accumulation of monoamine neurotransmitters (serotonin and norepinephrine).":
        "تراكم مفرط للنواقل العصبية أحادية الأمين (السيروتونين والنورإبينفرين).",
    
    // 5. Nitroglycerin + Sildenafil
    "Excess vasodilation due to synergistic nitric oxide/cGMP pathway enhancement.":
        "توسع مفرط في الأوعية الدموية بسبب تعزيز المسار التآزري لأكسيد النيتريك/cGMP.",
    
    // 6. Lithium + Naproxen
    "Reduced renal lithium clearance due to NSAID-induced inhibition of renal prostaglandins.":
        "انخفاض تصفية الكلى لليثيوم نتيجة تثبيط البروستاجلاندين الكلوي الناجم عن مضادات الالتهاب غير الستيرويدية (NSAIDs).",
    
    // 7. Digoxin + Clarithromycin
    "Increased serum digoxin concentration due to inhibition of P-glycoprotein and gut flora by Clarithromycin.":
        "زيادة تركيز الديجوكسين في الدم نتيجة تثبيط بروتين P-glycoprotein وبكتيريا الأمعاء الناجم عن الكلاريثروميسين.",
    
    // 8. Simvastatin + Grapefruit Juice
    "CYP3A4 inhibition → increased statin level.":
        "تثبيط إنزيم CYP3A4 ← زيادة مستوى السيمفاستاتين في الدم لمستويات خطيرة.",
    
    // 9. Insulin + Propranolol
    "Beta-blocker (Propranolol) masks standard adrenergic warning symptoms of hypoglycemia (e.g., tremors, fast heart rate) and delays recovery of blood glucose levels.":
        "حاصرات بيتا (بروبرانولول) تخفي أعراض التحذير الأدرينالية المعتادة لهبوط السكر (مثل الرعشة وتسارع ضربات القلب) وتؤخر استعادة مستويات الجلوكوز الطبيعية.",
    
    // 10. Acetaminophen + Acetaminophen
    "Accidental cumulative overdose due to ingestion of multiple products containing the same active ingredient (Acetaminophen/Paracetamol).":
        "جرعة زائدة تراكمية غير مقصودة بسبب تناول منتجات متعددة تحتوي على نفس المادة الفعالة (الأسيتامينوفين/الباراسيتامول).",

    // Generic Mechanisms
    "The drugs may interact through multiple pathways including pharmacokinetic interactions (affecting absorption, distribution, metabolism, or excretion) and pharmacodynamic interactions (affecting drug action at target sites). These interactions can lead to synergistic toxicity or antagonistic therapeutic effects.":
        "قد تتفاعل الأدوية من خلال مسارات متعددة بما في ذلك التفاعلات الحركية الدوائية (التي تؤثر على الامتصاص أو التوزيع أو الاستقلاب أو الإخراج) والتفاعلات الديناميكية الدوائية (التي تؤثر على عمل الدواء في المواقع المستهدفة). يمكن أن تؤدي هذه التفاعلات إلى سمية تآزرية أو تأثيرات علاجية متعارضة.",
    
    "The drugs may interact through shared metabolic pathways or have additive effects on certain physiological systems. This can result in altered drug concentrations or enhanced/reduced therapeutic or adverse effects.":
        "قد تتفاعل الأدوية من خلال مسارات استقلابية مشتركة أو يكون لها تأثيرات تراكمية على أنظمة فسيولوجية معينة. يمكن أن يؤدي هذا إلى تغيير تركيزات الدواء في الجسم أو تعزيز/تقليل التأثيرات العلاجية أو الجانبية.",
    
    "Based on current pharmacological knowledge, these drugs do not appear to have significant interactions through common metabolic pathways or receptor systems. However, rare or individual-specific interactions cannot be completely ruled out.":
        "بناءً على المعرفة الصيدلانية الحالية، لا يبدو أن هذه الأدوية لها تفاعلات معنوية من خلال مسارات التمثيل الغذائي الشائعة أو أنظمة المستقبلات. ومع ذلك، لا يمكن استبعاد التفاعلات النادرة أو الخاصة بالفرد تماماً."
  };

  // Recommendation Translations
  static final Map<String, String> _recommendations = {
    // Warfarin + Ibuprofen / Digoxin / Generic Severe
    "Avoid this drug combination if possible": "تجنب الجمع بين هذين الدواءين قدر الإمكان",
    "Consult your healthcare provider immediately": "استشر مقدم الرعاية الصحية الخاص بك على الفور",
    "Do not start or stop medications without medical supervision": "لا تبدأ أو توقف الأدوية دون إشراف طبي",
    "Monitor for signs of bleeding (bruising, dark stools, nosebleeds)": "راقب علامات النزيف (مثل كدمات، براز داكن، نزيف الأنف)",
    "Consider safer alternatives for pain relief like Acetaminophen": "فكر في بدائل أكثر أماناً لتسكين الآلام مثل الأسيتامينوفين (الباراسيتامول)",
    "Monitor for serious adverse effects": "راقب عن كثب أي آثار جانبية خطيرة قد تظهر",
    "Consider alternative medications": "فكر في أدوية بديلة آمنة بالتشاور مع الطبيب",

    // Tramadol + Sertraline
    "Avoid combining these medications": "تجنب الجمع بين هذه الأدوية تماماً",
    "Consult your doctor immediately for alternatives": "استشر طبيبك فوراً للحصول على بدائل علاجية آمنة",
    "Watch closely for symptoms like confusion, rapid heart rate, muscle twitching, or heavy sweating": 
        "راقب عن كثب أعراضاً مثل الارتباك، تسارع ضربات القلب، تشنج العضلات، أو التعرق الشديد",
    "Seek emergency medical help if seizures or high fever occur": "اطلب المساعدة الطبية الطارئة فوراً في حال حدوث تشنجات أو حمى شديدة",

    // Diazepam + Oxycodone
    "Avoid combining benzodiazepines (Diazepam) and opioids (Oxycodone) unless specifically prescribed and monitored by a doctor":
        "تجنب الجمع بين البنزوديازيبينات (ديازيبام) والأفيونات (أوكسيكودون) إلا إذا تم وصفها ومراقبتها بشكل خاص من قبل الطبيب",
    "Always use the lowest effective dose": "استخدم دائماً أقل جرعة فعالة ممكنة وتحت إشراف طبي",
    "Inform family members of the risk of extreme sleepiness or difficulty breathing": "أبلغ أفراد الأسرة بخطر النعاس الشديد أو صعوبة التنفس لدى المريض",
    "Avoid alcohol and other CNS depressants": "تجنب تماماً الكحول ومثبطات الجهاز العصبي المركزي الأخرى",

    // Phenelzine + Fluoxetine
    "Contraindicated combination: DO NOT take Phenelzine (an MAOI) and Fluoxetine (an SSRI) together":
        "تركيبة يمنع استخدامها تماماً: لا تتناول فينيلزين مع فلوكسيتين معاً أبداً",
    "A washout period of at least 5 weeks is required after stopping Fluoxetine before starting Phenelzine":
        "يلزم فترة تصفية خلو من الدواء لا تقل عن 5 أسابيع بعد التوقف عن فلوكسيتين قبل البدء في فينيلزين",
    "Seek emergency medical attention immediately if symptoms occur": "اطلب العناية الطبية الطارئة على الفور إذا ظهرت أي أعراض",

    // Nitroglycerin + Sildenafil
    "Strictly Contraindicated: NEVER use Nitroglycerin (or any nitrate) and Sildenafil together":
        "ممنوع تماماً وخطير جداً: لا تستخدم النيتروجليسرين (أو أي نترات أخرى) مع السيلدينافيل معاً أبداً",
    "Ensure at least 24 hours (preferably 48 hours) between using these medications":
        "تأكد من مرور 24 ساعة على الأقل (ويفضل 48 ساعة) كفاصل زمني بين استخدام هذين الدواءين",
    "If chest pain occurs after taking Sildenafil, do NOT take Nitroglycerin and seek emergency medical care immediately":
        "إذا حدث ألم في الصدر بعد تناول السيلدينافيل، فلا تأخذ النيتروجليسرين واطلب الرعاية الطبية الطارئة فوراً",

    // Lithium + Naproxen
    "Avoid combining Lithium with NSAIDs like Naproxen if possible":
        "تجنب الجمع بين الليثيوم ومضادات الالتهاب غير الستيرويدية (NSAIDs) مثل النابروكسين إذا كان ذلك ممكناً",
    "If combined, closely monitor blood lithium levels and kidney function":
        "إذا تم الجمع بينهما، يجب مراقبة مستويات الليثيوم في الدم ووظائف الكلى بانتظام",
    "Report early signs of lithium toxicity (tremors, nausea, drowsiness) to your doctor":
        "أبلغ طبيبك فوراً بالعلامات المبكرة لتسمم الليثيوم (مثل الرعشة، الغثيان، النعاس الشديد)",

    // Digoxin + Clarithromycin
    "Avoid using Clarithromycin while taking Digoxin": "تجنب استخدام الكلاريثروميسين أثناء تناول الديجوكسين",
    "If combination is necessary, reduce Digoxin dosage and monitor serum digoxin levels closely":
        "إذا كان الجمع ضرورياً، فيجب تقليل جرعة الديجوكسين ومراقبة مستوياته في الدم بدقة",
    "Be vigilant for symptoms of toxicity and report them immediately":
        "كن يقظاً لأعراض التسمم بالديجوكسين (مثل الغثيان واضطراب الرؤية) وأبلغ عنها فوراً",

    // Simvastatin + Grapefruit Juice
    "Do not consume grapefruit juice or whole grapefruits while taking Simvastatin":
        "لا تستهلك عصير الجريب فروت أو ثمار الجريب فروت الكاملة أثناء تناول السيمفاستاتين",
    "If grapefruit consumption is desired, consult your doctor about switching to a statin not metabolized by CYP3A4 (e.g., Pravastatin or Rosuvastatin)":
        "استشر طبيبك حول الانتقال إلى دواء ستاتين لا يتم استقلابه بواسطة إنزيم CYP3A4 (مثل برافاستاتين أو روزوفاستاتين) إذا كنت ترغب في تناول الجريب فروت",
    "Report any unexplained muscle pain or tenderness immediately":
        "أبلغ عن أي ألم أو وهن عضلي غير مبرر فوراً لطبيبك المعالج",

    // Insulin + Propranolol
    "Use with extreme caution": "يستخدم مع اتخاذ أقصى درجات الحذر والحيطة",
    "Be aware that typical warning signs of low blood sugar, such as rapid heartbeat, may be masked":
        "انتبه إلى أن علامات التحذير التقليدية لانخفاض السكر في الدم (مثل خفقان وتسارع ضربات القلب) قد تكون مخفية",
    "Rely on other symptoms like sweating or confusion to detect hypoglycemia":
        "اعتمد على أعراض أخرى غير خفقان القلب، مثل التعرق البارد أو الارتباك المفاجئ للكشف عن انخفاض السكر",
    "Perform regular blood glucose monitoring": "قم بإجراء مراقبة دورية ومنتظمة لنسبة الجلوكوز في الدم",

    // Acetaminophen + Acetaminophen / Cold / Flu
    "Never take more than one product containing Acetaminophen (such as Tylenol, Panadol, or multi-symptom cold/flu remedies) concurrently.":
        "لا تتناول أبداً أكثر من منتج واحد يحتوي على الأسيتامينوفين (مثل تايلينول، بانادول، أو علاجات البرد والإنفلونزا) في نفس الوقت.",
    "Keep the total daily dose of Acetaminophen below 4,000 mg (or less if you have liver conditions or consume alcohol).":
        "حافظ على إجمالي الجرعة اليومية من الأسيتامينوفين أقل من 4000 مجم (أو أقل في حال وجود اعتلال كبدي).",
    "Always check active ingredients on product labels before combining medications.":
        "تحقق دائماً من المكونات الفعالة المكتوبة على علب الأدوية قبل الجمع بين العلاجات.",

    // Generic Moderate Recommendations
    "Use this combination with caution": "استخدم هذا المزيج من الأدوية بحذر وحيطة",
    "Monitor for side effects regularly": "راقب الآثار الجانبية بشكل منتظم ومستمر",
    "Inform your healthcare provider about all medications": "أخبر طبيبك أو الصيدلي بجميع الأدوية والمكملات التي تتناولها",
    "Follow prescribed dosages carefully": "اتبع الجرعات الطبية الموصوفة بدقة شديدة",
    "Report any unusual symptoms immediately": "أبلغ طبيبك فوراً عن أي أعراض غريبة أو غير معتادة",

    // Generic None/Low Recommendations
    "This combination appears safe": "يبدو هذا الجمع آمناً للاستخدام المشترك",
    "Continue following prescribed dosages": "استمر في اتباع الجرعات الموصوفة من قبل طبيبك",
    "Maintain regular check-ups with your healthcare provider": "حافظ على إجراء الفحوصات الدورية المعتادة مع طبيبك",
    "Report any unexpected side effects": "أبلغ عن أي آثار جانبية غير متوقعة أو جديدة"
  };

  // Sources Translations
  static final Map<String, String> _sources = {
    "DrugBank Database": "قاعدة بيانات DrugBank الدولية للأدوية",
    "AI Model Prediction (DeepDDI)": "تنبؤ نموذج الذكاء الاصطناعي السريري (DeepDDI)",
    "Pharmacological Literature": "المراجع والدراسات الصيدلانية السريرية",
    "Clinical Guidelines": "الإرشادات والتوجيهات السريرية المعتمدة"
  };

  /// Translate the description dynamically
  static String translateDescription(String description, String drugPair, bool isArabic) {
    if (!isArabic) return description;
    
    final trimmed = description.trim();
    
    // Check in exact mappings first
    if (_descriptions.containsKey(trimmed)) {
      return _descriptions[trimmed]!;
    }
    
    // Check for generic template matches
    // Severe Generic Template
    if (trimmed.contains("has been identified as having a severe interaction risk") &&
        trimmed.contains("Immediate medical consultation is strongly recommended")) {
      return "تم تحديد الجمع بين $drugPair على أنه ينطوي على مخاطر تفاعل شديدة. قد يؤدي هذا الجمع إلى آثار جانبية خطيرة تشمل زيادة السمية، أو تقليل الفعالية العلاجية، أو مضاعفات مهددة للحياة. يوصى بشدة بالاستشارة الطبية الفورية.";
    }
    
    // Moderate Generic Template
    if (trimmed.contains("shows a moderate interaction risk") &&
        trimmed.contains("Consult your healthcare provider for guidance")) {
      return "يظهر الجمع بين $drugPair مخاطر تفاعل متوسطة. قد تؤدي هذه التركيبة إلى تغيير في فعالية الدواء أو زيادة الآثار الجانبية. قد تكون المراقبة اللصيقة وتعديل الجرعة أمراً ضرورياً. استشر مقدم الرعاية الصحية الخاص بك للإرشاد.";
    }
    
    // None Generic Template
    if (trimmed.contains("appears to have minimal interaction risk") &&
        trimmed.contains("experience any unusual symptoms")) {
      return "يبدو أن الجمع بين $drugPair ينطوي على الحد الأدنى من مخاطر التفاعل بناءً على التحليل الحالي. ومع ذلك، قد تختلف العوامل الفردية لكل مريض. اتبع دائماً الجرعات الموصوفة واستشر مقدم الرعاية الصحية إذا واجهت أي أعراض غير عادية.";
    }
    
    return description; // Fallback
  }

  /// Translate the mechanism dynamically
  static String translateMechanism(String mechanism, bool isArabic) {
    if (!isArabic) return mechanism;
    final trimmed = mechanism.trim();
    return _mechanisms[trimmed] ?? mechanism;
  }

  /// Translate recommendation list
  static List<String> translateRecommendations(List<String> recommendations, bool isArabic) {
    if (!isArabic) return recommendations;
    return recommendations.map((rec) => _recommendations[rec.trim()] ?? rec).toList();
  }

  /// Translate sources list
  static List<String> translateSources(List<String> sources, bool isArabic) {
    if (!isArabic) return sources;
    return sources.map((source) => _sources[source.trim()] ?? source).toList();
  }
}
