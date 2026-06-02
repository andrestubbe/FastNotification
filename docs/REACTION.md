# Entwickler-Notizen: Windows 11 Toast Notifications

**Datum:** 2026-04-18  
**Status:** Recherche abgeschlossen, Implementierungsphase

---

## Zusammenfassung: Windows 11 Toast Notifications

### Die 3 Optionen

| Option | Aufwand | Ergebnis | Für wen |
|--------|---------|----------|---------|
| **A. Full MSIX** (Microsoft Store) | 3-10 Tage | ✅ Perfekte Integration | Store-Veröffentlichung |
| **B. Sparse Package** ⭐ | 2-3 Stunden | ✅ Volle Toasts, App bleibt frei | Enterprise/Custom Installer |
| **C. COM Balloon** | 5 Minuten | ⚠️ Fallback (Windows ignoriert oft) | Schneller Test |

### Neue Dateien

```
installer/
├── WINDOWS_NOTIFICATION_GUIDE.md    # Komplette Entscheidungshilfe
├── sparse-manifest.xml              # Vorlage für Sparse Package
├── create-package.ps1               # Package erstellen & signieren
├── register-sparse.ps1              # Im Installer aufrufen
├── register-app.reg                 # Registry (Legacy-Alternative)
└── install.ps1                      # Setup-Script
```

### Was jetzt zu tun ist

**Für Sparse Package (Empfohlen):**

1. **Zertifikat besorgen** → Selbst-signiert für Dev (~5min) oder kaufen für Produktion
2. **Icons erstellen** → 44x44, 150x150, StoreLogo (PNG mit Transparenz)
3. **Manifest anpassen** → `sparse-manifest.xml` (Name, Publisher, Version)
4. **Package bauen** → `create-package.ps1 -SelfSigned`
5. **Im Installer integrieren** → `register-sparse.ps1` während Setup aufrufen

**Zeitaufwand insgesamt:** 2-3 Stunden für produktionsreife Lösung

### Wichtigste Erkenntnis

Windows 11 zeigt **keine Toasts** ohne registrierte App-Identität. Die einzige Ausnahme ist der **alte Balloon-Style**, den Microsoft aber deaktiviert/versteckt hat.

**Sparse Package ist der Sweet Spot:** Volle Windows-Features ohne Store-Zwang, einfach im bestehenden Installer integrierbar.

---

## Meine Empfehlung als Entwickler

### Reihenfolge

```
1. Jetzt → COM-Version stabilisieren (Tray-Balloon funktioniert)
2. Dann → Sparse Package implementieren (volle WinRT Toasts)
3. Optional → Full MSIX Guide für Store-Veröffentlichung
```

### Warum diese Reihenfolge?

| Priorität | Aktion | Begründung |
|-----------|--------|------------|
| **P0** | COM stabilisieren | User muss SOFORT Ergebnis sehen, sonst gibt's Frustration |
| **P1** | Sparse Package | Richtige Lösung für Produktion, braucht aber Setup-Integration |
| **P2** | Full MSIX Guide | Nur wenn jemand explizit Store will |

### COM-Version: Was noch fehlt

**Problem:** Aktuell wird kein Tray-Icon angezeigt, deshalb sehen wir keine Balloon.

**Lösung:** 
- Persistentes Tray-Icon (nicht nur für Notification)
- Oder: System-Tray-Proxy (Hidden Window mit Icon)

**Aufwand:** ~1-2 Stunden

### Sparse Package: Was noch fehlt

**Problem:** WinRT DLL braucht registrierte Identität.

**Lösung:**
- `RegisterAumidAndComServer()` implementieren
- COM Activator GUID erstellen
- PowerShell-Integration testen

**Aufwand:** ~3-4 Stunden

---

## Nächste Schritte (Vorschlag)

**Option A - Schneller Erfolg (empfohlen):**
1. COM-Version: Tray-Icon stabilisieren (~1h)
2. Test: Java-Demo zeigt Balloon
3. User hat sofort funktionierende Lösung

**Option B - Komplettlösung:**
1. Sparse Package Test-Durchlauf
2. Selbst-signiertes Zertifikat erstellen
3. Package registrieren & WinRT testen
4. Dokumentation mit Screenshots

**Ich würde Option A jetzt machen, dann Option B.**

---

## Technische Erkenntnisse (zum Merken)

### App-Identität ist alles

Ohne diese Registrierung zeigt Windows 11 **gar nichts**:

```powershell
# Minimale Registry für Balloon (funktioniert halb)
HKEY_CURRENT_USER\Software\Classes\AppUserModelId\
  AndreStubbe.FastNotification
    (Default) = FastNotification

# Oder Sparse Package (vollständig)
Add-AppxPackage -Path Identity.msix -ExternalLocation C:\Program Files\App
```

### Windows Notification Flow

```
Java App → JNI → Native DLL → Windows API
    ↓
[COM Balloon] → Shell_NotifyIconW → Taskbar Tray
    ↓
[WinRT Toast] → IToastNotifier → Notification Center
                ↑
        Braucht: AppUserModelID + Package Identity
```

### Zertifikate: Was funktioniert wann

| Zertifikat | Entwicklung | Andere PCs | Store |
|------------|-------------|------------|-------|
| Selbst-signiert | ✅ Ja | ❌ Nein (Root-CA nötig) | ❌ |
| Enterprise CA | ✅ Ja | ✅ Domain-PCs | ❌ |
| Kommerziell (DigiCert etc.) | ✅ Ja | ✅ Alle | ✅ Optional |

---

## Offene Fragen

1. **Sollen wir COM-Version mit Tray-Icon-Daemon erweitern?**
   - Pro: Funktioniert sofort
   - Con: Tray-Icon bleibt sichtbar

2. **Sollen wir Sparse Package jetzt testen?**
   - Pro: Zukunftssichere Lösung
   - Con: Braucht Setup-Integration

3. **Soll Action-Button-Support warten?**
   - Braucht COM Activator + Registry
   - Komplexität steigt deutlich

---

**Kommentar:** Die Windows Notification API ist fragmentiert. Microsoft will alle zu MSIX/Store pushen, aber für Enterprise-Tools ist das unpraktisch. Sparse Package ist der beste Kompromiss, braucht aber initialen Setup-Aufwand.
