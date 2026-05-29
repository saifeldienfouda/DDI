# 📱 Building APK for Physical Device (Local Backend)

## 🎯 Quick Guide

Since you're **not deploying the backend to production**, here's how to build an APK that works with your **local backend** running on your PC.

---

## ⚡ Quick Steps

### **Step 1: Find Your PC's IP Address**

```powershell
ipconfig
```

Look for **IPv4 Address** (e.g., `192.168.1.9`)

---

### **Step 2: Update constants.dart**

Open `flutter/lib/utils/constants.dart` and update line with your PC's IP:

**Change this:**
```dart
static const String _physicalDeviceUrl = 'http://192.168.1.9:5000';
```

**To your actual IP:**
```dart
static const String _physicalDeviceUrl = 'http://YOUR_PC_IP:5000';
```

---

### **Step 3: Temporarily Switch to Physical Device URL**

In `constants.dart`, change the `baseUrl` getter:

**Find this:**
```dart
static String get baseUrl {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _emulatorUrl;  // ← Change this line
  }
  ...
}
```

**Change to:**
```dart
static String get baseUrl {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return _physicalDeviceUrl;  // ← Use physical device URL
  }
  ...
}
```

---

### **Step 4: Build APK**

```powershell
cd C:\DDI-Project\DDI-Prediction\flutter
flutter build apk --debug
```

---

### **Step 5: Install on Device**

```powershell
# Connect device via USB
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Or:**
1. Copy `app-debug.apk` to your phone
2. Open file manager
3. Tap APK → Install

---

### **Step 6: Make Sure Backend is Running**

**Important:** Your backend must be running on your PC:

```powershell
cd C:\DDI-Project\DDI-Prediction\Backend\api
python main_with_firebase.py
```

**Test:** Open `http://YOUR_PC_IP:5000/health` in your phone's browser to verify backend is accessible.

---

### **Step 7: Switch Back for Emulator**

After testing on physical device, **change back** to emulator URL:

```dart
return _emulatorUrl;  // ← Change back for emulator testing
```

---

## 🔄 Easier Method: Comment/Uncomment

You can make it easier by using comments:

```dart
static String get baseUrl {
  if (defaultTargetPlatform == TargetPlatform.android) {
    // For emulator (default):
    return _emulatorUrl;
    
    // For physical device APK (uncomment when building APK):
    // return _physicalDeviceUrl;
  }
  ...
}
```

**When building APK:**
1. Comment `return _emulatorUrl;`
2. Uncomment `return _physicalDeviceUrl;`
3. Build APK
4. Switch back after building

---

## ⚠️ Important Notes

1. **Same Wi-Fi Required**: Device and PC must be on same Wi-Fi network
2. **Backend Must Be Running**: Keep backend running while testing
3. **Firewall**: Make sure Windows Firewall allows port 5000
4. **IP May Change**: If your PC's IP changes, update `constants.dart` and rebuild

---

## 🧪 Testing Checklist

Before building APK:
- [ ] Found PC's IP address (`ipconfig`)
- [ ] Updated `_physicalDeviceUrl` in `constants.dart`
- [ ] Changed `baseUrl` getter to use `_physicalDeviceUrl`
- [ ] Backend is running (`python main_with_firebase.py`)
- [ ] Tested backend URL in phone's browser: `http://YOUR_PC_IP:5000/health`

After building APK:
- [ ] Installed APK on device
- [ ] Device and PC on same Wi-Fi
- [ ] App connects to backend (no "Server offline" error)
- [ ] Can search drugs and check interactions

---

## 🐛 Troubleshooting

### **"Connection refused" or "Server offline"**

1. **Check backend is running:**
   ```powershell
   # Should show: INFO: Uvicorn running on http://0.0.0.0:5000
   ```

2. **Test backend from phone's browser:**
   ```
   http://YOUR_PC_IP:5000/health
   ```
   Should return JSON with `"status": "ok"`

3. **Check firewall:**
   ```powershell
   # Allow port 5000 in Windows Firewall
   # Or temporarily disable firewall to test
   ```

4. **Verify IP address:**
   - Make sure IP in `constants.dart` matches your PC's current IP
   - Run `ipconfig` again to verify

5. **Check network:**
   - Device and PC must be on same Wi-Fi
   - Try pinging PC from device (if possible)

---

## 📝 Summary

**For APK with local backend:**
1. Update `_physicalDeviceUrl` with your PC's IP
2. Change `baseUrl` getter to return `_physicalDeviceUrl`
3. Build APK: `flutter build apk --debug`
4. Install on device
5. Make sure backend is running
6. Device and PC on same Wi-Fi

**That's it!** Your APK will connect to your local backend. 🚀

