import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/localization.dart';
import 'home_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;

    final List<TutorialPage> pages = [
      TutorialPage(
        title: isAr ? 'مرحباً بك في كاشف تفاعلات الدواء' : 'Welcome to PredictDDI',
        description: isAr 
            ? 'أداتك الطبية المتطورة القائمة على الذكاء الاصطناعي لفحص وتوقع التفاعلات الدوائية بدقة وموثوقية متناهية.' 
            : 'Your advanced AI-powered tool for predicting drug-drug interactions with high accuracy and reliability.',
        icon: Icons.medical_services,
      ),
      TutorialPage(
        title: isAr ? 'توقعات ذكية ودقيقة' : 'Smart Predictions',
        description: isAr 
            ? 'يقوم الذكاء الاصطناعي المتعدد النماذج بتحليل التراكيب الدوائية والمكونات الفعالة لتوقع تفاعلات الأدوية فوراً.' 
            : 'Our multimodal AI analyzes complex molecular structures and interactions to provide accurate DDI predictions.',
        icon: Icons.psychology,
      ),
      TutorialPage(
        title: isAr ? 'تحليل مبني على الأدلة العلمية' : 'Evidence-Based Results',
        description: isAr 
            ? 'احصل على تحليل تفصيلي كامل يشمل مستويات الخطورة، آليات التفاعل، والتوصيات السريرية والبدائل الآمنة.' 
            : 'Get detailed interaction analysis with severity levels, mechanisms, and clinical recommendations.',
        icon: Icons.analytics,
      ),
      TutorialPage(
        title: isAr ? 'بوابة طبية سريرية آمنة' : 'Professional Tool',
        description: isAr 
            ? 'مصمم خصيصاً لأخصائيي الرعاية الصحية والأطباء لاتخاذ قرارات سريرية مستنيرة حول سلامة مزج الأدوية.' 
            : 'Designed for healthcare professionals to make informed decisions about drug combinations.',
        icon: Icons.verified_user,
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF8FAFC), const Color(0xFFEEF2FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _numPages,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        _numPages,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: _currentPage == index
                                ? const LinearGradient(
                                    colors: [AppTheme.gradientStart, AppTheme.gradientEnd],
                                  )
                                : null,
                            color: _currentPage == index
                                ? null
                                : (isDark ? Colors.white12 : Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _numPages - 1 
                                ? context.translate('get_started') 
                                : context.translate('next'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentPage == _numPages - 1
                                ? Icons.check_circle
                                : (context.isArabic ? Icons.arrow_back : Icons.arrow_forward),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const TutorialPage({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.gradientStart, AppTheme.gradientEnd],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isDark ? Colors.white70 : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}