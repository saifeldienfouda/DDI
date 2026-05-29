# ✅ Setup Checklist - Files Status

## 📋 Current Status Check

### ✅ **PRESENT - Already in Project:**

1. **Backend Firebase Config:**
   - ✅ `Backend/firebase-credentials.json` - EXISTS (project_id: "deepddi")
   - ✅ `Backend/models/deepddi_model.pt` - EXISTS
   - ✅ `Backend/models/deepddi_best.pt` - EXISTS
   - ✅ `Backend/models/model_info.json` - EXISTS
   - ✅ `Backend/data/preprocessor.pkl` - EXISTS

2. **Flutter Firebase Config:**
   - ✅ `flutter/android/app/google-services.json` - EXISTS (project_id: "deepddi" ✅ MATCHES backend!)
   - ✅ `flutter/lib/firebase_options.dart` - EXISTS

3. **Training Data:**
   - ✅ `model_data/drug_info_combined.csv` - EXISTS
   - ✅ `model_data/db_drug_interactions.csv` - EXISTS

---

### ❌ **MISSING - Must Copy from Original Project:**

#### 🔴 **CRITICAL - Required for Backend to Run:**

1. **`Backend/.env`** - **MISSING** ❌
   ```
   This file MUST contain:
   FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
   FIREBASE_PROJECT_ID=deepddi
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

#### 🟡 **OPTIONAL - Only if targeting iOS:**

2. **`flutter/ios/Runner/GoogleService-Info.plist`** - **MISSING** ❌
   ```
   Only needed if you plan to run the Flutter app on iOS.
   If you're only testing on Android, you can skip this.
   ```

---

## 🎯 Action Required:

### **Step 1: Create `.env` file**

Copy from your original project OR create manually:

**Location:** `DDI-Prediction/Backend/.env`

**Content:**
```env
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
FIREBASE_PROJECT_ID=deepddi
GEMINI_API_KEY=your_actual_gemini_api_key_here
```

**How to get Gemini API Key:**
1. Go to: https://makersuite.google.com/app/apikey
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the key and paste it in `.env`

### **Step 2: Copy iOS Firebase Config (Optional)**

**Only if you need iOS support:**

Copy from original project:
- `flutter/ios/Runner/GoogleService-Info.plist` → `DDI-Prediction/flutter/ios/Runner/GoogleService-Info.plist`

---

## ✅ Verification Checklist:

After copying files, verify:

- [ ] `Backend/.env` exists and contains `GEMINI_API_KEY`
- [ ] `Backend/firebase-credentials.json` exists
- [ ] `flutter/android/app/google-services.json` exists
- [ ] Both Firebase configs have same `project_id` ("deepddi") ✅ Already verified!
- [ ] Model files exist in `Backend/models/`
- [ ] Preprocessor exists in `Backend/data/`

---

## 🚀 Next Steps After Copying:

1. **Test Backend:**
   ```powershell
   cd DDI-Prediction/Backend
   .\.venv\Scripts\Activate.ps1
   python api/main_with_firebase.py
   ```

2. **Test Flutter:**
   ```powershell
   cd DDI-Prediction/flutter
   flutter pub get
   flutter run
   ```

---

## 📝 Summary:

**Status:** 🟡 **Almost Ready!**

**Missing:** 
- ❌ `Backend/.env` (CRITICAL - must create/copy)
- ❌ `flutter/ios/Runner/GoogleService-Info.plist` (OPTIONAL - only for iOS)

**Everything else is present and correctly configured!** ✅

