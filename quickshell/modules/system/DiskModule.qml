import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: diskModule
    spacing: 4
    
    property real diskUsage: 0
    property string diskFree: ""
    property string diskTotal: ""
    
    Text {
        text: "󰋊"
        color: "#c5e8ff"
        font.pixelSize: 12
    }
    
    Text {
        text: Math.round(diskModule.diskUsage) + "%"
        color: diskModule.diskUsage > 90 ? "#ff6b6b" : 
               diskModule.diskUsage > 80 ? "#ffa500" : "#c5e8ff"
        font.pixelSize: 12
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        // Simple tooltip using a text overlay
        Rectangle {
            visible: parent.containsMouse
            color: "#c5e8ff"
            border.color: "#c5e8ff"
            border.width: 1
            radius: 4
            width: tooltipText.width + 8
            height: tooltipText.height + 4
            x: parent.mouseX + 10
            y: parent.mouseY - height - 5
            z: 1000
            
            Text {
                id: tooltipText
                anchors.centerIn: parent
                text: "Available " + diskModule.diskFree + " of " + diskModule.diskTotal
                color: "#ffffff"
                font.pixelSize: 10
            }
        }
    }
    
    Timer {
        id: diskTimer
        interval: 30000 // 30 seconds like waybar config
        running: true
        repeat: true
        
        onTriggered: updateDiskUsage()
    }
    
    Component.onCompleted: updateDiskUsage()
    
    Process {
        id: diskProcess
        command: ["df", "-h", "/"]
        running: false
        
        onExited: {
            if (exitCode === 0) {
                var lines = stdout.trim().split('\n')
                if (lines.length >= 2) {
                    var parts = lines[1].split(/\s+/)
                    if (parts.length >= 5) {
                        diskModule.diskTotal = parts[1]
                        diskModule.diskFree = parts[3]
                        var usageStr = parts[4].replace('%', '')
                        var usage = parseFloat(usageStr)
                        if (!isNaN(usage)) {
                            diskModule.diskUsage = usage
                        }
                    }
                }
            }
        }
    }
    
    function updateDiskUsage() {
        diskProcess.running = true
    }
}
