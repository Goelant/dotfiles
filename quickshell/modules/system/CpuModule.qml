import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: cpuModule
    spacing: 4
    
    property real cpuUsage: 0
    
    Text {
        id: cpuIcon
        text: " "
        color: "#ffffff"
        font.pixelSize: 14
    }
    
    Text {
        id: cpuText
        text: Math.round(cpuModule.cpuUsage) + "%"
        color: cpuModule.cpuUsage > 80 ? "#ff6b6b" : 
               cpuModule.cpuUsage > 60 ? "#ffa500" : "#ffffff"
        font.pixelSize: 14
    }

    Text {
        text: " "
        color: "#ffffff"
        font.pixelSize: 14
    }
    
    
    Timer {
        id: cpuTimer
        interval: 5000 // 5 seconds like waybar config
        running: true
        repeat: true
        
        onTriggered: updateCpuUsage()
    }
    
    Component.onCompleted: updateCpuUsage()
    
    Process {
        id: cpuProcess
        command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{idle=$8} END {gsub(/,/, \".\", idle); gsub(/id/, \"\", idle); print 100-idle}'"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                var output = data.toString().trim()
                console.log("CPU usage output:", output)
                
                var usage = parseFloat(output)
                if (!isNaN(usage) && usage >= 0 && usage <= 100) {
                    cpuModule.cpuUsage = usage
                    console.log("CPU usage updated:", cpuModule.cpuUsage)
                }
            }
        }
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (data.length > 0) {
                    console.log("CPU usage error:", data.toString())
                }
            }
        }
        
        onExited: function(exitCode) {
            console.log("CPU process exited with code:", exitCode)
        }
    }
    
    function updateCpuUsage() {
        console.log("Updating CPU usage...")
        cpuProcess.running = true
    }
    
    // Hover effect - change text color
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        onEntered: {
            cpuIcon.color = "#c5e8ff"
            cpuText.color = "#c5e8ff"
        }
        
        onExited: {
            // Restore original colors
            cpuIcon.color = "#ffffff"
            cpuText.color = cpuModule.cpuUsage > 80 ? "#ff6b6b" : 
                           cpuModule.cpuUsage > 60 ? "#ffa500" : "#ffffff"
        }
    }
}
