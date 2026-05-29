import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConstants {
  // ============================================
  // BASE URL CONFIGURATION
  // ============================================
  // 
  // For Android Emulator: http://10.0.2.2:5000 (already set)
  // For iOS Simulator: http://localhost:5000 (already set)
  // For Physical Device: Update _physicalDeviceUrl with your PC's IP
  //
  // To find your PC's IP: Run "ipconfig" in PowerShell, look for IPv4 Address
  // Example: If your IP is 192.168.1.9, use: http://192.168.1.9:5000
  // ============================================
  
  // Development URLs (for local backend testing)
  static const String _emulatorUrl = 'http://10.0.2.2:5000'; // Android emulator
  static const String _simulatorUrl = 'http://localhost:5000'; // iOS simulator
  // Run "ipconfig" on Windows and use your Wi-Fi IPv4 (same network as the phone)
              static const String _physicalDeviceUrl = 'http://';

  /// true = real phone / USB debug on device. false = Android emulator (10.0.2.2).
  static const bool usePhysicalDeviceBackend = true;

  // Production URL (for deployed backend - leave as is for now)
  static const String _productionUrl = 'https://your-backend-domain.com'; // Not used yet

  // Get base URL based on environment
  static String get baseUrl {
    if (kIsWeb) {
      return _simulatorUrl;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return usePhysicalDeviceBackend ? _physicalDeviceUrl : _emulatorUrl;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _simulatorUrl;
    }

    return _emulatorUrl;
  }
  
  // Helper method to get physical device URL (for APK builds)
  // When building APK for physical device, temporarily change baseUrl getter to return this
  static String get physicalDeviceUrl => _physicalDeviceUrl;
  
  static String get apiBaseUrl => baseUrl; // For chat service
  static const String checkInteractionEndpoint = '/check-interaction';
  static const String searchDrugsEndpoint = '/search-drugs';
  static const String healthEndpoint = '/health';

  // Severity Colors - More vibrant and modern
  static const Color lowColor = Color(0xFF10B981); // Emerald green
  static const Color moderateColor = Color(0xFFF59E0B); // Amber
  static const Color highColor = Color(0xFFEF4444); // Red
  static const Color unknownColor = Color(0xFF6B7280); // Gray

  // UI constants
  static const double padding = 16.0;
  static const double radius = 12.0;
  static const double elevation = 2.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 600);
  static const Duration longAnimation = Duration(milliseconds: 1500);

  // Error messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverOffline = 'Server seems offline.';

  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return lowColor;
      case 'moderate':
        return moderateColor;
      case 'high':
        return highColor;
      default:
        return unknownColor;
    }
  }
}
