
# 🚀 Dev Setup-Script für Entwickler

**Was ist das?**
Ein Bash-Script, das dir in wenigen Minuten eine Entwicklungsumgebung auf Ubuntu oder Debian einrichtet.

---

## ✅ Was macht das Script?

* Erstellt einen neuen Nutzer mit sudo-Rechten
* Installiert Basis-Tools wie `git`, `curl`, `python3`, `htop` usw.
* Richtet automatisch die Zeitzone, Sprache & Updates ein
* Installiert Docker + Docker Compose
* Optional: Portainer - Web-basiertes Docker-Management auf Port 9443
* Fragt dich, welche Node.js-Version du brauchst (z. B. 18, 20, 22, 23)
* Optional: Installiert [Deno](https://github.com/denoland/deno), [BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD), [Claude-Flow](https://github.com/ruvnet/claude-flow) und [Claude-Code](https://github.com/anthropics/claude-code)

---

## 🎯 Warum?

* Spart Zeit beim Server-Setup
* Du bekommst jedes Mal eine saubere, funktionierende Dev-Umgebung
* Keine Versionskonflikte oder vergessene Tools
* Perfekt für VPS, Teams oder AI-Projekte

---

## 🚀 Wie starte ich es?

```bash
wget https://raw.githubusercontent.com/sakis-tech/dev-setup-script/main/setup.sh
chmod +x setup.sh
sudo ./setup.sh
```

---

## ⚙️ Für wen ist es gedacht?

* Entwickler, die oft neue Server einrichten
* Teams, die einheitliche Dev-Umgebungen wollen
* AI-Entwickler, die schnell mit modernen Tools loslegen möchten

---

## 📦 Unterstützt

* Ubuntu 18.04 – 24.04
* Debian 10 – 12
* x86\_64 & ARM64

---

**Kurz gesagt:**
Einfach starten, auswählen, loslegen. Dein Dev-Server ist in 10 Minuten einsatzbereit.

---
