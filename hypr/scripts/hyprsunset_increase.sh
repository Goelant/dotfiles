#!/bin/bash
# Script: hyprsunset_increase.sh
# Augmente la température (moins de filtre bleu)

# Définir le PATH explicitement
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Fichier pour stocker la température actuelle
TEMP_FILE="/tmp/hyprsunset_temp"

# Température par défaut si le fichier n'existe pas
DEFAULT_TEMP=6500

# Incrément de température
STEP=200

# Température maximale
MAX_TEMP=6500

# Tuer toutes les instances précédentes d'hyprsunset
/usr/bin/pkill hyprsunset 2>/dev/null || true

# Attendre que le processus soit complètement terminé
sleep 0.2

# Lire la température actuelle
if [ -f "$TEMP_FILE" ]; then
    current_temp=$(cat "$TEMP_FILE" 2>/dev/null)
    # Vérifier que la valeur lue est un nombre valide
    if ! [[ "$current_temp" =~ ^[0-9]+$ ]]; then
        current_temp=$DEFAULT_TEMP
    fi
else
    current_temp=$DEFAULT_TEMP
fi

# Calculer la nouvelle température
new_temp=$((current_temp + STEP))

# Vérifier la limite maximale
if [ $new_temp -gt $MAX_TEMP ]; then
    new_temp=$MAX_TEMP
fi

# Trouver le chemin complet d'hyprsunset
HYPRSUNSET_PATH=$(which hyprsunset 2>/dev/null)
if [ -z "$HYPRSUNSET_PATH" ]; then
    # Chemins possibles si which ne fonctionne pas
    for path in /usr/bin/hyprsunset /usr/local/bin/hyprsunset /home/$USER/.local/bin/hyprsunset; do
        if [ -x "$path" ]; then
            HYPRSUNSET_PATH="$path"
            break
        fi
    done
fi

# Appliquer la nouvelle température
if [ -n "$HYPRSUNSET_PATH" ]; then
    "$HYPRSUNSET_PATH" -t $new_temp &
else
    # Fallback : essayer directement
    hyprsunset -t $new_temp &
fi

# Sauvegarder la nouvelle température
echo $new_temp > "$TEMP_FILE"

# Notification avec chemin complet
/usr/bin/notify-send "Hyprsunset" "Température: ${new_temp}K (plus froid)" -t 2000 2>/dev/null || true