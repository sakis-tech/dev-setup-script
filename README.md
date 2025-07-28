
# 🚀 Dev Setup-Script für Entwickler


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-green.svg)](https://www.gnu.org/software/bash/) [![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Ubuntu%20%7C%20Debian-blue.svg)](https://www.debian.org/)


Ein Bash-Script, das dir in wenigen Minuten eine Entwicklungsumgebung auf Ubuntu oder Debian einrichtet.

![start](https://github.com/user-attachments/assets/a43df019-4fc6-4584-8584-c21e59ed34e3)

----------

## ✅ Was macht das Script?

-   Erstellt einen neuen Nutzer mit sudo-Rechten
-   Installiert Basis-Tools wie `git`, `curl`, `python3`, `htop` usw.
-   Richtet automatisch die Zeitzone, Sprache & Updates ein
-   Fragt dich, welche Node.js-Version du brauchst (z. B. 18, 20, 22, 23)
-   Optional: Docker + Docker Compose für Container-Entwicklung
-   Optional: Installiert [Deno](https://github.com/denoland/deno), [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD), [Claude-Flow](https://github.com/ruvnet/claude-flow) und [Claude-Code](https://github.com/anthropics/claude-code)

----------

## 🎯 Warum?

-   Spart Zeit beim Server-Setup
-   Du bekommst jedes Mal eine saubere, funktionierende Dev-Umgebung
-   Keine Versionskonflikte oder vergessene Tools
-   Perfekt für VPS, Teams oder AI-Projekte

----------

## 🚀 Wie starte ich es?

```bash
wget https://raw.githubusercontent.com/sakis-tech/dev-setup-script/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh

```

----------

## ⚙️ Für wen ist es gedacht?

-   Entwickler, die oft neue Server einrichten
-   Teams, die einheitliche Dev-Umgebungen wollen
-   AI-Entwickler, die schnell mit modernen Tools loslegen möchten

----------

## 🔧 Was wird gefragt?

Das Script fragt dich interaktiv:

```
➥ Benutzerdaten eingeben:
Benutzername eingeben: developer
Passwort eingeben: ********

➥ Node.js Version auswählen:
  1) Node.js 18 LTS (Hydrogen)
  2) Node.js 20 LTS (Iron)
  3) Node.js 22 (Current)
  4) Node.js 23 (Latest)

➥ Docker installieren? [J/n]:
➥ BMAD-METHOD installieren? [J/n]:
➥ Deno installieren? [J/n]:
➥ Claude Code installieren? [J/n]:
➥ Claude Flow installieren? [J/n]:


```

----------

## 📊 Beispiel-Ausgabe

Nach der Installation siehst du:

```
Node.js Version: v20.17.1
NPM Version: 10.9.2
Docker Version: 28.3.2
Docker Compose Version: v2.39.1
BMAD-METHOD: 4.33.0
Deno Version: deno 2.4.2 (stable, release, x86_64-unknown-linux-gnu)

╔═══════════════════════════╗
║ ✓ Setup abgeschlossen! ✓ ║
╚═══════════════════════════╝

```

----------

**Kurz gesagt:** Einfach starten, auswählen, loslegen. Dein Dev-Server ist in 10 Minuten einsatzbereit.

----------

## 📝 Lizenz

MIT License - Du kannst das Script frei verwenden und anpassen.
