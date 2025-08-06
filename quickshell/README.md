# Quickshell Bar Configuration

Cette configuration quickshell reproduit les fonctionnalités de votre barre waybar existante.

## Modules inclus

### Modules de gauche
- **Hyprland Workspaces** : Affiche les espaces de travail avec indicateurs visuels
- **Hyprland Window** : Titre de la fenêtre active (tronqué à 50 caractères)

### Modules de droite
- **CPU** : Utilisation CPU avec couleurs d'état (mise à jour toutes les 5s)
- **Disk** : Utilisation disque avec tooltip (mise à jour toutes les 30s)
- **System Tray** : Zone de notification système
- **Audio** : Contrôle PulseAudio/Pipewire avec scroll pour volume
- **Custom Buttons** :
  - Update : Lance `yay -Syyu` dans un terminal
  - NWG : Lance `nwg-look` pour la gestion des thèmes
  - Network Manager : Lance `impala` dans un terminal
  - Bluetooth : Lance `bluetui` dans un terminal
- **Network** : État réseau (WiFi/Ethernet) avec indicateur de signal
- **Battery** : État batterie avec icônes et couleurs d'état
- **Clock** : Horloge avec date (format HH:MM - DD/MM/YYYY)

## Fonctionnalités

### Interactions
- **Workspaces** : Clic pour changer d'espace, scroll pour naviguer
- **Audio** : Clic gauche = pavucontrol, clic droit = mute, scroll = volume
- **Network** : Clic = lance impala
- **Clock** : Clic = lance gnome-calendar (optionnel)
- **Custom Buttons** : Clic = exécute la commande associée

### Tooltips
- Tous les modules ont des tooltips informatifs
- Délai d'affichage : 500ms

### Couleurs d'état
- **CPU** : Vert < 60%, Orange 60-80%, Rouge > 80%
- **Disk** : Vert < 80%, Orange 80-90%, Rouge > 90%
- **Battery** : Vert (charge), Orange < 30%, Rouge < 20%
- **Network** : Gris (connecté), Rouge (déconnecté)

## Utilisation

1. Assurez-vous que quickshell est installé
2. Lancez quickshell en spécifiant le fichier shell.qml :
   ```bash
   quickshell -c /home/ram/dotfiles/quickshell/shell.qml
   ```
   
   Ou depuis le dossier quickshell :
   ```bash
   cd /home/ram/dotfiles/quickshell
   quickshell shell.qml
   ```

## Dépendances

- quickshell
- hyprland
- NetworkManager (nmcli)
- PulseAudio/Pipewire
- foot (terminal)
- pavucontrol
- nwg-look
- impala
- bluetui
- yay

## Personnalisation

Vous pouvez modifier les couleurs, icônes et intervalles de mise à jour dans chaque fichier de module correspondant.
