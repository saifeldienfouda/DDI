# ✅ Ready to Run Checklist

## 🔍 Pre-Flight Check

Before running, verify these items:

### ✅ **Files Present:**
- [x] `Backend/.env` - EXISTS ✅
- [x] `Backend/firebase-credentials.json` - EXISTS ✅
- [x] `Backend/models/deepddi_model.pt` - EXISTS ✅
- [x] `Backend/data/preprocessor.pkl` - EXISTS ✅
- [x] `flutter/android/app/google-services.json` - EXISTS ✅
- [x] `flutter/lib/firebase_options.dart` - EXISTS ✅

### ⚠️ **Critical Checks:**

#### 1. **Python Version** ⚠️
You had Python 3.13 which caused scikit-learn compilation issues.

**Action Required:**
- ✅ Use Python 3.10, 3.11, or 3.12 (NOT 3.13)
- Check your Python version:
  ```powershell
  python --version
  ```

**If you have Python 3.13:**
1. Install Python 3.11 from: https://www.python.org/downloads/release/python-3110/
2. Create new venv with Python 3.11:
   ```powershell
   cd C:\DDI-Project\DDI-Prediction\Backend
   py -3.11 -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

#### 2. **Dependencies Installed** ⚠️
Make sure all packages installed successfully:
```powershell
cd DDI-Prediction/Backend
.\.venv\Scripts\Activate.ps1
python -c "import torch, fastapi, firebase_admin, google.generativeai; print('✅ All critical packages OK')"
```

#### 3. **`.env` File Complete** ⚠️
Verify your `.env` file contains:
- `FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json`
- `FIREBASE_PROJECT_ID=deepddi`
- `GEMINI_API_KEY=your_actual_key_here` (NOT placeholder!)

#### 4. **Flutter App Base URL** ⚠️
Your `constants.dart` has: `http://192.168.1.9:5000`

**Update based on your setup:**
- **Android Emulator:** Change to `http://10.0.2.2:5000`
- **Physical Device:** Keep `http://192.168.1.9:5000` (or your PC's IP)
- **iOS Simulator:** Change to `http://localhost:5000`

---

## 🚀 How to Run

### **Step 1: Start Backend**

```powershell
cd C:\DDI-Project\DDI-Prediction\Backend

# Activate venv (use Python 3.11 venv if you created one)
.\.venv\Scripts\Activate.ps1

# Start server
cd api
python main_with_firebase.py
```

**Expected Output:**
```
✅ ML Model loaded successfully
✅ Firebase initialized successfully
✅ Gemini AI Chat Service initialized
🚀 Starting DDI Predictor API with Firebase
📍 API: http://localhost:5000
📚 Docs: http://localhost:5000/docs
🔥 Firebase: Enabled
```

**Keep this terminal open!**

### **Step 2: Test Backend (Optional)**

Open a NEW terminal and test:
```powershell
# Health check
curl http://localhost:5000/health

# Should return JSON with "status": "ok"
```

### **Step 3: Run Flutter App**

Open a NEW terminal:
```powershell
cd C:\DDI-Project\DDI-Prediction\flutter

# Get dependencies
flutter pub get

# Run app
flutter run
```

**Select your device/emulator when prompted.**

---

## 🐛 Troubleshooting

### **Issue: "scikit-learn compilation error"**
**Solution:** Use Python 3.11 or 3.12, not 3.13

### **Issue: "GEMINI_API_KEY not found"**
**Solution:** Check `.env` file has actual API key (not placeholder)

### **Issue: "Firebase not initialized"**
**Solution:** Verify `firebase-credentials.json` exists and `.env` points to it

### **Issue: "Model not found"**
**Solution:** Verify `Backend/models/deepddi_model.pt` exists

### **Issue: "Connection refused" in Flutter**
**Solution:** 
- Check backend is running
- Update `constants.dart` baseUrl to match your setup
- For Android emulator: use `10.0.2.2:5000`
- For physical device: use your PC's IP address

### **Issue: "Port 5000 already in use"**
**Solution:**
```powershell
# Find process using port 5000
netstat -ano | findstr :5000

# Kill it (replace PID with actual process ID)
taskkill /PID <PID> /F
```

---

## ✅ Success Indicators

You'll know everything works when:

1. ✅ Backend starts without errors
2. ✅ `http://localhost:5000/health` returns `{"status":"ok"}`
3. ✅ Flutter app connects to backend
4. ✅ You can search for drugs
5. ✅ You can check drug interactions
6. ✅ Results display correctly

---

## 📝 Quick Reference

**Backend:** `http://localhost:5000`
**API Docs:** `http://localhost:5000/docs`
**Health Check:** `http://localhost:5000/health`

**Backend Directory:** `DDI-Prediction/Backend`
**Flutter Directory:** `DDI-Prediction/flutter`

---

## 🎯 Next Steps After Running

1. Test drug search functionality
2. Test interaction checking
3. Test Firebase authentication (if implemented)
4. Test AI chat assistant (if Gemini API key is set)
5. Check Firebase Console for data storage

---

**Status:** 🟡 **Almost Ready - Check Python Version & Dependencies!**

