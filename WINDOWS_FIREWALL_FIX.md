# 🔧 Windows Firewall Fix for APK Connection Issues

## Problem
When running the APK on a physical device via USB debugging, the app cannot connect to the backend server even though:
- ✅ Backend is running
- ✅ Using correct IP address (192.168.1.21)
- ✅ Device and PC on same Wi-Fi

**Root Cause:** Windows Firewall is blocking incoming connections on port 5000.

---

## 🚀 Quick Fix (2 Steps)

### Step 1: Allow Port 5000 in Windows Firewall

**Option A: Use the PowerShell Script (Recommended)**

1. Open PowerShell **as Administrator**:
   - Right-click PowerShell
   - Select "Run as Administrator"

2. Navigate to Backend folder:
   ```powershell
   cd C:\DDI-Project\DDI-Prediction\Backend
   ```

3. Run the firewall script:
   ```powershell
   .\allow_firewall_port.ps1
   ```

**Option B: Manual Firewall Rule**

1. Open PowerShell **as Administrator**

2. Run this command:
   ```powershell
   New-NetFirewallRule -DisplayName "DDI Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
   ```

**Option C: Using Windows Firewall GUI**

1. Open Windows Defender Firewall:
   - Press `Win + R`
   - Type `wf.msc` and press Enter

2. Click "Inbound Rules" → "New Rule"

3. Select "Port" → Next

4. Select "TCP" and enter port `5000` → Next

5. Select "Allow the connection" → Next

6. Check all profiles (Domain, Private, Public) → Next

7. Name it "DDI Backend Port 5000" → Finish

---

### Step 2: Test the Connection

Run the network test script:

```powershell
cd C:\DDI-Project\DDI-Prediction\Backend
.\test_network_connection.ps1
```

This will verify:
- ✅ Port 5000 is listening
- ✅ Backend responds on localhost
- ✅ Backend responds on network IP
- ✅ Firewall rule is configured
- ✅ Server is bound to 0.0.0.0

---

## 🧪 Manual Testing

### Test 1: From Your PC

```powershell
# Test localhost
curl http://localhost:5000/health

# Test network IP
curl http://192.168.1.21:5000/health
```

Both should return JSON with `"status": "ok"`

### Test 2: From Your Phone's Browser

1. Make sure phone and PC are on **same Wi-Fi network**
2. Open phone's browser
3. Navigate to: `http://192.168.1.21:5000/health`
4. Should see JSON response

If this works, your APK will work too!

---

## ✅ Verification Checklist

Before testing your APK:

- [ ] Backend server is running (`python main_with_firebase.py`)
- [ ] Firewall rule created (run `allow_firewall_port.ps1`)
- [ ] `curl http://localhost:5000/health` works
- [ ] `curl http://192.168.1.21:5000/health` works
- [ ] Phone browser can access `http://192.168.1.21:5000/health`
- [ ] Flutter app has correct IP in `constants.dart`:
  ```dart
  static const String _physicalDeviceUrl = 'http://192.168.1.21:5000';
  ```
- [ ] Device and PC on same Wi-Fi network

---

## 🐛 Troubleshooting

### Issue: "Connection refused" on network IP

**Solution:**
1. Check backend is running: `netstat -ano | findstr :5000`
2. Verify it's listening on 0.0.0.0 (not just 127.0.0.1)
3. Check firewall rule is enabled

### Issue: Phone browser works but APK doesn't

**Solution:**
1. Rebuild APK after changing `constants.dart`
2. Make sure you're using `_physicalDeviceUrl` in the `baseUrl` getter
3. Hot restart won't work for APK - you need to rebuild

### Issue: IP address changed

**Solution:**
1. Run `ipconfig` to get new IP
2. Update `constants.dart`:
   ```dart
   static const String _physicalDeviceUrl = 'http://YOUR_NEW_IP:5000';
   ```
3. Rebuild APK

### Issue: Still not working after firewall fix

**Solution:**
1. Temporarily disable Windows Firewall to test:
   - Settings → Windows Security → Firewall & network protection
   - Turn off firewall for Private network
   - Test connection
   - If it works, firewall was the issue - re-enable and check rules

2. Check for other firewalls (antivirus, VPN):
   - Radmin VPN might interfere
   - Disable VPN temporarily to test

3. Verify backend is actually running:
   ```powershell
   netstat -ano | findstr :5000
   ```

---

## 📝 Current Configuration

Based on your `ipconfig` output:

- **Wi-Fi IP:** `192.168.1.21` ✅ (Use this for physical device)
- **Radmin VPN IP:** `26.138.48.198` (Don't use this)

**Flutter App Configuration:**
```dart
// In constants.dart
static const String _physicalDeviceUrl = 'http://192.168.1.21:5000';
```

**Backend Configuration:**
```python
# In main_with_firebase.py (already correct)
uvicorn.run(app, host="0.0.0.0", port=5000)
```

---

## 🎯 Quick Command Reference

```powershell
# Check if port is listening
netstat -ano | findstr :5000

# Test localhost
curl http://localhost:5000/health

# Test network IP
curl http://192.168.1.21:5000/health

# Check firewall rules
Get-NetFirewallRule -DisplayName "DDI Backend Port 5000"

# Allow port (requires Admin)
New-NetFirewallRule -DisplayName "DDI Backend Port 5000" -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow
```

---

## 💡 Pro Tips

1. **Keep Firewall Rule:** The firewall rule persists, so you only need to create it once
2. **Check IP Regularly:** Your IP might change if you reconnect to Wi-Fi
3. **Use Test Script:** Run `test_network_connection.ps1` whenever you have connection issues
4. **Phone Browser First:** Always test in phone's browser before testing APK

---

## ✅ Success Indicators

You'll know it's working when:

1. ✅ `test_network_connection.ps1` shows all green checkmarks
2. ✅ Phone browser can access `http://192.168.1.21:5000/health`
3. ✅ APK shows "Server Online" status
4. ✅ APK can search drugs and check interactions

---

**Need more help?** Check `TROUBLESHOOTING_CONNECTION.md` for additional solutions.












