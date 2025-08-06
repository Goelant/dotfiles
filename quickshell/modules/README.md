# Modules Quickshell

Cette structure organise les modules quickshell par fonctionnalité :

## Structure des dossiers

- **audio/** - Module de gestion audio (volume, périphériques)
- **battery/** - Module d'affichage de la batterie
- **clock/** - Modules d'horloge et de temps
- **groups/** - Groupes de modules (WorkspaceGroup, SystemModulesGroup)
- **network/** - Module de gestion réseau
- **system/** - Modules système (CPU, disque, etc.)
- **tray/** - Module de barre système
- **workspace/** - Modules de gestion des espaces de travail Hyprland

## Dossiers utilitaires

- **components/** - Composants réutilisables (boutons, etc.)
- **scripts/** - Scripts shell utilitaires

## Utilisation

Chaque module peut être importé dans le shell principal avec :
```qml
import "modules/[nom_du_module]"
```

Les modules sont conçus pour être modulaires et réutilisables.
