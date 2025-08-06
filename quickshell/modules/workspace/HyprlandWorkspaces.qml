import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: workspaces
    spacing: 4
    
    Repeater {
        model: Hyprland.workspaces
        
        Rectangle {
            id: workspaceButton
            width: 20
            height: 20
            radius: 4
            
            property bool isActive: Hyprland.focusedWorkspace ? 
                                  Hyprland.focusedWorkspace.id === modelData.id : false
            property bool hasWindows: modelData.windows ? modelData.windows.length > 0 : false
            
            color: isActive ? "#c5e8ff" : (hasWindows ? "transparent" : "transparent")
            
            Text {
                anchors.centerIn: parent
                text: modelData.id.toString()
                color: parent.isActive ? "white" : (parent.hasWindows ? "#c5e8ff" : "#c5e8ff")
                font.pixelSize: 13
                font.bold: parent.isActive
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                
                onClicked: {
                    Hyprland.dispatch("workspace " + modelData.id)
                }
                
                onWheel: function(wheel) {
                    if (wheel.angleDelta.y > 0) {
                        Hyprland.dispatch("workspace r+1")
                    } else {
                        Hyprland.dispatch("workspace r-1")
                    }
                }
                
                onEntered: {
                    workspaceButton.color = workspaceButton.isActive ? "#c5e8ff" : "transparent"
                }
                
                onExited: {
                    workspaceButton.color = workspaceButton.isActive ? "#c5e8ff" : (workspaceButton.hasWindows ? "transparent" : "transparent")
                }
            }
            
            // Smooth color transitions
            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }
}
