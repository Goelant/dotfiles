import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../workspace"

Item {
    id: workspaceGroup
    
    width: workspaceRow.width + 20
    height: 31
    
    // Background with square corners
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.12
        radius: 0
        border.color: "#c5e8ff"
        border.width: 1
        bottomRightRadius: 16
        topRightRadius: 16
    }

    
    RowLayout {
        id: workspaceRow
        anchors.centerIn: parent
        spacing: 8
        
        // Hyprland workspaces
        HyprlandWorkspaces {
            id: workspaces
        }

        Rectangle {
            width: 0
            height: 20
            opacity: 0
        }
        
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }

        Rectangle {
            width: 0
            height: 20
            opacity: 0
        }
        
        // Hyprland window title (static due to quickshell process bug)
        Text {
            id: windowTitle
            text: "VS Code - dotfiles"
            color: "#ffffff"
            font.pixelSize: 13
        }

        Rectangle {
            width: 0
            height: 20
            opacity: 0
        }
    }
}
