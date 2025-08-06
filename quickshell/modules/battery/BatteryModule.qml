import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: batteryModule
    spacing: 4
    
    property int batteryLevel: 100
    property string batteryStatus: "Unknown"
    property string batteryIcon: "󰂁"
    property bool isCharging: false
    
    Text {
        text: batteryModule.batteryIcon
        color: {
            if (batteryModule.isCharging) {
                return "#00ff00"
            } else if (batteryModule.batteryLevel <= 15) {
                return "#ff6b6b"
            } else if (batteryModule.batteryLevel <= 30) {
                return "#ffa500"
            } else {
                return "#ffffff"
            }
        }
        font.pixelSize: 14
    }
    
    Text {
        text: batteryModule.batteryLevel + "%"
        color: {
            if (batteryModule.isCharging) {
                return "#00ff00"
            } else if (batteryModule.batteryLevel <= 15) {
                return "#ff6b6b"
            } else if (batteryModule.batteryLevel <= 30) {
                return "#ffa500"
            } else {
                return "#ffffff"
            }
        }
        font.pixelSize: 14
    }
    
    Timer {
        id: batteryTimer
        interval: 10000 // 10 seconds
        running: true
        repeat: true
        
        onTriggered: updateBatteryStatus()
    }
    
    Component.onCompleted: updateBatteryStatus()
    
    // Process for battery capacity
    Process {
        id: capacityProcess
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        
        stdout: StdioCollector {
            id: capacityCollector
            
            onStreamFinished: {
                var output = data.toString().trim()
                console.log("Battery capacity output:", output)
                
                var capacity = parseInt(output)
                if (!isNaN(capacity) && capacity >= 0 && capacity <= 100) {
                    batteryModule.batteryLevel = capacity
                    updateBatteryIcon()
                }
            }
        }
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (data.length > 0) {
                    console.log("Battery capacity error:", data)
                }
            }
        }
        
        onExited: function(exitCode) {
            console.log("Battery capacity process exited with code:", exitCode)
            if (exitCode === 0) {
                // Start status process after capacity is done
                statusProcess.running = true
            }
        }
    }
    
    // Process for battery status
    Process {
        id: statusProcess
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        
        stdout: StdioCollector {
            id: statusCollector
            
            onStreamFinished: {
                var output = data.toString().trim()
                console.log("Battery status output:", output)
                
                batteryModule.batteryStatus = output
                batteryModule.isCharging = (output === "Charging")
                updateBatteryIcon()
            }
        }
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (data.length > 0) {
                    console.log("Battery status error:", data)
                }
            }
        }
        
        onExited: function(exitCode) {
            console.log("Battery status process exited with code:", exitCode)
        }
    }
    
    function updateBatteryStatus() {
        console.log("Updating battery status...")
        capacityProcess.running = true
    }
    
    function updateBatteryIcon() {
        if (batteryModule.isCharging) {
            batteryModule.batteryIcon = "󰂄"
        } else if (batteryModule.batteryStatus === "Full") {
            batteryModule.batteryIcon = "󰁹"
        } else {
            // Battery icons based on level
            if (batteryModule.batteryLevel >= 95) {
                batteryModule.batteryIcon = "󰁹"
            } else if (batteryModule.batteryLevel >= 90) {
                batteryModule.batteryIcon = "󰂂"
            } else if (batteryModule.batteryLevel >= 80) {
                batteryModule.batteryIcon = "󰂁"
            } else if (batteryModule.batteryLevel >= 70) {
                batteryModule.batteryIcon = "󰂀"
            } else if (batteryModule.batteryLevel >= 60) {
                batteryModule.batteryIcon = "󰁿"
            } else if (batteryModule.batteryLevel >= 50) {
                batteryModule.batteryIcon = "󰁾"
            } else if (batteryModule.batteryLevel >= 40) {
                batteryModule.batteryIcon = "󰁽"
            } else if (batteryModule.batteryLevel >= 30) {
                batteryModule.batteryIcon = "󰁼"
            } else if (batteryModule.batteryLevel >= 20) {
                batteryModule.batteryIcon = "󰁻"
            } else if (batteryModule.batteryLevel >= 10) {
                batteryModule.batteryIcon = "󰁺"
            } else {
                batteryModule.batteryIcon = "󰂎"
            }
        }
        
        console.log("Battery updated - Level:", batteryModule.batteryLevel, "Status:", batteryModule.batteryStatus, "Icon:", batteryModule.batteryIcon)
    }
    
    // Tooltip on hover
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
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
                text: "Battery: " + batteryModule.batteryLevel + "% (" + batteryModule.batteryStatus + ")"
                color: "#ffffff"
                font.pixelSize: 10
            }
        }
    }
}
