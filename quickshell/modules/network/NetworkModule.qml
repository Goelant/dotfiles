import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: networkModule
    
    property string networkState: "disconnected"
    property string networkIcon: "󰌙"
    property int signalStrength: 0
    
    width: 30
    height: 30
    color: "transparent"
    radius: 3
    
    Text {
        anchors.centerIn: parent
        text: networkModule.networkIcon
        color: networkModule.networkState === "connected" ? "white" : "#ff6b6b"
        font.pixelSize: 14
    }
    
    MouseArea {
        id: networkMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            // Launch network manager (nmcli)
            networkLaunchProcess.command = ["foot", "--app-id=floating-terminal", "nmcli", "device", "wifi"]
            networkLaunchProcess.running = true
        }

        onEntered: {
            networkModule.color = "#c5e8ff13"
        }
        
        onExited: {
            networkModule.color = "transparent"
        }
        
        // Simple tooltip overlay
        Rectangle {
            visible: parent.containsMouse
            color: "#c5e8ff"
            border.color: "#c5e8ff"
            border.width: 1
            radius: 4
            width: networkTooltipText.width + 8
            height: networkTooltipText.height + 4
            x: parent.mouseX + 10
            y: parent.mouseY - height - 5
            z: 1000
            
            Text {
                id: networkTooltipText
                anchors.centerIn: parent
                text: "Network Manager (nmcli)"
                color: "#ffffff"
                font.pixelSize: 10
            }
        }
    }
    
    Timer {
        id: networkTimer
        interval: 5000
        running: true
        repeat: true
        
        onTriggered: updateNetworkStatus()
    }
    
    Component.onCompleted: updateNetworkStatus()
    
    Process {
        id: networkLaunchProcess
        running: false
    }
    
    Process {
        id: networkCheckProcess
        command: ["sh", "-c", "nmcli -t -f WIFI,STATE general"]
        running: false
        
        onExited: function(exitCode, stdout, stderr) {
            if (exitCode === 0 && stdout) {
                var output = stdout.trim().split(':')
                if (output.length >= 2) {
                    var wifiEnabled = output[0] === "enabled"
                    var state = output[1]
                    
                    if (state === "connected") {
                        networkModule.networkState = "connected"
                        // Check if connected via WiFi or Ethernet
                        networkDetailProcess.running = true
                    } else {
                        networkModule.networkState = "disconnected"
                        networkModule.networkIcon = wifiEnabled ? "󰤭" : "󰌙"
                    }
                }
            } else {
                // Fallback - assume connected
                networkModule.networkState = "connected"
                networkModule.networkIcon = "󰤨"
            }
        }
    }
    
    Process {
        id: networkDetailProcess
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep ':connected' | head -1"]
        running: false
        
        onExited: function(exitCode, stdout, stderr) {
            if (exitCode === 0 && stdout) {
                var output = stdout.trim()
                if (output.includes("wifi")) {
                    networkModule.networkIcon = "󰤨"  // WiFi connected
                } else if (output.includes("ethernet")) {
                    networkModule.networkIcon = "󰈀"  // Ethernet connected
                } else {
                    networkModule.networkIcon = "󰤨"  // Default to WiFi icon
                }
            } else {
                networkModule.networkIcon = "󰤨"  // Default fallback
            }
        }
    }
    
    function updateNetworkStatus() {
        networkCheckProcess.running = true
    }
    
    // Hover animation
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
