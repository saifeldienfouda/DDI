import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils/localization.dart';
import 'terms_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = context.isArabic;

    final List<OnboardingPage> pages = [
      OnboardingPage(
        icon: Icons.psychology_rounded,
        title: isAr ? 'تحليل سريري بالذكاء الاصطناعي' : 'AI-Powered Analysis',
        description: isAr 
            ? 'تقوم خوارزميات الذكاء الاصطناعي المتقدمة بفحص التفاعلات الدوائية بدقة ٩٣.٨٪.' 
            : 'Advanced machine learning algorithms analyze drug interactions with 93.8% accuracy',
        gradient: isDark 
            ? const [Color(0xFF0F172A), const Color(0xFF1E293B)] 
            : const [Color(0xFF667eea), const Color(0xFF764ba2)],
      ),
      OnboardingPage(
        icon: Icons.medication_rounded,
        title: isAr ? 'أكثر من ٤,٢00 دواء' : '4,286+ Drugs Database',
        description: isAr 
            ? 'قاعدة بيانات طبية شاملة تغطي آلاف الأدوية والمواد الفعالة وتفاعلاتها.' 
            : 'Comprehensive database covering thousands of medications and their interactions',
        gradient: isDark 
            ? const [Color(0xFF1E293B), const Color(0xFF312E81)] 
            : const [Color(0xFFf093fb), const Color(0xFFf5576c)],
      ),
      OnboardingPage(
        icon: Icons.speed_rounded,
        title: isAr ? 'نتائج فورية ولحظية' : 'Instant Results',
        description: isAr 
            ? 'احصل على تحليل تفصيلي للتفاعل الدوائي في أقل من ثانية بدقة متناهية.' 
            : 'Get detailed interaction analysis in less than a second with cloud sync',
        gradient: isDark 
            ? const [Color(0xFF0F172A), const Color(0xFF1E1B4B)] 
            : const [Color(0xFF4facfe), const Color(0xFF00f2fe)],
      ),
      OnboardingPage(
        icon: Icons.cloud_done_rounded,
        title: isAr ? 'مزامنة سحابية آمنة' : 'Cloud Backup',
        description: isAr 
            ? 'يتم حفظ وتشفير سجل عمليات الفحص الخاصة بك سحابياً للوصول إليها بأمان.' 
            : 'Your interaction history is safely stored and synced across all your devices',
        gradient: isDark 
            ? const [Color(0xFF1E293B), const Color(0xFF0F172A)] 
            : const [Color(0xFF43e97b), const Color(0xFF38f9d7)],
      ),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: pages[_currentPage].gradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: isAr ? Alignment.topLeft : Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => _navigateToTerms(),
                    child: Text(
                      isAr ? 'تخطي' : 'Skip',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(pages[index]);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _buildIndicator(index == _currentPage),
                ),
              ),
              const SizedBox(height: 32),

              // Next/Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_currentPage == pages.length - 1) {
                              _navigateToTerms();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Center(
                              child: Text(
                                _currentPage == pages.length - 1
                                    ? (isAr ? 'ابدأ الآن' : 'Get Started')
                                    : (isAr ? 'التالي' : 'Next'),
                                style: const TextStyle(
                                  color: Colors.white,
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 600;
        final iconSize = isSmallScreen ? 120.0 : 160.0;
        final titleSize = isSmallScreen ? 26.0 : 32.0;
        final descSize = isSmallScreen ? 14.0 : 16.0;
        
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.1,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glassmorphic icon container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          page.icon,
                          size: iconSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 40 : 60),

                  // Title
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Description
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: descSize,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _navigateToTerms() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TermsScreen()),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
