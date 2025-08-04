# Limitations et contraintes pour travailler avec Waybar

## Contraintes CSS

### Compatibilité GTK3 uniquement
- Waybar utilise GTK3 CSS, qui est un sous-ensemble du CSS standard
- Documentation officielle : https://docs.gtk.org/gtk3/css-overview.html
- Certaines propriétés CSS modernes ne sont pas supportées
- Les validateurs CSS standard peuvent afficher des erreurs qui sont en fait des faux positifs

### Propriétés CSS limitées
- Éviter les propriétés CSS récentes (flexbox, grid, etc.)
- Se limiter aux propriétés de base : padding, margin, background, border, color
- Les transitions sont supportées mais avec des propriétés limitées
- Les ombres et effets avancés peuvent ne pas fonctionner

### Variables CSS (@define-color)
- Utiliser `@define-color` pour définir des couleurs réutilisables
- Format : `@define-color nom_variable rgba(r, g, b, a);`
- Référencer avec `@nom_variable` dans les propriétés

## Contraintes de configuration

### Format JSON strict
- Le fichier config doit être un JSON valide
- Pas de commentaires autorisés dans le JSON
- Guillemets doubles obligatoires pour les chaînes
- Virgules correctement placées (pas de virgule finale)

### Modules disponibles limités
- `wlr/taskbar` : affiche toutes les applications (difficile de limiter)
- `hyprland/window` : affiche uniquement la fenêtre active (recommandé)
- Certains modules nécessitent des dépendances système spécifiques

## Contraintes des polices et icônes

### Polices Nerd Font obligatoires
- Les icônes waybar nécessitent des polices Nerd Font
- Polices recommandées : "Ubuntu Nerd Font", "JetBrainsMono Nerd Font"
- Installer la police avant de l'utiliser dans la configuration
- Format : `font-family: "Ubuntu Nerd Font", "Ubuntu", sans-serif;`

### Taille des icônes
- Les icônes peuvent être difficiles à voir avec de petites tailles
- Recommandé : `font-size: 16px` minimum pour les icônes
- Module audio souvent problématique : utiliser des émojis ou des icônes alternatives

## Contraintes système

### Environnement Wayland requis
- Waybar ne fonctionne que sous Wayland (pas X11)
- Nécessite un compositeur compatible (Hyprland, Sway, etc.)
- Messages d'erreur si lancé hors environnement Wayland

### Redémarrage nécessaire
- Waybar doit être redémarré après chaque modification
- Commande : `pkill waybar && waybar &`
- Pas de rechargement à chaud de la configuration

## Modules spécifiques

### Module pulseaudio
- Souvent invisible avec les icônes par défaut
- Solutions :
  - Utiliser des émojis : `🔈`, `🔉`, `🔊`, `🔇`
  - Afficher le pourcentage : `{icon} {volume}%`
  - Fond contrasté et taille de police plus grande

### Module hyprland/window vs wlr/taskbar
- `wlr/taskbar` : affiche toutes les applications (difficile à personnaliser)
- `hyprland/window` : affiche uniquement la fenêtre active (plus simple)
- Le paramètre `max-length` dans `wlr/taskbar` ne limite pas le nombre d'éléments

### Modules custom
- Requièrent des scripts externes fonctionnels
- Tester les scripts indépendamment avant intégration
- Chemins absolus recommandés pour les commandes

## Bonnes pratiques

### Organisation des fichiers
- Garder une sauvegarde : `style.css.backup`
- Tester les modifications progressivement
- Documenter les changements importants

### Débogage
- Lancer waybar en terminal pour voir les erreurs
- Vérifier les logs système si waybar ne démarre pas
- Tester la configuration JSON avec un validateur

### Performance
- Éviter les intervalles trop courts pour les modules système
- Limiter le nombre de modules custom avec scripts
- Utiliser `separate-outputs: true` pour les setups multi-écrans

## Erreurs communes

1. **CSS non valide** : Vérifier la compatibilité GTK3
2. **Police manquante** : Installer les Nerd Fonts
3. **JSON invalide** : Vérifier la syntaxe avec un validateur
4. **Modules non fonctionnels** : Vérifier les dépendances système
5. **Waybar ne démarre pas** : Vérifier l'environnement Wayland

## Ressources utiles

- Documentation officielle : https://github.com/Alexays/Waybar/wiki
- CSS GTK3 : https://docs.gtk.org/gtk3/css-overview.html
- Nerd Fonts : https://www.nerdfonts.com/
- Exemples de configuration : https://github.com/Alexays/Waybar/wiki/Examples
