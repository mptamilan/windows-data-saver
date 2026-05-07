# 🛡️ Zero-Waste Hotspot Mode for Windows 11

A powerful batch script that blocks Windows 11 background data consumption — built for users on **mobile hotspot or limited data plans**. One click to lock down, one click to restore.

---

## 🚨 The Problem

Windows 11 silently drains your mobile data in the background through:

- Windows Update & BITS downloads
- OneDrive file sync
- Telemetry & crash report uploads (DiagTrack)
- Delivery Optimization (P2P uploads to strangers)
- Microsoft Edge preloading & background activity
- Windows Search cloud sync
- Network activity during sleep (Connected Standby)
- Scheduled tasks (Compatibility Appraiser, Maps, CEIP, MRT scans)
- Push notifications & Live Tiles
- Windows Error Reporting uploads
- Advertising ID sync traffic
- Cortana online activity

This script blocks **all of them** with a single menu option — and restores everything when you're back on unlimited Wi-Fi.

---

## ✅ Features

- **20-step maximum data block** — covers services most tools miss
- **One-click restore** — safely reverts all changes to Windows defaults
- **Settings-page safe** — Windows Update page still loads normally (no crash)
- **No third-party tools** — pure batch script using `reg`, `sc`, `net`, `schtasks`, `powercfg`
- **Administrator auto-elevation** — prompts for admin rights automatically
- **Restart reminder** — reminds you to restart for all changes to take effect

---

## 📋 What Gets Blocked

| # | Service / Feature | What It Stops |
|---|---|---|
| 01 | Network cost (WiFi/Ethernet/3G/4G) | Marks all connections as metered |
| 02 | Windows Update (wuauserv, BITS, UsoSvc) | Stops auto-downloads (manual mode) |
| 03 | Update pause registry | Pauses Feature + Quality updates |
| 04 | Delivery Optimization | Stops P2P upload/download |
| 05 | OneDrive | Stops file sync, kills background process |
| 06 | DiagTrack + dmwappushservice | Stops telemetry uploads |
| 07 | Windows Search | Disables cloud search sync |
| 08 | Microsoft Edge | Kills background mode + startup boost |
| 09 | Microsoft Store | Stops auto app updates |
| 10 | Connected Standby | No network use during sleep |
| 11 | SysMain / Superfetch | Stops cloud-assisted preloading |
| 12 | MRT scheduled scans | Disables malware tool auto-runs |
| 13 | Background Apps (global) | All apps blocked from background |
| 14 | Cortana | Disables online activity |
| 15 | Windows Error Reporting | Stops crash data uploads |
| 16 | Scheduled Tasks | Disables 8 network-hungry tasks |
| 17 | Push Notifications (WpnService) | Stops Live Tile + notification sync |
| 18 | Network Location Awareness | Stops automatic network probing |
| 19 | Advertising ID | Stops ad-sync traffic |
| 20 | DNS Cache | Flushes on enable |

---

## 🚀 How to Use

### Requirements
- Windows 10 or Windows 11
- Administrator account

### Steps

1. Download `ZeroWaste_Advanced_v2.bat`
2. Right-click the file → **Run as administrator**
3. Choose an option from the menu:

```
[1] Enable Zero-Waste Mode     ← Run this when on mobile hotspot
[2] Disable Zero-Waste Mode    ← Run this when back on unlimited Wi-Fi
[3] Show current data usage    ← Opens Task Manager
[4] Exit
```

4. **Restart your PC** after enabling or disabling for all changes to take effect

> The script will automatically request administrator privileges if not already elevated.

---

## ⚠️ Important Notes

- **Always disable before running Windows Update** — press option 2, restart, then update
- **OneDrive will stop syncing** while enabled — your files are safe, just not uploading
- **Windows Update Settings page** will still open normally (no crash) — updates just won't download automatically
- **Antivirus / Defender** is NOT disabled by this script — your security stays intact
- This script only changes **services, registry policies, and scheduled tasks** — no system files are modified

---

## 🔄 Restoring to Normal

Run the script and choose **option 2**. It restores:
- All services to their default start types
- All registry policy keys are deleted (not just set back)
- Power settings returned to default
- Scheduled tasks re-enabled

Then restart your PC.

---

## 📁 Files

```
ZeroWaste_Advanced_v2.bat    ← Main script (run this)
README.md                    ← This file
```

---

## 🧪 Tested On

- Windows 11 Home (22H2, 23H2, 24H2)
- Windows 11 Pro
- Windows 10 (21H2+)

---

## 🤝 Contributing

Pull requests welcome. If you find a background service or scheduled task not covered by this script, open an issue with the service name and what it does.

---

## 📜 License

MIT License — free to use, modify, and distribute.

---

## 💡 Tip

Check **Settings → Network & Internet → Data Usage** before and after running this script to see exactly how much each app was consuming. Most users see "System" and "Service Host" drop to near zero after enabling Zero-Waste Mode.
