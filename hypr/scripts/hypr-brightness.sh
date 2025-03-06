#!/bin/bash

# Nom du script: hypr-brightness.sh
# Dépendances: ddcutil, jq, hyprctl

# Obtenir l'écran actif (celui qui a le focus)
get_focused_monitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name'
}

# Obtenir tous les écrans disponibles
get_all_monitors() {
    hyprctl monitors -j | jq -r '.[].name'
}

# Mapper le nom de l'écran Hyprland vers un numéro de bus I2C
get_i2c_bus() {
    local monitor="$1"
    local display_info
    
    # Essayer de trouver le bus I2C pour le moniteur spécifié
    # Cette correspondance peut nécessiter des ajustements selon votre système
    case "$monitor" in
        "DP-1")
            # Trouver automatiquement le bus I2C pour DP-1
            display_info=$(ddcutil detect | grep -B 5 -A 5 "DP-1" | grep "I2C bus")
            if [ -n "$display_info" ]; then
                echo "$display_info" | grep -oP '/dev/i2c-\K\d+'
            else
                # Si non trouvé automatiquement, essayer des valeurs probables
                echo "3"  # Valeur par défaut pour DP-1, à ajuster
            fi
            ;;
        "DP-2")
            display_info=$(ddcutil detect | grep -B 5 -A 5 "DP-2" | grep "I2C bus")
            if [ -n "$display_info" ]; then
                echo "$display_info" | grep -oP '/dev/i2c-\K\d+'
            else
                echo "4"  # Valeur par défaut pour DP-2, à ajuster
            fi
            ;;
        "HDMI-A-2")
            display_info=$(ddcutil detect | grep -B 5 -A 5 "HDMI-A-2" | grep "I2C bus")
            if [ -n "$display_info" ]; then
                echo "$display_info" | grep -oP '/dev/i2c-\K\d+'
            else
                echo "5"  # Valeur par défaut pour HDMI-A-2, à ajuster
            fi
            ;;
        *)
            # Si le moniteur n'est pas reconnu, essayer de détecter automatiquement
            ddcutil detect | grep -B 5 -A 5 "$monitor" | grep -oP '/dev/i2c-\K\d+' | head -n 1
            ;;
    esac
}

# Obtenir la luminosité actuelle d'un écran
get_brightness() {
    local monitor="$1"
    local bus=$(get_i2c_bus "$monitor")
    
    if [ -z "$bus" ]; then
        echo "0"
        return
    fi
    
    # Utiliser ddcutil pour obtenir la luminosité (VCP code 10)
    local result=$(ddcutil getvcp 10 -b "$bus" 2>/dev/null)
    # echo "$result"
    if [ $? -eq 0 ]; then
        echo "$result" | grep -oP 'current value =\s*\K\d+'
    else
        echo "0"
    fi
}

# Définir la luminosité pour un écran
set_brightness() {
    local monitor="$1"
    local value="$2"
    local bus=$(get_i2c_bus "$monitor")
    
    if [ -z "$bus" ]; then
        echo "Impossible de trouver le bus I2C pour $monitor" >&2
        return 1
    fi
    
    # Utiliser ddcutil pour définir la luminosité (VCP code 10)
    ddcutil setvcp 10 "$value" -b "$bus" 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la définition de la luminosité pour $monitor" >&2
        return 1
    fi
}

# Générer la sortie pour Waybar
generate_waybar_output() {
    local output="{"
    local first=true
    local focused_monitor=$(get_focused_monitor)
    local focused_brightness="0"
    
    for monitor in $(get_all_monitors); do
        brightness=$(get_brightness "$monitor")
        # Assurons-nous que brightness est un nombre
        if ! [[ "$brightness" =~ ^[0-9]+$ ]]; then
            brightness="0"
        fi
        
        if [ "$first" = true ]; then
            first=false
        else
            output+=", "
        fi
        output+="\"$monitor\": \"$brightness\""
        
        if [ "$monitor" = "$focused_monitor" ]; then
            focused_brightness="$brightness"
        fi
    done
    
    output+="}"
    # Ajouter le moniteur avec focus et sa luminosité pour un accès plus facile
    echo "{\"output\": $output, \"focused\": \"$focused_monitor\", \"brightness\": \"$focused_brightness\"}"
}

# Fonction de débogage: afficher les informations de détection DDC
debug_ddc() {
    echo "Informations DDC et moniteurs:"
    echo "=== Moniteurs détectés par ddcutil ==="
    ddcutil detect
    echo ""
    echo "=== Moniteurs Hyprland ==="
    hyprctl monitors
    echo ""
    echo "=== Résolution de bus I2C ==="
    for monitor in $(get_all_monitors); do
        bus=$(get_i2c_bus "$monitor")
        echo "$monitor -> Bus I2C: $bus"
    done
}

# Traitement des arguments
case "$1" in
    get)
        if [ -z "$2" ]; then
            monitor=$(get_focused_monitor)
        else
            monitor="$2"
        fi
        get_brightness "$monitor"
        ;;
    set)
        if [ -z "$3" ]; then
            monitor=$(get_focused_monitor)
        else
            monitor="$2"
            shift
        fi
        set_brightness "$monitor" "$2"
        ;;
    up)
        if [ -z "$3" ]; then
            monitor=$(get_focused_monitor)
            value="${2:-5}"
        else
            monitor="$2"
            value="${3:-5}"
        fi
        current=$(get_brightness "$monitor")
        new_value=$((current + value))
        [ $new_value -gt 100 ] && new_value=100
        set_brightness "$monitor" "$new_value"
        ;;
    down)
        if [ -z "$3" ]; then
            monitor=$(get_focused_monitor)
            value="${2:-5}"
        else
            monitor="$2"
            value="${3:-5}"
        fi
        current=$(get_brightness "$monitor")
        new_value=$((current - value))
        [ $new_value -lt 0 ] && new_value=0
        set_brightness "$monitor" "$new_value"
        ;;
    json)
        generate_waybar_output
        ;;
    debug)
        debug_ddc
        ;;
    *)
        echo "Usage: $0 [get [monitor]] | [set [monitor] value] | [up [monitor] [value]] | [down [monitor] [value]] | json | debug"
        exit 1
        ;;
esac

exit 0
