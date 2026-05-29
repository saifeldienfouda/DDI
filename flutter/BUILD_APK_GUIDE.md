# 📦 Building APK - Complete Guide

## 🎯 Understanding the Problem

When you build an APK and install it on a physical device:
- ❌ `10.0.2.2` won't work (that's only for Android emulator)
- ❌ `localhost` won't work (device can't access your PC's localhost)
- ✅ You need your **PC's actual IP address** on the local network
- ✅ Or a **deployed backend URL** for production

---

## 🔧 Solution: Environment-Aware Configuration

I've updated `constants.dart` to automatically handle different scenarios:

### **For Development (Debug Build):**
- **Android Emulator**: `http://10.0.2.2:5000` ✅
- **iOS Simulator**: `http://localhost:5000` ✅
- **Physical Device**: `http://192.168.1.9:5000` (update with your PC's IP) ✅

### **For Production (Release Build):**
- **Deployed Backend**: `https://your-backend-domain.com` ✅

---

## 📱 Step 1: Find Your PC's IP Address

### **Windows:**
```powershell
ipconfig
```
Look for **IPv4 Address** under your active network adapter:
```
IPv4 Address. . . . . . . . . . . : 192.168.1.9
```

### **Update constants.dart:**
```dart
static const String _devPhysicalDeviceUrl = 'http://192.168.1.9:5000'; // Your PC's IP
```

---

## 🏗️ Step 2: Build APK for Testing on Physical Device

### **Option A: Debug APK (for testing)**
```powershell
cd C:\DDI-Project\DDI-Prediction\flutter

# Build debug APK
flutter build apk --debug

# APK location: build/app/outputs/flutter-apk/app-debug.apk
```

### **Option B: Release APK (for distribution)**
```powershell
# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### **Option C: Split APKs (smaller size)**
```powershell
# Build split APKs by ABI (arm64, armeabi-v7a, x86_64)
flutter build apk --split-per-abi

# Creates separate APKs for each architecture
```

---

## 🚀 Step 3: Install APK on Physical Device

### **Method 1: Via USB (ADB)**
```powershell
# Connect device via USB
# Enable USB Debugging on device

# Install APK
adb install build/app/outputs/flutter-apk/app-debug.apk
```

### **Method 2: Transfer and Install**
1. Copy APK to your phone
2. Open file manager on phone
3. Tap APK file
4. Allow installation from unknown sources if prompted
5. Install

---

## ⚙️ Step 4: Configure for Physical Device Testing

### **Before Building APK:**

1. **Find your PC's IP:**
   ```powershell
   ipconfig
   ```

2. **Update `constants.dart`:**
   ```dart
   static const String _devPhysicalDeviceUrl = 'http://YOUR_PC_IP:5000';
   ```

3. **Make sure backend is running:**
   ```powershell
   # Backend should be accessible from your network
   # Test: Open http://YOUR_PC_IP:5000/health in phone's browser
   ```

4. **Build APK:**
   ```powershell
   flutter build apk --debug
   ```

---

## 🌐 Step 5: Deploy Backend for Production APK

For a production APK, you need a deployed backend. Options:

### **Option 1: Deploy to Cloud (Recommended)**

**Free Options:**
- **Render**: https://render.com (Free tier available)
- **Railway**: https://railway.app (Free tier)
- **Heroku**: https://heroku.com (Paid, but reliable)

**Steps:**
1. Deploy backend to cloud platform
2. Get your backend URL (e.g., `https://ddi-predictor.onrender.com`)
3. Update `constants.dart`:
   ```dart
   static const String _productionUrl = 'https://ddi-predictor.onrender.com';
   ```
4. Build release APK:
   ```powershell
   flutter build apk --release
   ```

### **Option 2: Use Your PC as Server (Local Network Only)**

**Limitations:**
- Only works when device is on same Wi-Fi
- Your PC must be running 24/7
- Not suitable for distribution

**Steps:**
1. Keep backend running on your PC
2. Use your PC's IP in `constants.dart`
3. Build APK
4. Install on devices on same network

---

## 🔄 Quick Configuration Guide

### **For Emulator Testing:**
```dart
// No changes needed - already configured
static const String _devEmulatorUrl = 'http://10.0.2.2:5000';
```

### **For Physical Device Testing (Same Wi-Fi):**
```dart
// Update with your PC's IP
static const String _devPhysicalDeviceUrl = 'http://192.168.1.9:5000';
```

### **For Production (Deployed Backend):**
```dart
// Update with your deployed backend URL
static const String _productionUrl = 'https://your-backend.com';
```

---

## 📋 Complete Build Checklist

### **Before Building APK:**

- [ ] Backend is running and accessible
- [ ] Updated `constants.dart` with correct URL
- [ ] Tested backend URL in browser/Postman
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] No build errors (`flutter doctor`)

### **Build Commands:**

```powershell
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release

# Split APKs (smaller size)
flutter build apk --split-per-abi

# App Bundle (for Google Play Store)
flutter build appbundle --release
```

---

## 🎯 Different Scenarios Explained

### **Scenario 1: Testing on Emulator**
- ✅ Use: `http://10.0.2.2:5000`
- ✅ Backend runs on `localhost:5000`
- ✅ Works automatically

### **Scenario 2: Testing on Physical Device (Same Wi-Fi)**
- ✅ Use: `http://YOUR_PC_IP:5000`
- ✅ Backend runs on your PC
- ✅ Device and PC on same network
- ⚠️ Update IP in `constants.dart` before building

### **Scenario 3: Production APK (Distributed)**
- ✅ Use: `https://your-backend-domain.com`
- ✅ Backend deployed to cloud
- ✅ Works from anywhere
- ⚠️ Deploy backend first, then update URL

---

## 🐛 Troubleshooting

### **Issue: "Connection refused" on physical device**

**Solution:**
1. Check backend is running: `http://localhost:5000/health`
2. Check firewall allows port 5000
3. Verify device and PC are on same Wi-Fi
4. Test backend URL in phone's browser
5. Update IP in `constants.dart` and rebuild

### **Issue: "Network error" in production**

**Solution:**
1. Verify backend is deployed and accessible
2. Check backend URL is correct (HTTPS for production)
3. Test backend URL in browser
4. Check CORS settings on backend

### **Issue: APK is too large**

**Solution:**
```powershell
# Build split APKs (one per architecture)
flutter build apk --split-per-abi

# Or build App Bundle (smaller, for Play Store)
flutter build appbundle --release
```

---

## 📝 Summary

**For APK builds:**
1. **Development/Testing**: Use your PC's IP address (`192.168.1.9:5000`)
2. **Production**: Deploy backend and use production URL (`https://your-backend.com`)

**The code automatically:**
- Uses emulator URL for debug builds on emulator
- Uses production URL for release builds
- Can be manually configured for physical device testing

---

## 🚀 Next Steps

1. **For Testing**: Update IP → Build debug APK → Install on device
2. **For Production**: Deploy backend → Update production URL → Build release APK

**Your app is now ready for APK builds! 📦**

