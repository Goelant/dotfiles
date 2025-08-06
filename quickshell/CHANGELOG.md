# Changelog QuickShell Configuration

## Corrections et améliorations récentes

### ✅ Corrections apportées

1. **NetworkModule - Effet de hover ajouté**
   - Ajout d'un Rectangle de fond avec effet de hover identique aux CustomButton
   - Animation ColorAnimation de 150ms pour une transition fluide
   - Couleur de hover: `#40404013`

2. **Regroupement visuel des modules système**
   - Création du composant `SystemModulesGroup.qml`
   - Regroupe AudioModule, NetworkModule et BatteryModule dans une boîte visuelle
   - Fond blanc semi-transparent avec bordures
   - Séparateurs visuels entre les modules

3. **Visibilité de l'horloge corrigée**
   - Changement de la couleur du texte de `#cccccc` vers `#333333`
   - Ajout du style `font.bold: true` pour une meilleure lisibilité
   - Correction également appliquée au titre de fenêtre Hyprland

4. **Amélioration de la détection de batterie**
   - Script de détection plus robuste avec boucle `for`
   - Support de différents noms de batterie (BAT0, BAT1, etc.)
   - Vérification que la capacité est > 0 avant mise à jour

### 📦 Dépendances et modules requis

**Pour les workspaces Hyprland:**
```bash
yay -S quickshell-git
```

**Pour la détection réseau:**
```bash
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager
```

**Pour la batterie:**
- Aucune installation requise, utilise `/sys/class/power_supply/`
- Fonctionne automatiquement sur les laptops

**Installation automatique:**
```bash
./install_dependencies.sh
```

### 🎨 Structure des fichiers

- `shell.qml` - Configuration principale du panel
- `SystemModulesGroup.qml` - **NOUVEAU** - Groupe visuel pour audio/réseau/batterie
- `NetworkModule.qml` - Module réseau avec effet hover
- `ClockModule.qml` - Horloge avec texte visible
- `BatteryModule.qml` - Détection batterie améliorée
- `AudioModule.qml` - Module audio (inchangé)
- `CustomButton.qml` - Boutons personnalisés (référence pour le style)
- `HyprlandWorkspaces.qml` - Workspaces Hyprland
- `install_dependencies.sh` - **NOUVEAU** - Script d'installation automatique

### 🚀 Utilisation

1. Installer les dépendances:
   ```bash
   ./quickshell/install_dependencies.sh
   ```

2. Lancer QuickShell:
   ```bash
   quickshell -c ~/dotfiles/quickshell/shell.qml
   ```

3. Tester les fonctionnalités:
   - Hover sur NetworkModule → effet visuel
   - Modules audio/réseau/batterie → dans une boîte unifiée
   - Horloge → maintenant visible
   - Batterie → affichage correct du pourcentage

### 🔧 Diagnostic

**Test réseau:**
```bash
nmcli general status
```

**Test batterie:**
```bash
cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 'Pas de batterie'
```

**Test Hyprland:**
```bash
hyprctl version
