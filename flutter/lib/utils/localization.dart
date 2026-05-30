import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'DDI Predictor',
      'search_title': 'Drug Interaction Checker',
      'search_subtitle': 'Identify potentially high-risk drug-drug interactions before prescribing.',
      'enter_drug_a': 'Enter first drug (e.g. Tramadol)',
      'enter_drug_b': 'Enter second drug (e.g. Sertraline)',
      'check_btn': 'Check Interaction',
      'history_tab': 'Saved History',
      'chat_tab': 'AI Chat Assistant',
      'settings_title': 'Settings',
      'language_name': 'العربية',
      'theme_dark': 'Dark Mode',
      'theme_light': 'Light Mode',
      'results_title': 'Interaction Results',
      'severity_high': 'High Risk',
      'severity_moderate': 'Moderate Risk',
      'severity_low': 'Low Risk',
      'severity_none': 'No Known Risk',
      'mechanism_title': 'Interaction Mechanism',
      'recommendations_title': 'Clinical Recommendations',
      'medical_disclaimer': 'Medical Disclaimer',
      'consult_disclaimer': 'This screening tool is for informational support only and does not substitute professional medical advice.',
      'server_online': 'Cloud Server Online',
      'server_offline': 'Cloud Server Offline',
      'chat_placeholder': 'Ask your clinical assistant about these results...',
      'history_empty': 'No saved interactions found.',
      'quick_actions': 'Quick Actions',
      'no_drugs_entered': 'Please enter both drug names.',
      'onboarding_title_1': 'AI DDI Predictor',
      'onboarding_desc_1': 'Screen potential drug-drug interactions with 100% precision for critical pairs.',
      'onboarding_title_2': 'Clinical AI Assistant',
      'onboarding_desc_2': 'Get professional medical advice in both English and Arabic instantly.',
      'get_started': 'Get Started',
      'skip': 'Skip',
      'next': 'Next',
      'logout': 'Sign Out',
      'auth_welcome': 'Medical Portal',
      'auth_subtitle': 'Sign in to access secure clinical history logs.',
      'email': 'Email Address',
      'password': 'Password',
      'login_btn': 'Sign In',
      'signup_btn': 'Create Account',
      'need_account': "Don't have an account? Sign Up",
      'have_account': 'Already have an account? Sign In',
      'chat_welcome': 'DDI AI Assistant',
      'chat_intro': 'I am ready to answer your clinical questions about the interactions of the drugs you check. Ask me anything in English or Arabic.',
      'recent_checks': 'Recent Checks',
      'view_details': 'View Detailed Analysis',
      'danger_warning': 'CRITICAL INTERACTION DETECTED',
      'therapeutic_alternative': 'Therapeutic Alternatives',
      'active_ingredients': 'Active Ingredients',
      'clear_all': 'Clear Screen',
    },
    'ar': {
      'app_title': 'كاشف تفاعلات الدواء',
      'search_title': 'فاحص تفاعلات الأدوية',
      'search_subtitle': 'حدد التفاعلات الدوائية المحتملة ذات الخطورة العالية قبل وصف الدواء.',
      'enter_drug_a': 'أدخل اسم الدواء الأول (مثل ترامادول)',
      'enter_drug_b': 'أدخل اسم الدواء الثاني (مثل سيرترالين)',
      'check_btn': 'افحص التفاعل الدوائي',
      'history_tab': 'السجل المحفوظ',
      'chat_tab': 'مساعد المحادثة الذكي',
      'settings_title': 'الإعدادات',
      'language_name': 'English',
      'theme_dark': 'الوضع الداكن',
      'theme_light': 'الوضع المضيء',
      'results_title': 'نتائج فحص التفاعل',
      'severity_high': 'خطورة عالية جداً',
      'severity_moderate': 'خطورة متوسطة',
      'severity_low': 'خطورة منخفضة',
      'severity_none': 'لا توجد خطورة معروفة',
      'mechanism_title': 'آلية التفاعل الدوائي',
      'recommendations_title': 'التوصيات السريرية',
      'medical_disclaimer': 'تنبيه طبي مهم',
      'consult_disclaimer': 'هذه الأداة هي للدعم المعلوماتي فقط ولا تغني عن الاستشارة الطبية المهنية المتخصصة.',
      'server_online': 'الخادم السحابي متصل',
      'server_offline': 'الخادم السحابي غير متصل',
      'chat_placeholder': 'اسأل المساعد الطبي عن هذه النتائج...',
      'history_empty': 'لا توجد تفاعلات محفوظة بالسجل.',
      'quick_actions': 'العمليات السريعة',
      'no_drugs_entered': 'يرجى إدخال اسم الدواءين معاً.',
      'onboarding_title_1': 'كاشف التفاعلات الذكي',
      'onboarding_desc_1': 'افحص التفاعلات الدوائية المحتملة بدقة تصل إلى ١٠٠٪ للحالات الحرجة.',
      'onboarding_title_2': 'المساعد الطبي الذكي',
      'onboarding_desc_2': 'احصل على إرشادات وتوصيات سريرية فورية باللغتين العربية والإنجليزية.',
      'get_started': 'ابدأ الآن',
      'skip': 'تخطي',
      'next': 'التالي',
      'logout': 'تسجيل الخروج',
      'auth_welcome': 'البوابة الطبية الآمنة',
      'auth_subtitle': 'سجل دخولك للوصول إلى سجل التفاعلات الدوائية السريري الخاص بك.',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'login_btn': 'تسجيل الدخول',
      'signup_btn': 'إنشاء حساب جديد',
      'need_account': "ليس لديك حساب؟ سجل الآن",
      'have_account': 'لديك حساب بالفعل؟ سجل دخولك',
      'chat_welcome': 'مساعد التفاعلات الدوائية الذكي',
      'chat_intro': 'أنا مستعد للإجابة على أسئلتك السريرية حول تفاعلات الأدوية التي تفحصها. اسألني أي شيء بالعربية أو الإنجليزية.',
      'recent_checks': 'الفحوصات الأخيرة',
      'view_details': 'عرض التحليل التفصيلي',
      'danger_warning': 'تحذير: تم الكشف عن تفاعل دوائي حرج!',
      'therapeutic_alternative': 'البدائل العلاجية الآمنة',
      'active_ingredients': 'المكونات الفعالة',
      'clear_all': 'مسح الشاشة',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return AppLocalizations(languageProvider.locale);
  }
}

extension BuildContextExtension on BuildContext {
  String translate(String key) {
    return AppLocalizations.of(this).translate(key);
  }
  
  bool get isArabic => Provider.of<LanguageProvider>(this).isArabic;
}
