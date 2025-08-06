import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: audioModule
    spacing: 4
    
    property real volume: 50
    property bool muted: false
    
    Text {
        id: volumeIcon
        text: {
            if (audioModule.muted) {
                return "🔇"
            } else if (audioModule.volume <= 33) {
                return "🔈"
            } else if (audioModule.volume <= 66) {
                return "🔉"
            } else {
                return "🔊"
            }
        }
        color: audioModule.muted ? "#ff6b6b" : "#ffffff"
        font.pixelSize: 12
    }
    
    Text {
        text: audioModule.muted ? "MUTE" : Math.round(audioModule.volume) + "%"
        color: audioModule.muted ? "#ff6b6b" : "#ffffff"
        font.pixelSize: 12
    }
    
    MouseArea {
        id: volumeMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        
        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                // Launch pavucontrol
                audioProcess.command = ["pavucontrol"]
                audioProcess.start()
            } else if (mouse.button === Qt.RightButton) {
                // Toggle mute (basic simulation)
                audioModule.muted = !audioModule.muted
            }
        }
        
        onWheel: function(wheel) {
            var delta = wheel.angleDelta.y > 0 ? 5 : -5
            audioModule.volume = Math.max(0, Math.min(100, audioModule.volume + delta))
        }
        
        // Simple tooltip overlay
        Rectangle {
            visible: parent.containsMouse
            color: "#c5e8ff"
            border.color: "#c5e8ff"
            border.width: 1
            radius: 4
            width: volumeTooltipText.width + 8
            height: volumeTooltipText.height + 4
            x: parent.mouseX + 10
            y: parent.mouseY - height - 5
            z: 1000
            
            Text {
                id: volumeTooltipText
                anchors.centerIn: parent
                text: Math.round(audioModule.volume) + "%"
                color: "#ffffff"
                font.pixelSize: 10
            }
        }
    }
    
    Process {
        id: audioProcess
    }
}
