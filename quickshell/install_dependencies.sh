#!/bin/bash

echo "Installation des dépendances pour QuickShell..."

# Vérifier si yay est installé
if ! command -v yay &> /dev/null; then
    echo "❌ yay n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

echo "📦 Installation de QuickShell avec support Hyprland..."
yay -S --needed quickshell-git

echo "🌐 Installation de NetworkManager..."
sudo pacman -S --needed networkmanager

echo "🔧 Activation de NetworkManager..."
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "🔋 Vérification des fichiers de batterie..."
if ls /sys/class/power_supply/BAT* 1> /dev/null 2>&1; then
    echo "✅ Batterie détectée:"
    ls -la /sys/class/power_supply/BAT*/
else
    echo "⚠️  Aucune batterie détectée (normal sur un PC de bureau)"
fi

echo "🖥️  Vérification de Hyprland..."
if command -v hyprctl &> /dev/null; then
    echo "✅ Hyprland est installé"
    hyprctl version
else
    echo "❌ Hyprland n'est pas installé ou n'est pas en cours d'exécution"
fi

echo "🎵 Vérification de PulseAudio/PipeWire..."
if command -v pactl &> /dev/null; then
    echo "✅ PulseAudio/PipeWire est disponible"
else
    echo "⚠️  PulseAudio/PipeWire n'est pas détecté"
    echo "Installation de PipeWire..."
    sudo pacman -S --needed pipewire pipewire-pulse pipewire-alsa
fi

echo "🔧 Installation d'outils supplémentaires..."
sudo pacman -S --needed pavucontrol foot

echo ""
echo "✅ Installation terminée!"
echo ""
echo "Pour démarrer QuickShell:"
echo "  quickshell -c /path/to/your/quickshell/shell.qml"
echo ""
echo "Pour tester la détection réseau:"
echo "  nmcli general status"
echo ""
echo "Pour tester la batterie:"
echo "  cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo 'Pas de batterie'"
