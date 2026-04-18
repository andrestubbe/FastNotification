# Getting Started with FastNotification

## Quick Start (5 Minuten)

### 1. Download & Extract
```bash
git clone https://github.com/andrestubbe/FastNotification.git
cd FastNotification
```

### 2. Native DLL kompilieren
```bash
# Windows: compile.bat ausführen
compile.bat
```

> **Hinweis:** Braucht Visual Studio 2022 (kostenlos). Alternativ: Vorkompilierte DLL aus Releases nehmen.

### 3. Java-Code kompilieren
```bash
mvn clean compile
```

### 4. Demo starten
```bash
java --% -cp "target\classes" -Djava.library.path="native" --enable-native-access=ALL-UNNAMED fastnotifications.Demo
```

---

## Was solltest du sehen?

### Wenn alles funktioniert:
Windows zeigt **3 Benachrichtigungen** nacheinander:
1. Einfache Benachrichtigung
2. Benachrichtigung mit Icon  
3. Benachrichtigung mit Builder-Pattern

### Wenn nichts erscheint:
Das ist **normal** auf Windows 10/11! Microsoft hat Benachrichtigungen für Desktop-Apps eingeschränkt.

**Lösung siehe unten:** [Level 1, 2 oder 3 wählen](#level-wählen)

---

## Level wählen

FastNotification bietet **3 Integrations-Level** für unterschiedliche Anforderungen:

```
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 1: Sofort testen (30 Sekunden)                      │
│  ─────────────────────────────────                          │
│  • Balloon-Style Benachrichtigungen                         │
│  • Funktioniert sofort, kein Setup nötig                    │
│  • Windows 11 blendet diese manchmal aus                    │
│                                                              │
│  Code: FastNotifications.notify("Titel", "Text");           │
└─────────────────────────────────────────────────────────────┘
                              ↓ (brauchst mehr?)
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 2: Produktionsreif (2 Stunden Setup)                 │
│  ────────────────────────────────────────                   │
│  • Moderne Toast-Benachrichtigungen                          │
│  • Action-Buttons, Progress-Bars                             │
│  • Echter Installer nötig (Sparse Package)                   │
│                                                              │
│  Siehe: installer/WINDOWS_NOTIFICATION_GUIDE.md             │
└─────────────────────────────────────────────────────────────┘
                              ↓ (brauchst mehr?)
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 3: Microsoft Store (3-10 Tage)                       │
│  ───────────────────────────────────                        │
│  • Vollständige Store-Integration                          │
│  • Automatische Updates                                      │
│  • Code-Signing Zertifikat nötig                           │
│                                                              │
│  Siehe: Microsoft Store Entwickler-Dokumentation            │
└─────────────────────────────────────────────────────────────┘
```

### Empfehlung:
- **Prototyp/Intern:** Level 1
- **Tool für Kunden:** Level 2
- **Verkauf über Store:** Level 3

---

## Level 1: Schnell starten

### Java-Code
```java
import fastnotifications.FastNotifications;

public class MyApp {
    static {
        // DLL laden (Windows)
        System.loadLibrary("FastNotification");
    }
    
    public void showNotification() {
        // Einfache Benachrichtigung
        FastNotifications.notify("Hallo", "Das ist ein Test!");
        
        // Mit Tag (ersetzt alte mit gleichem Tag)
        FastNotifications.notifyTagged("update-1", "Download", "50% fertig...");
        
        // Nach 2 Sekunden aktualisieren
        Thread.sleep(2000);
        FastNotifications.notifyTagged("update-1", "Download", "100% fertig!");
    }
}
```

### Was der User sieht
- **Windows 10:** Balloon im System-Tray (rechts unten)
- **Windows 11:** Kann deaktiviert sein (siehe Troubleshooting)

> ⚠️ **Windows 11 blendet Balloon-Benachrichtigungen oft aus.** Das ist kein Bug, das ist Microsofts Design-Entscheidung.

---

## Level 2: Moderne Toasts

Für **vollständige moderne Benachrichtigungen** (wie Outlook/Teams):

### Schritt 1: Sparse Package erstellen (einmalig)
```powershell
# Als Administrator:
cd installer
.\create-package.ps1 -SelfSigned
.\register-sparse.ps1 -InstallPath "C:\Program Files\DeinApp"
```

### Schritt 2: WinRT DLL bauen
```bash
# compile.bat editieren: WinRT statt COM wählen
# Zeile 45: SOURCE_FILE auf FastNotification.cpp ändern
compile.bat
```

### Schritt 3: Action-Buttons nutzen
```java
Notification.builder("Download")
    .message("Datei wird heruntergeladen...")
    .tag("download-123")
    .actions(Arrays.asList(
        new Action("Abbrechen", () -> cancelDownload()),
        new Action("Pause", () -> pauseDownload())
    ))
    .show();
```

**Details:** Siehe `installer/WINDOWS_NOTIFICATION_GUIDE.md`

---

## Troubleshooting

### "Es erscheint gar nichts"

#### Prüfung 1: Windows Einstellungen
```
Einstellungen → System → Benachrichtigungen
→ "Benachrichtigungen erhalten" muss AN sein
→ Fokus-Assist muss AUS sein
```

#### Prüfung 2: Stiller Modus
Windows 11 hat einen "Stillen Modus" der alle Benachrichtigungen blockiert:
```
Taskleiste → Uhr → Rechtsklick → "Nicht stören" prüfen
```

#### Prüfung 3: App-Registrierung (für Level 2)
```powershell
# Prüfen ob Package registriert
Get-AppxPackage | Where-Object { $_.Name -like "*FastNotification*" }

# Falls nicht: Registrieren
Add-AppxPackage -Path "FastNotification-Identity.msix" -ExternalLocation "C:\DeinPfad"
```

### "DLL nicht gefunden"
```bash
# Java-Argument prüfen:
-Djava.library.path="native"

# Oder DLL nach System32 kopieren (nicht empfohlen):
copy native\FastNotification.dll C:\Windows\System32\
```

### "Access Denied" beim Registrieren
Sparse Package braucht **Administrator-Rechte** für Installation.

---

## FAQ

**Q: Warum so kompliziert?**  
A: Microsoft will alle zum Microsoft Store pushen. Für Desktop-Apps gibt es daher extra Hürden.

**Q: Funktioniert das auf Mac/Linux?**  
A: Nein, nur Windows. Native Features erfordern native Code.

**Q: Brauche ich einen Installer?**  
A: Für Level 1 (Testen): Nein. Für Level 2 (Produktion): Ja, aber nur für die einmalige Registrierung.

**Q: Was ist der Unterschied zu JavaFX Notifications?**  
A: JavaFX zeigt Notifications innerhalb der App. FastNotification zeigt native Windows-Benachrichtigungen (auch wenn App minimiert ist).

---

## Next Steps

1. **Jetzt:** Level 1 ausprobieren (`Demo.java` starten)
2. **Sofort:** Prüfen ob Balloons erscheinen
3. **Später:** Für Produktion auf Level 2 upgraden

**Hilfe:** [GitHub Issues](https://github.com/andrestubbe/FastNotification/issues)
