import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: customButton
    
    property string icon: ""
    property string tooltip: ""
    property string command: ""
    
    width: 30
    height: 30
    color: "transparent"
    radius: 3
    
    Text {
        anchors.centerIn: parent
        text: customButton.icon
        color: "white"
        font.pixelSize: 18
    }
    
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            if (customButton.command !== "") {
                buttonProcess.command = ["sh", "-c", customButton.command]
                buttonProcess.running = true
            }
        }
        
        onEntered: {
            customButton.color = "#c5e8ff13"
        }
        
        onExited: {
            customButton.color = "transparent"
        }
        
        // Simple tooltip overlay
        Rectangle {
            visible: parent.containsMouse && customButton.tooltip !== ""
            color: "#c5e8ff"
            border.color: "#c5e8ff"
            border.width: 1
            radius: 4
            width: buttonTooltipText.width + 8
            height: buttonTooltipText.height + 4
            x: parent.mouseX - 20
            y: parent.mouseY - height + 17
            z: 20000000
            
            Text {
                id: buttonTooltipText
                anchors.centerIn: parent
                text: customButton.tooltip
                color: "#ffffff"
                font.pixelSize: 14
            }
        }
    }
    
    Process {
        id: buttonProcess
        running: false
    }
    
    // Hover animation
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
