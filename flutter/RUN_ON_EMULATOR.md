# 📱 Running Flutter App on Android Emulator

## ✅ Prerequisites

1. **Backend server is running** on `http://localhost:5000`
2. **Android Studio** installed with Android SDK
3. **Flutter SDK** installed and configured
4. **Android Emulator** created and running

---

## 🚀 Step-by-Step Guide

### Step 1: Start Android Emulator

#### Option A: From Android Studio
1. Open **Android Studio**
2. Click **Tools** → **Device Manager** (or click the device icon in toolbar)
3. Click **▶ Play** button next to an emulator
4. Wait for emulator to boot (may take 1-2 minutes)

#### Option B: From Command Line
```powershell
# List available emulators
flutter emulators

# Launch an emulator (replace "emulator_name" with actual name)
flutter emulators --launch <emulator_name>

# Or use Android SDK emulator directly
emulator -avd <avd_name>
```

#### Option C: Create New Emulator (if none exist)
1. Open **Android Studio**
2. **Tools** → **Device Manager**
3. Click **Create Device**
4. Select **Phone** → **Pixel 5** (or any phone)
5. Click **Next**
6. Select **API 33** or **API 34** (Android 13/14)
7. Click **Next** → **Finish**

---

### Step 2: Verify Emulator is Running

```powershell
# Check if emulator is running
adb devices
```

You should see something like:
```
List of devices attached
emulator-5554   device
```

---

### Step 3: Update Base URL (Already Done ✅)

The `constants.dart` file is already configured for Android emulator:
```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

**Note:** `10.0.2.2` is the special IP address that Android emulator uses to access `localhost` on your host machine.

---

### Step 4: Install Flutter Dependencies

```powershell
cd C:\DDI-Project\DDI-Prediction\flutter
flutter pub get
```

---

### Step 5: Run Flutter App

```powershell
# Make sure you're in the flutter directory
cd C:\DDI-Project\DDI-Prediction\flutter

# Run on emulator
flutter run
```

**Or specify the device explicitly:**
```powershell
flutter run -d emulator-5554
```

---

## 🎯 What Happens Next

1. Flutter will build the app (first time takes 2-5 minutes)
2. App will install on emulator
3. App will launch automatically
4. You should see your DDI Predictor app!

---

## 🔧 Troubleshooting

### Issue: "No devices found"

**Solution:**
```powershell
# Check if emulator is running
adb devices

# If empty, start emulator from Android Studio
# Or restart ADB:
adb kill-server
adb start-server
```

### Issue: "Connection refused" or "Server offline"

**Solution:**
1. Make sure backend is running: `http://localhost:5000`
2. Test backend: Open browser → `http://localhost:5000/health`
3. Verify `constants.dart` has: `http://10.0.2.2:5000` (for emulator)

### Issue: "Build failed"

**Solution:**
```powershell
# Clean build
flutter clean
flutter pub get
flutter run
```

### Issue: "Gradle build failed"

**Solution:**
```powershell
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

---

## 📝 Different Base URLs for Different Scenarios

### Android Emulator:
```dart
static const String baseUrl = 'http://10.0.2.2:5000';
```

### iOS Simulator:
```dart
static const String baseUrl = 'http://localhost:5000';
```

### Physical Device (on same Wi-Fi):
```dart
// Find your PC's IP address:
// Windows: ipconfig (look for IPv4 Address)
// Then use:
static const String baseUrl = 'http://192.168.1.XXX:5000';
```

---

## ✅ Success Indicators

You'll know it's working when:
- ✅ Emulator shows your app
- ✅ App connects to backend (no "Server offline" message)
- ✅ You can search for drugs
- ✅ You can check drug interactions
- ✅ Results display correctly

---

## 🎉 Quick Test

Once app is running:
1. Search for a drug (e.g., "Aspirin")
2. Select two drugs
3. Check interaction
4. View results!

---

## 💡 Pro Tips

1. **Hot Reload**: Press `r` in terminal to hot reload changes
2. **Hot Restart**: Press `R` for full restart
3. **Quit**: Press `q` to quit
4. **Check Logs**: Flutter terminal shows all app logs
5. **Backend Logs**: Check backend terminal for API requests

---

**Your app should now be running on the emulator! 🚀**

