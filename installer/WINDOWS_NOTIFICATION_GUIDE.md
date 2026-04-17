# Windows 11/10 Toast Notification Guide for Desktop Apps

## Overview

Windows 11/10 bietet **3 Wege** für Desktop-Apps um Toast Notifications zu zeigen:

| Methode | Aufwand | Funktioniert | Empfohlen für |
|---------|---------|--------------|---------------|
| **A. MSIX Full Package** (Microsoft Store) | Hoch | ✅ Vollständig | Store-Veröffentlichung |
| **B. Sparse Package** (External Location) | Mittel | ✅ Vollständig | Enterprise/Custom Installer |
| **C. COM Balloon (Legacy)** | Niedrig | ⚠️ Fallback | Einfache Integration |

---

## Option A: Full MSIX Package (Microsoft Store)

### Was ist das?
App wird vollständig in MSIX-Container gepackt und über Microsoft Store oder Sideloading verteilt.

### Vorteile
- ✅ Alle Windows Features sofort verfügbar
- ✅ Automatische Updates via Store
- ✅ Sandboxing & Sicherheit

### Nachteile
- ❌ Dateisystem- und Registry-Zugriff eingeschränkt
- ❌ Java JVM muss im Package enthalten sein (groß!)
- ❌ Komplexer Build-Prozess

### Aufwand
| Schritt | Zeit | Beschreibung |
|---------|------|--------------|
| MSIX Manifest erstellen | 2-4h | XML mit App-Identität |
| JVM + JAR packen | 1-2h | ~200MB Package-Größe |
| Zertifikat kaufen | 1-3 Tage | Code-Signing für Store |
| Store Submission | 1-7 Tage | Microsoft Review |
| **Gesamt** | **3-10 Tage** | |

### Benötigt
- Code-Signing Zertifikat (~$100-400/Jahr)
- Windows 10/11 SDK
- MSIX Packaging Tool

---

## Option B: Sparse Package (Identity + External Location) ⭐ EMPFOHLEN

### Was ist das?
Ein minimales MSIX-Package (nur Identität, ~50KB) wird registriert. Deine App bleibt an originaler Location (z.B. `C:\Program Files\FastNotification`).

### Vorteile
- ✅ Alle Windows Features verfügbar
- ✅ App bleibt unverändert (kein Container)
- ✅ Einfacher als Full MSIX
- ✅ Funktioniert mit existierendem Installer (WiX, Inno, NSIS)

### Nachteile
- ⚠️ Code-Signing Zertifikat nötig (kann selbst-signiert sein für interne Apps)
- ⚠️ Eine Registrierung pro User/Machine nötig

### Aufwand
| Schritt | Zeit | Beschreibung |
|---------|------|--------------|
| Manifest erstellen | 30min | Unsere Vorlage nutzen |
| Package signieren | 30min | Mit Zertifikat |
| Installer anpassen | 1h | PowerShell-Registrierung |
| **Gesamt** | **2-3 Stunden** | |

### Was du brauchst
1. **App-Identität** (Name, Publisher, Version)
2. **Code-Signing Zertifikat** (kann selbst-signiert für Entwicklung sein)
3. **Icons** (44x44, 150x150, Store-Logo)
4. **Installer-Integration** (siehe `register-sparse.ps1`)

### Unsere Vorlagen
- `installer\sparse-manifest.xml` - Fertiges Manifest
- `installer\register-sparse.ps1` - Registrierung im Installer
- `installer\create-package.ps1` - Package erstellen & signieren

---

## Option C: COM Balloon (Legacy)

### Was ist das?
Nutzt die alte `Shell_NotifyIcon` API für Tray-Balloons (nicht moderne Toasts).

### Vorteile
- ✅ Sofort funktionsfähig
- ✅ Keine Registrierung nötig
- ✅ Funktioniert auf Windows 7/8/10/11

### Nachteile
- ❌ Zeigt Balloon, nicht moderne Toast
- ❌ In Windows 11 werden Balloons oft unterdrückt
- ❌ Keine Action-Buttons
- ❌ Keine Progress-Bars
- ❌ Zeigt Windows-Logo statt App-Icon

### Aufwand
| Schritt | Zeit | Beschreibung |
|---------|------|--------------|
| DLL einbinden | 5min | `FastNotification_COM.dll` nutzen |
| **Gesamt** | **5 Minuten** | |

### Wann nutzen?
- Schneller Prototyp
- Interne Tools
- Windows 7/8 Kompatibilität

---

## Entscheidungshilfe

```
Willst du in Microsoft Store? ──JA──→ Option A: Full MSIX
                           │
                           └─NEIN─┬─ Enterprise/Umgebung mit PKI? ──JA──→ Option B: Sparse Package
                                    │
                                    └─ Schnell & einfach? ──JA──→ Option C: COM Balloon
```

### Für FastNotification Produkte

| Produkt-Typ | Empfohlene Option |
|-------------|-------------------|
| **Open Source Library** | B (Sparse) - volle Funktionen, einfach für User |
| **Enterprise Tool** | B (Sparse) - MSI-Integration |
| **Microsoft Store App** | A (Full MSIX) |
| **Schneller Prototyp** | C (COM) - sofort testen |

---

## Technische Details

### AppUserModelID (AUMID)
Die eindeutige Identität deiner App:
```
[Company].[AppName][.OptionalSuffix]
Beispiel: "AndreStubbe.FastNotification.v1"
```

Muss konsistent sein in:
- MSIX Manifest (Name)
- Startmenü-Shortcut (System.AppUserModel.ID)
- Java Code (optional, falls nutzen)

### COM Toast Activator (nur für WinRT/Sparse)
Für Action-Buttons in Toasts brauchst du:
- Einen COM-Server mit GUID
- Registrierung in Registry (LocalServer32)
- Implementierung des `INotificationActivationCallback` Interfaces

Siehe: `FastNotification.cpp` (WinRT Version)

### Zertifikate

| Typ | Preis | Gültigkeit | Nutzung |
|-----|-------|------------|---------|
| **Selbst-signiert** | Kostenlos | Lokal/Entwicklung | Nur auf deinem PC |
| **Enterprise CA** | Interne Kosten | Domain | Firmen-Netzwerk |
| **Commercial** | $100-400/Jahr | Global | Alle Windows PCs |

Empfohlene Anbieter: DigiCert, Sectigo (Comodo), GlobalSign

---

## Troubleshooting

### "Notifications don't appear"
1. Prüfe Windows Einstellungen → System → Notifications
2. Ist deine App in der Liste? Wenn nein → Registrierung fehlgeschlagen
3. Fokus-Assist (Störungsfrei) aktiv? → Deaktivieren

### "Shows Windows logo instead of my icon"
- Icon-Pfade im Manifest prüfen
- Bilder müssen im Package/Install-Ordner vorhanden sein
- Formate: PNG mit Transparenz

### "App not in notification settings"
- Startmenü-Shortcut fehlt oder hat falsche AUMID
- MSIX Package nicht registriert

---

## Nächste Schritte

### Für Sparse Package (Empfohlen):
1. Zertifikat besorgen (oder selbst-signiert erstellen)
2. `installer\sparse-manifest.xml` anpassen (Name, Publisher)
3. Icons in `installer\Assets\` ablegen
4. `create-package.ps1` ausführen
5. Package in deinen Installer integrieren (`register-sparse.ps1`)

### Für Full MSIX:
1. MSIX Packaging Tool installieren
2. Application Packaging Project in Visual Studio erstellen
3. Alle Dependencies (JVM, JARs) einschließen
4. Store-Veröffentlichung vorbereiten

### Für COM Balloon:
1. `compile.bat` nutzen (baut automatisch COM-Version)
2. Testen ob Balloons in deiner Windows-Version erscheinen

---

**Microsoft Dokumentation:**
- [Send Toast from Desktop C++](https://learn.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/send-local-toast-desktop-cpp-wrl)
- [Grant Identity via Sparse Package](https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/grant-identity-to-nonpackaged-apps)
- [AppUserModelID Registration](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/hh802762(v=vs.85))
