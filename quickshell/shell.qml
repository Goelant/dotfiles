import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "modules/groups"
import "modules/tray"

PanelWindow {
    id: panel
    
    anchors {
        top: true
        left: true
        right: true
        bottom: false
    }
    
    implicitHeight: 30
    color: "transparent"
    
    // Background - Hyprland will handle the blur effect
    Rectangle {
        anchors.fill: parent
        color: "#ffffff"
        opacity: 0.3
        
        // Bottom border
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "#ffffff"
            opacity: 0.5
        }
    }
    
    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        spacing: 8
        
        // Left modules
        RowLayout {
            spacing: 8
            
            WorkspaceGroup {
                id: workspaceGroup
            }
        }
        
        // Center spacer
        Item {
            Layout.fillWidth: true
        }
        
        // Right modules
        RowLayout {
            spacing: 8
            
            SystemTray {
                id: tray
            }
            
            SystemModulesGroup {
                id: systemModules
            }
        }
    }
}
