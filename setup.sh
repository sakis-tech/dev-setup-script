#!/bin/bash

# ===============================
# Dev Setup-Script für Entwickler
# ===============================

# Farben definieren
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Unicode Zeichen (fallback zu ASCII wenn Unicode nicht funktioniert)
CHECK="✓"
CROSS="✗"
ARROW="➥"
STAR="★"

# Einfachere Spinner Zeichen (ASCII kompatibel)
SPINNER_CHARS="|/-\\"

# Globale Variablen
SPINNER_PID=""
NODE_VERSION=""
USERNAME=""
USER_PASSWORD=""
INSTALL_DOCKER="false"
INSTALL_DENO="false"
INSTALL_BMAD="false"
INSTALL_CLAUDE_CODE="false"
INSTALL_CLAUDE_FLOW="false"

# Verbesserte Spinner Funktionen
start_spinner() {
    local msg="$1"
    (
        i=0
        while true; do
            printf "\r${CYAN}[${SPINNER_CHARS:i:1}]${NC} ${msg}   "
            i=$(( (i+1) % ${#SPINNER_CHARS} ))
            sleep 0.2
        done
    ) &
    SPINNER_PID=$!
    disown
}

stop_spinner() {
    if [[ ! -z "$SPINNER_PID" ]]; then
        kill $SPINNER_PID 2>/dev/null
        wait $SPINNER_PID 2>/dev/null
        printf "\r\033[K"  # Lösche die aktuelle Zeile
        SPINNER_PID=""
    fi
}

# Erfolgs- und Fehlermeldungen
success() {
    stop_spinner
    echo -e "${GREEN}[${CHECK}]${NC} $1"
}

error() {
    stop_spinner
    echo -e "${RED}[${CROSS}]${NC} $1"
}

info() {
    echo -e "${BLUE}[i]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Header anzeigen
show_header() {
    clear
    echo -e "${PURPLE}╔═══════════════════════╗${NC}"
    echo -e "${PURPLE}║ ${NC}${WHITE}${STAR} Dev Setup-Script ${STAR}${NC}  ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚═══════════════════════╝${NC}"
    echo ""
}

# Benutzerdaten erfragen
get_user_credentials() {
    show_header
    echo -e "${CYAN}${ARROW} Benutzerdaten eingeben:${NC}"
    echo ""

    # Benutzername erfragen
    while true; do
        read -p "$(echo -e ${YELLOW}"Benutzername eingeben: "${NC})" USERNAME
        if [[ -n "$USERNAME" && "$USERNAME" =~ ^[a-z]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$ ]]; then
            break
        else
            error "Ungültiger Benutzername. Verwende nur Kleinbuchstaben, Zahlen, _ und -"
        fi
    done

    # Passwort erfragen
    while true; do
        read -s -p "$(echo -e ${YELLOW}"Passwort eingeben: "${NC})" USER_PASSWORD
        echo ""
        if [[ ${#USER_PASSWORD} -ge 6 ]]; then
            read -s -p "$(echo -e ${YELLOW}"Passwort wiederholen: "${NC})" PASSWORD_CONFIRM
            echo ""
            if [[ "$USER_PASSWORD" == "$PASSWORD_CONFIRM" ]]; then
                break
            else
                error "Passwörter stimmen nicht überein. Bitte erneut eingeben."
            fi
        else
            error "Passwort muss mindestens 6 Zeichen lang sein."
        fi
    done

    success "Benutzerdaten erfasst: $USERNAME"
    sleep 1
}

# Node.js Version Auswahl
select_node_version() {
    show_header
    echo -e "${CYAN}${ARROW} Node.js Version auswählen:${NC}"
    echo ""
    echo -e "  ${WHITE}1)${NC} Node.js 18 LTS (Hydrogen)"
    echo -e "  ${WHITE}2)${NC} Node.js 20 LTS (Iron)"
    echo -e "  ${WHITE}3)${NC} Node.js 22 (Current)"
    echo -e "  ${WHITE}4)${NC} Node.js 23 (Latest)"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Bitte wähle eine Option [1-4]: "${NC})" choice
        case $choice in
            1) NODE_VERSION="18"; break;;
            2) NODE_VERSION="20"; break;;
            3) NODE_VERSION="22"; break;;
            4) NODE_VERSION="23"; break;;
            *) error "Ungültige Auswahl. Bitte 1-4 eingeben.";;
        esac
    done

    success "Node.js Version $NODE_VERSION ausgewählt"
    sleep 1
}

# BMAD-METHOD Installation Auswahl
select_bmad_installation() {
    show_header
    echo -e "${CYAN}${ARROW} BMAD-METHOD installieren?${NC}"
    echo ""
    echo -e "${WHITE}BMAD-METHOD ist ein AI-gesteuertes Agile-Entwicklungsframework${NC}"
    echo -e "${WHITE}für die Zusammenarbeit mit AI-Agenten in der Softwareentwicklung.${NC}"
    echo ""
    echo -e "${BLUE}Features:${NC}"
    echo -e "  • AI-Agenten für BA, PM, Architect, Dev, UX, etc."
    echo -e "  • Strukturierte Workflows von Ideation bis Implementation"
    echo -e "  • IDE-agnostisch (Cursor, Claude Code, Cline, etc.)"
    echo -e "  • Agile Artifact-Generierung (PRD, Stories, etc.)"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Möchtest du BMAD-METHOD installieren? [J/n]: "${NC})" choice
        case $choice in
            [JjYy]|"") INSTALL_BMAD="true"; break;;
            [Nn]) INSTALL_BMAD="false"; break;;
            *) error "Bitte 'J' für Ja oder 'n' für Nein eingeben.";;
        esac
    done

    if [[ "$INSTALL_BMAD" == "true" ]]; then
        success "BMAD-METHOD wird installiert"
    else
        info "BMAD-METHOD wird übersprungen"
    fi
    sleep 1
}

# Deno Installation Auswahl
select_deno_installation() {
    show_header
    echo -e "${CYAN}${ARROW} Deno installieren?${NC}"
    echo ""
    echo -e "${WHITE}Deno ist eine moderne JavaScript/TypeScript Runtime${NC}"
    echo -e "${WHITE}die als Alternative zu Node.js entwickelt wurde.${NC}"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Möchtest du Deno installieren? [J/n]: "${NC})" choice
        case $choice in
            [JjYy]|"") INSTALL_DENO="true"; break;;
            [Nn]) INSTALL_DENO="false"; break;;
            *) error "Bitte 'J' für Ja oder 'n' für Nein eingeben.";;
        esac
    done

    if [[ "$INSTALL_DENO" == "true" ]]; then
        success "Deno wird installiert"
    else
        info "Deno wird übersprungen"
    fi
    sleep 1
}

# Docker Installation Auswahl
select_docker_installation() {
    show_header
    echo -e "${CYAN}${ARROW} Docker installieren?${NC}"
    echo ""
    echo -e "${WHITE}Docker ist eine Containerisierungs-Plattform${NC}"
    echo -e "${WHITE}für das Entwickeln, Verteilen und Ausführung von Anwendungen.${NC}"
    echo ""
    echo -e "${BLUE}Features:${NC}"
    echo -e "  • Container-Virtualisierung"
    echo -e "  • Docker Compose für Multi-Container-Apps"
    echo -e "  • Isolierte Entwicklungsumgebungen"
    echo -e "  • Einfache Deployment-Workflows"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Möchtest du Docker installieren? [J/n]: "${NC})" choice
        case $choice in
            [JjYy]|"") INSTALL_DOCKER="true"; break;;
            [Nn]) INSTALL_DOCKER="false"; break;;
            *) error "Bitte 'J' für Ja oder 'n' für Nein eingeben.";;
        esac
    done

    if [[ "$INSTALL_DOCKER" == "true" ]]; then
        success "Docker wird installiert"
    else
        info "Docker wird übersprungen"
    fi
    sleep 1
}

# Claude Code Installation Auswahl
select_claude_code_installation() {
    show_header
    echo -e "${CYAN}${ARROW} Claude Code installieren?${NC}"
    echo ""
    echo -e "${WHITE}Claude Code ist ein AI-gesteuerter Code-Assistent von Anthropic${NC}"
    echo -e "${WHITE}für moderne Softwareentwicklung und Code-Generierung.${NC}"
    echo ""
    echo -e "${BLUE}Features:${NC}"
    echo -e "  • AI-unterstützte Code-Entwicklung"
    echo -e "  • Intelligente Code-Vervollständigung"
    echo -e "  • Automatische Code-Refactoring"
    echo -e "  • Integration in moderne IDEs"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Möchtest du Claude Code installieren? [J/n]: "${NC})" choice
        case $choice in
            [JjYy]|"") INSTALL_CLAUDE_CODE="true"; break;;
            [Nn]) INSTALL_CLAUDE_CODE="false"; break;;
            *) error "Bitte 'J' für Ja oder 'n' für Nein eingeben.";;
        esac
    done

    if [[ "$INSTALL_CLAUDE_CODE" == "true" ]]; then
        success "Claude Code wird installiert"
    else
        info "Claude Code wird übersprungen"
    fi
    sleep 1
}

# Claude Flow Installation Auswahl
select_claude_flow_installation() {
    show_header
    echo -e "${CYAN}${ARROW} Claude Flow installieren?${NC}"
    echo ""
    echo -e "${WHITE}Claude Flow ist eine Multi-Agent-Orchestrierungs-Plattform${NC}"
    echo -e "${WHITE}die mit Claude Code zusammenarbeitet und AI-Agenten koordiniert.${NC}"
    echo ""
    echo -e "${BLUE}Features:${NC}"
    echo -e "  • Multi-Agent-Koordination (bis zu 10 Agenten parallel)"
    echo -e "  • SPARC-Entwicklungsumgebung mit 17 spezialisierten Modi"
    echo -e "  • Batch-Operationen und parallele Code-Entwicklung"
    echo -e "  • Memory-Sharing zwischen Agenten für bessere Koordination"
    echo -e "  • Workflow-Orchestrierung für komplette Entwicklungszyklen"
    echo ""

    while true; do
        read -p "$(echo -e ${YELLOW}"Möchtest du Claude Flow installieren? [J/n]: "${NC})" choice
        case $choice in
            [JjYy]|"") INSTALL_CLAUDE_FLOW="true"; break;;
            [Nn]) INSTALL_CLAUDE_FLOW="false"; break;;
            *) error "Bitte 'J' für Ja oder 'n' für Nein eingeben.";;
        esac
    done

    if [[ "$INSTALL_CLAUDE_FLOW" == "true" ]]; then
        success "Claude Flow wird installiert"
    else
        info "Claude Flow wird übersprungen"
    fi
    sleep 1
}

# Benutzer erstellen
create_user() {
    info "Erstelle Benutzer '$USERNAME'..."
    start_spinner "Benutzer wird angelegt"

    if id "$USERNAME" &>/dev/null; then
        stop_spinner
        warning "Benutzer '$USERNAME' existiert bereits"
    else
        # Benutzer erstellen mit Passwort
        useradd -m -s /bin/bash "$USERNAME" &>/dev/null
        echo "$USERNAME:$USER_PASSWORD" | chpasswd &>/dev/null
        usermod -aG sudo "$USERNAME" &>/dev/null
        
        # Warten bis Benutzer vollständig erstellt ist
        sleep 2
        
        # Überprüfen ob Benutzer wirklich existiert
        if id "$USERNAME" &>/dev/null; then
            success "Benutzer '$USERNAME' erstellt und zur sudo-Gruppe hinzugefügt"
        else
            error "Fehler beim Erstellen des Benutzers '$USERNAME'"
            exit 1
        fi
    fi

    # Passwortlose sudo-Rechte
    start_spinner "Konfiguriere sudo-Rechte"
    mkdir -p /etc/sudoers.d
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME-nopasswd
    chmod 440 /etc/sudoers.d/$USERNAME-nopasswd
    success "Passwortlose sudo-Rechte konfiguriert"
}

# System konfigurieren
configure_system() {
    info "Konfiguriere System..."

    # Umgebungsvariable für nicht-interaktive Installation setzen
    export DEBIAN_FRONTEND=noninteractive

    # Zeitzone automatisch auf Europe/Berlin setzen (kann angepasst werden)
    start_spinner "Zeitzone wird konfiguriert"
    timedatectl set-timezone Europe/Berlin &>/dev/null || {
        ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime &>/dev/null
        dpkg-reconfigure -f noninteractive tzdata &>/dev/null
    }
    success "Zeitzone auf Europe/Berlin gesetzt"

    # Locale automatisch konfigurieren
    start_spinner "Locale wird konfiguriert"
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen &>/dev/null
    sed -i '/de_DE.UTF-8/s/^# //g' /etc/locale.gen &>/dev/null
    locale-gen &>/dev/null
    update-locale LANG=de_DE.UTF-8 &>/dev/null
    success "Locale konfiguriert (de_DE.UTF-8 und en_US.UTF-8)"

    # DEBIAN_FRONTEND zurücksetzen
    unset DEBIAN_FRONTEND
}

# System-Update und Pakete mit Spinner statt Fortschrittsbalken
update_system() {
    info "Aktualisiere System und installiere Pakete"

    # Umgebungsvariable für nicht-interaktive Installation
    export DEBIAN_FRONTEND=noninteractive

    start_spinner "System wird aktualisiert"
    apt update &>/dev/null
    success "Paketlisten aktualisiert"

    start_spinner "Führe System-Upgrade durch (das kann einen Moment dauern)..."
    apt upgrade -y &>/dev/null
    success "System-Upgrade abgeschlossen"

    # Pakete installieren mit Spinner
    local packages=(
        "sudo" "git" "python3" "python3-pip" "curl" "wget"
        "jq" "tree" "htop" "unzip" "build-essential"
        "ca-certificates" "gnupg" "lsb-release"
    )

    for pkg in "${packages[@]}"; do
        start_spinner "Installiere Paket: $pkg"
        apt install -y "$pkg" &>/dev/null
        stop_spinner
        success "Paket $pkg installiert"
    done

    unset DEBIAN_FRONTEND
}

# Docker installieren
install_docker() {
    info "Installiere Docker..."

    # 1. Docker herunterladen und installieren
    echo -e "${BLUE}[i]${NC} Lade Docker Installer herunter (das kann einen Moment dauern)..."
    if curl -fsSL https://get.docker.com | sh >/dev/null 2>&1; then
        success "Docker installiert"
    else
        error "Fehler bei der Docker Installation"
        return 1
    fi

    # 2. Benutzer zur Docker-Gruppe hinzufügen
    start_spinner "Benutzer zur Docker-Gruppe hinzufügen"
    usermod -aG docker "$USERNAME" &>/dev/null
    success "Benutzer '$USERNAME' zur Docker-Gruppe hinzugefügt"

    # 3. Docker-Dienst starten
    start_spinner "Docker-Dienst wird gestartet"
    systemctl start docker &>/dev/null
    systemctl enable docker &>/dev/null
    success "Docker-Dienst aktiviert"

    # 4. Docker Compose installieren
    start_spinner "Ermittle neueste Docker Compose Version"
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest 2>/dev/null | grep '"tag_name":' | cut -d'"' -f4)
    stop_spinner
    
    if [[ -n "$COMPOSE_VERSION" ]]; then
        info "Docker Compose Version: $COMPOSE_VERSION"
        
        start_spinner "Docker Compose wird installiert"
        if curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose &>/dev/null && \
           chmod +x /usr/local/bin/docker-compose &>/dev/null; then
            success "Docker Compose installiert"
        else
            stop_spinner
            warning "Docker Compose Installation fehlgeschlagen"
        fi
    else
        warning "Docker Compose Version konnte nicht ermittelt werden"
    fi
}

# Node.js installieren
install_nodejs() {
    info "Installiere Node.js Version $NODE_VERSION..."

    start_spinner "Node.js Repository wird hinzugefügt"
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - &>/dev/null
    success "Node.js Repository hinzugefügt"

    start_spinner "Node.js wird installiert"
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y nodejs &>/dev/null
    unset DEBIAN_FRONTEND
    success "Node.js $NODE_VERSION installiert"
}

# NPM Umgebung einrichten
setup_npm_environment() {
    info "Richte NPM-Umgebung für '$USERNAME' ein..."

    # Überprüfen ob Benutzer existiert
    if ! id "$USERNAME" &>/dev/null; then
        error "Benutzer '$USERNAME' existiert nicht. NPM-Setup abgebrochen."
        return 1
    fi

    start_spinner "NPM-Umgebung wird konfiguriert"
    sudo -u "$USERNAME" bash -c '
        mkdir -p ~/.npm-global
        npm config set prefix ~/.npm-global
        
        # Nur hinzufügen wenn noch nicht vorhanden
        if ! grep -q ".npm-global/bin" ~/.bashrc; then
            echo "export PATH=\$HOME/.npm-global/bin:\$PATH" >> ~/.bashrc
        fi
        if ! grep -q ".npm-global/bin" ~/.profile; then
            echo "export PATH=\$HOME/.npm-global/bin:\$PATH" >> ~/.profile
        fi
    ' 2>/dev/null
    success "NPM-Umgebung konfiguriert"
}

# BMAD-METHOD installieren
install_bmad_method() {
    if [[ "$INSTALL_BMAD" != "true" ]]; then
        info "BMAD-METHOD Installation übersprungen"
        return
    fi

    info "Installiere BMAD-METHOD..."
    
    # Überprüfen ob Benutzer existiert
    if ! id "$USERNAME" &>/dev/null; then
        error "Benutzer '$USERNAME' existiert nicht. BMAD-METHOD Installation abgebrochen."
        return 1
    fi

    # 1. BMAD-METHOD global installieren
    start_spinner "Installiere bmad-method NPM Package global"
    if timeout 120 sudo -u "$USERNAME" bash -c '
        export PATH=$HOME/.npm-global/bin:$PATH
        npm install -g bmad-method
    ' &>/dev/null; then
        success "BMAD-METHOD NPM Package installiert"
    else
        stop_spinner
        warning "BMAD-METHOD NPM Package konnte nicht installiert werden"
        return 1
    fi

    # 2. Projektordner für BMAD erstellen (optional - wird meist in konkreten Projekten gemacht)
    start_spinner "Konfiguriere BMAD-METHOD Umgebung"
    sudo -u "$USERNAME" bash -c '
        cd "$HOME"
        
        # Beispiel-Projektordner erstellen
        mkdir -p bmad-workspace
        cd bmad-workspace
        
        # BMAD in Workspace initialisieren
        export PATH=$HOME/.npm-global/bin:$PATH
        npx bmad-method install --skip-prompts 2>/dev/null || true
        
        # README für den Benutzer erstellen
        cat > README-BMAD.md << "EOF"
# BMAD-METHOD Installation

BMAD-METHOD wurde erfolgreich installiert!

## Erste Schritte:

1. **Neues Projekt starten:**
   ```bash
   mkdir mein-projekt
   cd mein-projekt
   npx bmad-method install
   ```

2. **Vorhandenes Projekt erweitern:**
   ```bash
   cd existing-project
   npx bmad-method install
   ```

3. **Update/Upgrade:**
   ```bash
   npx bmad-method install  # Macht auch Updates
   ```

## Verfügbare AI-Agenten:
- **BA (Business Analyst)**: Marktanalyse und Feature-Ideation
- **PM (Product Manager)**: PRD-Erstellung und Story-Breakdown  
- **Architect**: Technische Architektur-Dokumentation
- **UX Expert**: UI/UX Design und V0-Integration
- **Dev Agent**: Code-Implementation und Story-Ausführung
- **PO (Product Owner)**: Story-Review und Priorisierung

## Weitere Ressourcen:
- GitHub: https://github.com/bmadcode/BMAD-METHOD
- YouTube: BMad Code Channel
- Community: GitHub Discussions

Viel Erfolg with AI-driven Development! 🚀
EOF
    ' 2>/dev/null
    success "BMAD-METHOD Umgebung konfiguriert"

    # 3. Installation überprüfen
    start_spinner "Überprüfe BMAD-METHOD Installation"
    if sudo -u "$USERNAME" bash -c 'export PATH=$HOME/.npm-global/bin:$PATH; which bmad-method >/dev/null 2>&1 || which npx >/dev/null 2>&1' 2>/dev/null; then
        stop_spinner
        success "BMAD-METHOD Installation erfolgreich"
        
        # Version anzeigen mit verbesserter Erkennung
        local bmad_version=$(sudo -u "$USERNAME" bash -c '
            export PATH=$HOME/.npm-global/bin:$PATH
            
            # Versuche verschiedene Wege die Version zu bekommen
            if command -v bmad-method >/dev/null 2>&1; then
                bmad-method --version 2>/dev/null | head -1
            elif command -v npx >/dev/null 2>&1; then
                timeout 10 npx bmad-method --version 2>/dev/null | head -1 || echo "npx verfügbar"
            else
                echo "Installation nicht verifizierbar"
            fi
        ' 2>/dev/null)
        
        if [[ -n "$bmad_version" && "$bmad_version" != "Installation nicht verifizierbar" ]]; then
            info "BMAD Version: $bmad_version"
        else
            info "BMAD-METHOD: Installiert, Version über 'npx bmad-method --version' abrufbar"
        fi
        info "Workspace erstellt in: /home/$USERNAME/bmad-workspace/"
    else
        stop_spinner
        warning "BMAD-METHOD Installation konnte nicht verifiziert werden"
    fi
}

# Deno installieren
install_deno() {
    if [[ "$INSTALL_DENO" != "true" ]]; then
        info "Deno Installation übersprungen"
        return
    fi

    info "Installiere Deno..."
    
    # Überprüfen ob Benutzer existiert
    if ! id "$USERNAME" &>/dev/null; then
        error "Benutzer '$USERNAME' existiert nicht. Deno-Installation abgebrochen."
        return 1
    fi
    
    start_spinner "Lade Deno herunter und installiere (bitte warten)"
    
    # Deno Installation mit verbesserter Fehlerbehandlung
    local install_success="false"
    if sudo -u "$USERNAME" bash -c '
        export HOME=/home/'"$USERNAME"'
        cd "$HOME"
        
        # Installer herunterladen und ausführen
        if curl -fsSL https://deno.land/x/install/install.sh | sh >/dev/null 2>&1; then
            # Überprüfen ob Installation erfolgreich war
            if test -f "$HOME/.deno/bin/deno" && test -x "$HOME/.deno/bin/deno"; then
                exit 0
            else
                exit 1
            fi
        else
            exit 1
        fi
    '; then
        install_success="true"
    fi
    
    stop_spinner
    
    if [[ "$install_success" == "true" ]]; then
        success "Deno Binaries installiert"
        
        # PATH konfigurieren
        start_spinner "Konfiguriere Deno PATH"
        sudo -u "$USERNAME" bash -c '
            # Deno zum PATH hinzufügen (nach NPM, um Konflikte zu vermeiden)
            if ! grep -q "DENO_INSTALL" ~/.bashrc 2>/dev/null; then
                echo "" >> ~/.bashrc
                echo "# Deno Configuration" >> ~/.bashrc
                echo "export DENO_INSTALL=\"\$HOME/.deno\"" >> ~/.bashrc
                echo "export PATH=\"\$PATH:\$DENO_INSTALL/bin\"" >> ~/.bashrc
            fi
            
            if ! grep -q "DENO_INSTALL" ~/.profile 2>/dev/null; then
                echo "" >> ~/.profile
                echo "# Deno Configuration" >> ~/.profile
                echo "export DENO_INSTALL=\"\$HOME/.deno\"" >> ~/.profile
                echo "export PATH=\"\$PATH:\$DENO_INSTALL/bin\"" >> ~/.profile
            fi
        ' 2>/dev/null
        success "Deno PATH konfiguriert"
        
        # Deno Version anzeigen
        local deno_version=$(sudo -u "$USERNAME" bash -c 'export PATH=$HOME/.deno/bin:$PATH; $HOME/.deno/bin/deno --version 2>/dev/null | head -1' 2>/dev/null || echo "Version nicht ermittelbar")
        info "Installierte Version: $deno_version"
    else
        error "Deno Installation fehlgeschlagen"
        warning "Möglicherweise ist curl nicht verfügbar oder Netzwerkprobleme"
        return 1
    fi
}

# Claude Tools installieren
install_claude_tools() {
    # Prüfen ob überhaupt Claude Tools installiert werden sollen
    if [[ "$INSTALL_CLAUDE_CODE" != "true" && "$INSTALL_CLAUDE_FLOW" != "true" ]]; then
        info "Claude Tools Installation übersprungen"
        return
    fi

    info "Installiere ausgewählte Claude Tools..."

    # Überprüfen ob Benutzer existiert
    if ! id "$USERNAME" &>/dev/null; then
        error "Benutzer '$USERNAME' existiert nicht. Claude Tools Installation abgebrochen."
        return 1
    fi

    # Claude Code installieren (falls ausgewählt)
    if [[ "$INSTALL_CLAUDE_CODE" == "true" ]]; then
        start_spinner "Installiere @anthropic-ai/claude-code"
        if timeout 60 sudo -u "$USERNAME" bash -c '
            export PATH=$HOME/.npm-global/bin:$PATH
            npm install -g @anthropic-ai/claude-code
        ' &>/dev/null; then
            success "Claude Code installiert"
        else
            stop_spinner
            warning "Claude Code konnte nicht installiert werden (Timeout oder Fehler)"
        fi
    fi

    # Claude Flow installieren (falls ausgewählt)
    if [[ "$INSTALL_CLAUDE_FLOW" == "true" ]]; then
        start_spinner "Installiere claude-flow@alpha"
        if timeout 120 sudo -u "$USERNAME" bash -c '
            export PATH=$HOME/.npm-global/bin:$PATH
            # Erst prüfen ob das Paket verfügbar ist
            npm view claude-flow@alpha version >/dev/null 2>&1 && npm install -g claude-flow@alpha
        ' &>/dev/null; then
            success "Claude Flow installiert"
        else
            stop_spinner
            warning "Claude Flow konnte nicht installiert werden"
            
            # Alternative versuchen: normale claude-flow Version
            start_spinner "Versuche claude-flow (stable) als Alternative"
            if timeout 60 sudo -u "$USERNAME" bash -c '
                export PATH=$HOME/.npm-global/bin:$PATH
                npm install -g claude-flow 2>/dev/null || npm install -g @anthropic-ai/claude-flow 2>/dev/null
            ' &>/dev/null; then
                success "Claude Flow (alternative Version) installiert"
            else
                stop_spinner
                warning "Keine Claude Flow Version konnte installiert werden"
            fi
        fi
    fi
}

# Installation überprüfen
verify_installation() {
    show_header
    echo -e "${CYAN}${STAR} Installation abgeschlossen! ${STAR}${NC}"
    echo ""

    info "Überprüfe installierte Komponenten:"
    echo ""

    # Node.js Version
    NODE_VER=$(node --version 2>/dev/null || echo "Nicht installiert")
    echo -e "${GREEN}Node.js Version:${NC} $NODE_VER"

    # NPM Version
    NPM_VER=$(npm --version 2>/dev/null || echo "Nicht installiert")
    echo -e "${GREEN}NPM Version:${NC} $NPM_VER"

    # BMAD-METHOD Version (falls installiert)
    if [[ "$INSTALL_BMAD" == "true" ]]; then
        if id "$USERNAME" &>/dev/null; then
            BMAD_VER=$(sudo -u "$USERNAME" bash -c '
                export PATH=$HOME/.npm-global/bin:$PATH
                
                # Versuche verschiedene Wege die Version zu bekommen
                if command -v bmad-method >/dev/null 2>&1; then
                    bmad-method --version 2>/dev/null | head -1
                elif command -v npx >/dev/null 2>&1; then
                    timeout 10 npx bmad-method --version 2>/dev/null | head -1 || echo "npx verfügbar"  
                else
                    echo "nicht verifizierbar"
                fi
            ' 2>/dev/null)
        else
            BMAD_VER="Benutzer nicht gefunden"
        fi
        echo -e "${GREEN}BMAD-METHOD:${NC} $BMAD_VER"
    fi

    # Deno Version (falls installiert)
    if [[ "$INSTALL_DENO" == "true" ]]; then
        if id "$USERNAME" &>/dev/null && sudo -u "$USERNAME" test -f "/home/$USERNAME/.deno/bin/deno"; then
            DENO_VER=$(sudo -u "$USERNAME" bash -c 'export PATH=$HOME/.deno/bin:$PATH; deno --version 2>/dev/null | head -1' 2>/dev/null || echo "Installiert, aber Version nicht abrufbar")
        else
            DENO_VER="Nicht korrekt installiert"
        fi
        echo -e "${GREEN}Deno Version:${NC} $DENO_VER"
    fi

    # Docker Version (falls installiert)
    if [[ "$INSTALL_DOCKER" == "true" ]]; then
        DOCKER_VER=$(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1 || echo "Nicht installiert")
        echo -e "${GREEN}Docker Version:${NC} $DOCKER_VER"

        # Docker Compose Version
        COMPOSE_VER=$(docker-compose --version 2>/dev/null | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "Nicht installiert")
        echo -e "${GREEN}Docker Compose Version:${NC} $COMPOSE_VER"
    fi

    # Claude Tools Versionen (falls installiert) - direkt nach Docker
    if [[ "$INSTALL_CLAUDE_CODE" == "true" || "$INSTALL_CLAUDE_FLOW" == "true" ]]; then
        if id "$USERNAME" &>/dev/null; then
            # Claude Code Version (falls installiert)
            if [[ "$INSTALL_CLAUDE_CODE" == "true" ]]; then
                CLAUDE_CODE_VER=$(sudo -u "$USERNAME" bash -c 'export PATH=$HOME/.npm-global/bin:$PATH; claude --version 2>/dev/null | head -1' 2>/dev/null || echo "Nicht ermittelbar")
                echo -e "${GREEN}Claude Code Version:${NC} $CLAUDE_CODE_VER"
            fi

            # Claude Flow Version (falls installiert) 
            if [[ "$INSTALL_CLAUDE_FLOW" == "true" ]]; then
                CLAUDE_FLOW_VER=$(sudo -u "$USERNAME" bash -c 'export PATH=$HOME/.npm-global/bin:$PATH; claude-flow --version 2>/dev/null | head -1' 2>/dev/null || echo "Nicht ermittelbar")
                echo -e "${GREEN}Claude Flow Version:${NC} $CLAUDE_FLOW_VER"
            fi
        fi
    fi

    echo ""
    echo -e "${GREEN}╔══════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ${WHITE}${CHECK} Setup abgeschlossen! ${CHECK}${NC}   ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════╝${NC}"
    echo ""
    
    if [[ "$INSTALL_DENO" == "true" ]]; then
        echo -e "${YELLOW}Deno Tipp:${NC} Deno ist unter /home/$USERNAME/.deno/bin/deno verfügbar."
    fi

    if [[ "$INSTALL_BMAD" == "true" ]]; then
        echo -e "${YELLOW}BMAD Tipp:${NC} Workspace erstellt unter /home/$USERNAME/bmad-workspace/ mit README-BMAD.md"
    fi
    
    if [[ "$INSTALL_CLAUDE_CODE" == "true" ]]; then
        echo -e "${YELLOW}Claude Code:${NC} AI-Code-Assistent verfügbar über 'claude' Befehl."
    fi
    
    if [[ "$INSTALL_CLAUDE_FLOW" == "true" ]]; then
        echo -e "${YELLOW}Claude Flow:${NC} Multi-Agent-Orchestrierung verfügbar über 'claude-flow' Befehl."
    fi
	echo -e ""
}


# Hauptfunktion
main() {
    # Root-Check
    if [[ $EUID -ne 0 ]]; then
        error "Dieses Script muss als root ausgeführt werden!"
        echo -e "${YELLOW}Verwendung: sudo $0${NC}"
        exit 1
    fi

    show_header

    # Willkommensnachricht
    echo -e "${CYAN}Willkommen zum Dev Setup!${NC}"
    echo -e "${WHITE}Dieses Script installiert eine komplette Entwicklungsumgebung:${NC}"
    echo ""
    echo -e "  ${GREEN}${CHECK}${NC} Benutzer-Management mit sudo-Rechten"
    echo -e "  ${GREEN}${CHECK}${NC} Essential Tools (git, python3, curl, htop, etc.)"
    echo -e "  ${GREEN}${CHECK}${NC} Node.js mit NPM (wählbare LTS-Versionen)"
    echo -e "  ${GREEN}${CHECK}${NC} Docker & Compose (optional Container-Platform)"
    echo -e "  ${GREEN}${CHECK}${NC} BMAD-METHOD (optional AI-Agile Framework)"
    echo -e "  ${GREEN}${CHECK}${NC} Deno Runtime (optional moderne JS/TS)"
    echo -e "  ${GREEN}${CHECK}${NC} Claude Code (optional AI-Code-Assistent)"
    echo -e "  ${GREEN}${CHECK}${NC} Claude Flow (optional Multi-Agent-Orchestrierung)"
    echo ""

    read -p "$(echo -e ${YELLOW}"Möchtest du fortfahren? [J/n]: "${NC})" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Jj]$ ]] && [[ ! -z $REPLY ]]; then
        warning "Installation abgebrochen."
        exit 0
    fi

    # Benutzerdaten erfragen
    get_user_credentials

    # Node.js Version auswählen
    select_node_version

    # Docker Installation auswählen
    select_docker_installation

    # BMAD-METHOD Installation auswählen
    select_bmad_installation

    # Deno Installation auswählen
    select_deno_installation

    # Claude Code Installation auswählen
    select_claude_code_installation

    # Claude Flow Installation auswählen
    select_claude_flow_installation

    # Installation starten
    show_header
    echo -e "${CYAN}${ARROW} Starte Installation...${NC}"
    echo ""

    # Schritte ausführen
    create_user
    configure_system
    update_system
    install_docker          # Docker nur falls gewählt
    install_nodejs
    setup_npm_environment  # NPM zuerst
    install_bmad_method     # BMAD nach NPM, vor Deno
    install_deno           # Deno nach BMAD
    install_claude_tools   # Claude Tools am Ende

    # Überprüfung
    verify_installation

    # In Benutzer-Shell wechseln
	if id "$USERNAME" &>/dev/null; then
		read -p "$(echo -e ${YELLOW}Möchtest du jetzt als Benutzer $USERNAME einloggen? [J/n]: ${NC})" -n 1 -r
		echo
		if [[ $REPLY =~ ^[Jj]$ ]] || [[ -z $REPLY ]]; then
			info "Wechsle zu Benutzer '$USERNAME' und lade Umgebung..."

			sudo -u "$USERNAME" bash -c "
				export PATH=\$HOME/.npm-global/bin:\$PATH:\$HOME/.deno/bin
				cd \$HOME
				source ~/.bashrc 2>/dev/null || true

				echo -e \"${GREEN}✓ Erfolgreich als '$USERNAME' eingeloggt!${NC}\"
				echo -e \"${GREEN}✓ Umgebungsvariablen wurden automatisch geladen${NC}\"
				echo
				echo -e \"${CYAN}Verfügbare Befehle:${NC}\"
				echo -e \"  • node --help\"
				echo -e \"  • npm --help\"
				[[ '$INSTALL_DOCKER' == 'true' ]] && echo -e \"  • docker --help\"
				[[ '$INSTALL_DENO' == 'true' ]] && echo -e \"  • deno --help\"
				[[ '$INSTALL_BMAD' == 'true' ]] && echo -e \"  • npx bmad-method --help\"
				[[ '$INSTALL_CLAUDE_CODE' == 'true' ]] && echo -e \"  • claude --help\"
				[[ '$INSTALL_CLAUDE_FLOW' == 'true' ]] && echo -e \"  • claude-flow --help\"
				echo

				exec bash --login
			"
		fi
	else
		error "Benutzer '$USERNAME' wurde nicht korrekt erstellt. Login nicht möglich."
		echo -e "${YELLOW}Bitte überprüfe die Installation und erstelle den Benutzer manuell.${NC}"
	fi
}

# Script starten
main "$@"
