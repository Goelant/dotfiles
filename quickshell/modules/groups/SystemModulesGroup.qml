import QtQuick
import QtQuick.Layouts
import "../system"
import "../audio"
import "../network"
import "../battery"
import "../../components"

Item {
    id: systemModulesGroup
    
    property alias audioModule: audio
    property alias networkModule: network
    property alias batteryModule: battery
    
    width: systemRow.width + 24
    height: 31
    
    // Background with black color and 0.12 opacity (20% darker)
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.12
        radius: 16
        border.color: "#c5e8ff"
        border.width: 1
        bottomRightRadius: 0
        topRightRadius: 0
    }
    
    RowLayout {
        id: systemRow
        anchors.centerIn: parent
        spacing: 8
        
        CpuModule {
            id: cpu
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        CustomButton {
            id: updateButton
            icon: "󰚰"
            command: "foot --app-id=floating-terminal -e sh -c 'yay -Syyu; echo \"\\nUpdate completed. Press Enter to close...\"; read'"
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        CustomButton {
            id: nwgButton
            icon: "󰸌"
            command: "nwg-look"
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        CustomButton {
            id: bluetoothButton
            icon: "󰂯"
            command: "foot --app-id=floating-terminal bluetui"
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        AudioModule {
            id: audio
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        NetworkModule {
            id: network
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        BatteryModule {
            id: battery
        }
        
        Rectangle {
            width: 1
            height: 20
            color: "#ffffff"
            opacity: 0.5
        }
        
        // Clock integrated in system modules group with right padding
        Text {
            id: clockText
            property string currentTime: ""
            
            text: clockText.currentTime
            color: "#ffffff"
            font.pixelSize: 14
            font.bold: true
            width: 33

            Timer {
                id: clockTimer
                interval: 1000 // Update every second
                running: true
                repeat: true
                
                onTriggered: clockText.updateTime()
            }
            
            Component.onCompleted: clockText.updateTime()
            
            function updateTime() {
                var now = new Date()
                var hours = now.getHours().toString().padStart(2, '0')
                var minutes = now.getMinutes().toString().padStart(2, '0')
                clockText.currentTime = hours + ":" + minutes
            }
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                
                onEntered: {
                    clockText.color = "#c5e8ff"
                }
                
                onExited: {
                    clockText.color = "#ffffff"
                }
            }
        }
    }
}
