import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/theme.dart';
import '../utils/localization.dart';
import 'auth_screen.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;

    final termsPoints = isAr
        ? [
            'كاشف تفاعلات الدواء هو أداة معلومات طبية مصممة لمساعدة أخصائيي الرعاية الصحية.',
            'يوفر هذا التطبيق تنبؤات تفاعلية للأدوية مدعومة بالذكاء الاصطناعي بناءً على بيانات علمية ونماذج تعلم الآلة.',
            'المعلومات المقدمة لا يجب أن تحل محل الاستشارة الطبية المهنية المتخصصة أو التشخيص أو العلاج.',
            'استشر دائماً أخصائيي الرعاية الصحية المؤهلين قبل اتخاذ أي قرارات طبية.',
            'يتحمل المستخدمون مسؤولية التحقق من جميع المعلومات بشكل مستقل قبل التطبيق السريري.',
          ]
        : [
            'Predict DDIs is a medical information tool designed for healthcare professionals.',
            'This application provides AI-powered drug interaction predictions based on scientific data and machine learning models.',
            'The information provided should not replace professional medical advice, diagnosis, or treatment.',
            'Always consult with qualified healthcare providers before making medical decisions.',
            'Users are responsible for verifying all information before clinical application.',
          ];

    final disclaimerPoints = isAr
        ? [
            'هذا التطبيق للأغراض المعلوماتية والدعم الطبي فقط ولا يغني عن الاستشارة الطبية المهنية.',
            'تنبؤات الذكاء الاصطناعي ذات دقة عالية تبلغ ٩٣.٨٪ ولكنها ليست مضمونة بنسبة ١٠٠٪.',
            'يمكن أن تختلف تفاعلات الأدوية بناءً على العوامل الفردية والتاريخ المرضي لكل مريض.',
            'تتطلب الحالات الطارئة رعاية طبية فورية وعاجلة دون تأخير.',
            'نحن غير مسؤولين عن أي قرارات طبية أو تشخيصية تُتخذ بناءً على هذه المعلومات.',
          ]
        : [
            'This app is for informational purposes only and is not a substitute for professional medical advice.',
            'The AI predictions have 93.8% accuracy but are not 100% guaranteed.',
            'Drug interactions can vary based on individual patient factors.',
            'Emergency situations require immediate medical attention.',
            'We are not liable for any decisions made based on this information.',
          ];

    final privacyPoints = isAr
        ? [
            'نحن نجمع ونخزن سجل تفاعلاتك الطبية بشكل آمن تماماً ومشفر سحابياً.',
            'بياناتك مشفرة ومحمية باستخدام أحدث معايير الأمان التكنولوجية السحابية.',
            'نحن لا نشارك أي معلومات شخصية أو بيانات طبية خاصة بك مع أي طرف ثالث.',
            'يمكنك حذف سجل عمليات الفحص الخاص بك بالكامل في أي وقت من إعدادات حسابك.',
            'نحن نستخدم خدمات فايربيس السحابية الآمنة لإدارة الحسابات وتخزين البيانات.',
            'قد يتم جمع تحليلات استخدام مجهولة الهوية فقط لتحسين أداء وجودة التطبيق.',
          ]
        : [
            'We collect and store your interaction history securely in the cloud.',
            'Your data is encrypted and protected using industry-standard security.',
            'We do not share your personal information with third parties.',
            'You can delete your data at any time from your account settings.',
            'We use Firebase for authentication and data storage.',
            'Anonymous usage analytics may be collected to improve the app.',
          ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFF667eea), const Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.gavel_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isAr ? 'الشروط والخصوصية' : 'Terms & Privacy',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr ? 'يرجى مراجعة وقبول الشروط الطبية والمصطلحات' : 'Please review and accept',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B).withOpacity(0.7) : Colors.white.withOpacity(0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection(
                              isAr ? 'شروط الاستخدام والضوابط السريرية' : 'Terms of Use',
                              termsPoints,
                              isAr,
                            ),
                            const SizedBox(height: 24),
                            _buildSection(
                              isAr ? 'إخلاء المسؤولية الطبي المهم' : 'Medical Disclaimer',
                              disclaimerPoints,
                              isAr,
                            ),
                            const SizedBox(height: 24),
                            _buildSection(
                              isAr ? 'سياسة الخصوصية وأمن البيانات' : 'Privacy Policy',
                              privacyPoints,
                              isAr,
                            ),
                            const SizedBox(height: 32),

                            // Checkboxes
                            _buildCheckbox(
                              isAr ? 'أوافق على شروط الاستخدام وإخلاء المسؤولية الطبي المذكور' : 'I agree to the Terms of Use and Medical Disclaimer',
                              _agreedToTerms,
                              isDark,
                              (value) => setState(() => _agreedToTerms = value!),
                            ),
                            const SizedBox(height: 16),
                            _buildCheckbox(
                              isAr ? 'أوافق على بنود سياسة الخصوصية وحماية البيانات الطبية' : 'I agree to the Privacy Policy',
                              _agreedToPrivacy,
                              isDark,
                              (value) => setState(() => _agreedToPrivacy = value!),
                            ),
                            const SizedBox(height: 32),

                            // Accept button
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: (_agreedToTerms && _agreedToPrivacy)
                                          ? Colors.white.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: (_agreedToTerms && _agreedToPrivacy)
                                            ? () async {
                                                final prefs = await SharedPreferences.getInstance();
                                                await prefs.setBool('terms_accepted', true);
                                                await prefs.setBool('onboarding_complete', true);
                                                
                                                if (mounted) {
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (_) => const AuthScreen(),
                                                    ),
                                                  );
                                                }
                                              }
                                            : null,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          child: Center(
                                            child: Text(
                                              isAr ? 'قبول ومتابعة' : 'Accept & Continue',
                                              style: TextStyle(
                                                color: (_agreedToTerms && _agreedToPrivacy)
                                                    ? Colors.white
                                                    : Colors.white.withOpacity(0.5),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points, bool isAr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 6, 
                      right: isAr ? 0 : 8, 
                      left: isAr ? 8 : 0,
                    ),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildCheckbox(String text, bool value, bool isDark, Function(bool?) onChanged) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return Colors.white.withOpacity(0.3);
                  }),
                  checkColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF667eea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
