import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: systemTray
    spacing: 4
    
    property var trayItems: SystemTray.items
    
    Repeater {
        model: systemTray.trayItems
        
        Rectangle {
            id: trayItem
            width: 16
            height: 16
            color: "transparent"
            
            property var item: modelData
            
            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: trayItem.item ? trayItem.item.icon : ""
                smooth: true
                
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    
                    onClicked: function(mouse) {
                        if (!trayItem.item) return
                        
                        if (mouse.button === Qt.LeftButton) {
                            trayItem.item.activate()
                        } else if (mouse.button === Qt.RightButton) {
                            trayItem.item.openContextMenu()
                        } else if (mouse.button === Qt.MiddleButton) {
                            trayItem.item.secondaryActivate()
                        }
                    }
                    
                    onWheel: function(wheel) {
                        if (!trayItem.item) return
                        trayItem.item.scroll(wheel.angleDelta.x, wheel.angleDelta.y)
                    }
                }
            }
            
            // Simple tooltip overlay
            Rectangle {
                visible: trayMouseArea.containsMouse && trayItem.item
                color: "#c5e8ff"
                border.color: "#c5e8ff"
                border.width: 1
                radius: 4
                width: trayTooltipText.width + 8
                height: trayTooltipText.height + 4
                x: trayMouseArea.mouseX + 10
                y: trayMouseArea.mouseY - height - 5
                z: 1000
                
                Text {
                    id: trayTooltipText
                    anchors.centerIn: parent
                    text: trayItem.item ? (trayItem.item.tooltip || trayItem.item.title || "") : ""
                    color: "#ffffff"
                    font.pixelSize: 10
                }
            }
            
            MouseArea {
                id: trayMouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }
        }
    }
}
