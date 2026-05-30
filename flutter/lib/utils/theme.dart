import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand Colors (shared) ───
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color gradientStart = Color(0xFF6366F1);
  static const Color gradientEnd = Color(0xFF8B5CF6);

  // ─── Dark Palette ───
  static const Color darkBg = Color(0xFF0A0E1A);
  static const Color darkSurface = Color(0xFF141929);
  static const Color darkSurfaceVariant = Color(0xFF1C2237);
  static const Color darkBorder = Color(0xFF252B3F);
  static const Color darkTextPrimary = Color(0xFFE8ECF4);
  static const Color darkTextSecondary = Color(0xFFA0AABF);
  static const Color darkTextMuted = Color(0xFF6B7590);

  // ─── Light Palette ───
  static const Color lightBg = Color(0xFFF6F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F3F9);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // ─── Primary Swatch ───
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF6366F1,
    <int, Color>{
      50: Color(0xFFEEF2FF),
      100: Color(0xFFE0E7FF),
      200: Color(0xFFC7D2FE),
      300: Color(0xFFA5B4FC),
      400: Color(0xFF818CF8),
      500: Color(0xFF6366F1),
      600: Color(0xFF4F46E5),
      700: Color(0xFF4338CA),
      800: Color(0xFF3730A3),
      900: Color(0xFF312E81),
    },
  );

  // ─── Helpers ───

  /// Background gradient for dark mode screens
  static List<Color> get darkGradientBg =>
      [darkBg, const Color(0xFF0E1425), darkSurface];

  /// Background gradient for light mode screens
  static List<Color> get lightGradientBg =>
      [const Color(0xFFEEF2FF), lightBg, const Color(0xFFF1F5F9)];

  /// Glassmorphic decoration for dark mode containers
  static BoxDecoration darkGlass({double opacity = 0.7, double borderRadius = 20}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          darkSurfaceVariant.withOpacity(opacity),
          darkSurface.withOpacity(opacity * 0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(0.06),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: primaryColor.withOpacity(0.04),
          blurRadius: 40,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Glassmorphic decoration for light mode containers
  static BoxDecoration lightGlass({double opacity = 0.85, double borderRadius = 20}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.9),
        ],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: const Color(0xFFE2E8F0),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withOpacity(0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Card decoration for either mode
  static BoxDecoration cardDecoration(bool isDark, {double borderRadius = 20}) {
    return isDark
        ? darkGlass(borderRadius: borderRadius)
        : lightGlass(borderRadius: borderRadius);
  }

  // ═══════════════════════════════════════
  //  LIGHT THEME
  // ═══════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        onSurface: lightTextPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: lightTextPrimary,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary),
        hintStyle: const TextStyle(color: lightTextMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(
            color: lightBorder,
            width: 1.5,
          ),
          foregroundColor: primaryColor,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: primaryColor,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightSurfaceVariant,
        labelStyle: const TextStyle(color: lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: lightBorder),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: lightTextPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        space: 1,
        thickness: 1,
        color: lightBorder,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: lightBorder),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lightSurface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  // ═══════════════════════════════════════
  //  DARK THEME
  // ═══════════════════════════════════════
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        onSurface: darkTextPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: darkTextPrimary,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: darkBorder.withOpacity(0.6)),
        ),
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.8),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: const TextStyle(color: darkTextMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(
            color: darkBorder,
            width: 1.5,
          ),
          foregroundColor: darkTextPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: primaryColor,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceVariant,
        labelStyle: const TextStyle(color: darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: darkBorder),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: darkSurfaceVariant,
        contentTextStyle: const TextStyle(color: darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        space: 1,
        thickness: 1,
        color: darkBorder.withOpacity(0.5),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: darkSurfaceVariant,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkBorder.withOpacity(0.5)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}