import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import '../utils/theme.dart';
import '../utils/localization.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        // Sign in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        // Sign up
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        // Update display name
        if (_nameController.text.isNotEmpty) {
          await userCredential.user?.updateDisplayName(_nameController.text.trim());
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = context.isArabic 
            ? 'حدث خطأ ما. يرجى المحاولة مرة أخرى.' 
            : 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getErrorMessage(String code) {
    final isAr = context.isArabic;
    switch (code) {
      case 'user-not-found':
        return isAr ? 'لا يوجد مستخدم مسجل بهذا البريد.' : 'No user found with this email.';
      case 'wrong-password':
        return isAr ? 'كلمة المرور غير صحيحة.' : 'Wrong password provided.';
      case 'email-already-in-use':
        return isAr ? 'هذا البريد الإلكتروني مستخدم بالفعل.' : 'An account already exists with this email.';
      case 'invalid-email':
        return isAr ? 'بريد إلكتروني غير صالح.' : 'Invalid email address.';
      case 'weak-password':
        return isAr ? 'كلمة المرور ضعيفة جداً، يجب ألا تقل عن ٦ أحرف.' : 'Password should be at least 6 characters.';
      default:
        return isAr ? 'فشلت عملية التحقق. يرجى المحاولة مرة أخرى.' : 'Authentication failed. Please try again.';
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = context.isArabic 
            ? 'فشل الدخول كزائر.' 
            : 'Failed to sign in anonymously.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0E1A),
                    const Color(0xFF141929),
                    const Color(0xFF1C1040),
                    const Color(0xFF0E0A2A),
                  ]
                : [
                    const Color(0xFF667eea),
                    const Color(0xFF764ba2),
                    const Color(0xFFA78BFA),
                    const Color(0xFF6366F1),
                  ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkSurfaceVariant : Colors.white,
                        shape: BoxShape.circle,
                        border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      context.translate('app_title'),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.isArabic 
                          ? 'تحليل التفاعلات الدوائية سريرياً بالذكاء الاصطناعي' 
                          : 'AI-Powered Drug Interaction Analysis',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Auth Form Card with Glassmorphism
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: AppTheme.cardDecoration(isDark, borderRadius: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _isLogin 
                                  ? (context.isArabic ? 'مرحباً بك مجدداً' : 'Welcome Back') 
                                  : (context.isArabic ? 'إنشاء حساب جديد' : 'Create Account'),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                                const SizedBox(height: 24),

                                // Name field (only for sign up)
                                if (!_isLogin) ...[
                              TextFormField(
                                controller: _nameController,
                                style: TextStyle(color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                                decoration: InputDecoration(
                                  labelText: context.isArabic ? 'الاسم الكامل' : 'Full Name',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  labelStyle: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                                  prefixIconColor: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                ),
                                    textInputAction: TextInputAction.next,
                                  ),
                              const SizedBox(height: 16),
                            ],

                                // Email field
                            TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                              decoration: InputDecoration(
                                labelText: context.isArabic ? 'البريد الإلكتروني' : 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                labelStyle: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                                prefixIconColor: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                              ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return context.isArabic ? 'يرجى إدخال بريد إلكتروني صحيح' : 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Password field
                            TextFormField(
                              controller: _passwordController,
                              style: TextStyle(color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                              decoration: InputDecoration(
                                labelText: context.isArabic ? 'كلمة المرور' : 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                labelStyle: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                                prefixIconColor: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                              ),
                                  obscureText: true,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submitForm(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return context.isArabic 
                                          ? 'يجب أن لا تقل كلمة المرور عن ٦ أحرف' 
                                          : 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Error message
                                if (_errorMessage != null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: const TextStyle(color: Colors.red, fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Submit button
                                ElevatedButton(
                                  onPressed: _isLoading ? null : () {
                                    HapticFeedback.lightImpact();
                                    _submitForm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Lottie.asset(
                                            'assets/animations/Loading Dots Blue.json',
                                            width: 60,
                                            height: 24,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Text(
                                          _isLogin 
                                              ? (context.isArabic ? 'تسجيل الدخول' : 'Sign In') 
                                              : (context.isArabic ? 'إنشاء الحساب' : 'Sign Up'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 16),

                                // Toggle between login/signup
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                            _errorMessage = null;
                                          });
                                        },
                                  child: Text(
                                    _isLogin
                                        ? (context.isArabic 
                                            ? 'ليس لديك حساب؟ سجل الآن' 
                                            : "Don't have an account? Sign Up")
                                        : (context.isArabic 
                                            ? 'لديك حساب بالفعل؟ سجل دخولك' 
                                            : 'Already have an account? Sign In'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? AppTheme.accentColor : AppTheme.primaryColor,
                                    ),
                                  ),
                                ),

                                // Divider
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: [
                                      const Expanded(child: Divider()),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          context.isArabic ? 'أو' : 'OR', 
                                          style: TextStyle(color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                                        ),
                                      ),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                ),

                                // Continue as guest
                                OutlinedButton.icon(
                                  onPressed: _isLoading ? null : () {
                                    HapticFeedback.lightImpact();
                                    _signInAnonymously();
                                  },
                                  icon: Icon(Icons.person_outline, color: isDark ? AppTheme.darkTextSecondary : AppTheme.primaryColor),
                                  label: Text(
                                    context.isArabic ? 'الدخول كزائر' : 'Continue as Guest',
                                    style: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.primaryColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(
                                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder, 
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
