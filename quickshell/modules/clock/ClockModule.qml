import Quickshell
import QtQuick

Row {
    id: clockModule
    spacing: 4
    
    property string currentTime: ""
    property string currentDate: ""
    
    Text {
        text: "     "
        color: "#ffffff"
        font.pixelSize: 12
    }
    
    Text {
        text: clockModule.currentTime
        color: "#ffffff"
        font.pixelSize: 12
        font.bold: true
    }
    
    Timer {
        id: clockTimer
        interval: 1000 // Update every second
        running: true
        repeat: true
        
        onTriggered: updateTime()
    }
    
    Component.onCompleted: updateTime()
    
    function updateTime() {
        var now = new Date()
        
        // Format time as HH:MM
        var hours = now.getHours().toString().padStart(2, '0')
        var minutes = now.getMinutes().toString().padStart(2, '0')
        clockModule.currentTime = hours + ":" + minutes
        
        // Format date as DD/MM/YYYY
        var day = now.getDate().toString().padStart(2, '0')
        var month = (now.getMonth() + 1).toString().padStart(2, '0')
        var year = now.getFullYear()
        clockModule.currentDate = day + "/" + month + "/" + year
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        // You could add calendar popup here if needed
        onClicked: {
            // Optional: launch calendar application
            var process = Quickshell.process({
                command: ["gnome-calendar"]
            })
            process.start()
        }
    }
    
    // Simple tooltip overlay with detailed time info
    MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        
        Rectangle {
            visible: parent.containsMouse
            color: "#c5e8ff"
            border.color: "#c5e8ff"
            border.width: 1
            radius: 4
            width: clockTooltipText.width + 8
            height: clockTooltipText.height + 4
            x: parent.mouseX + 10
            y: parent.mouseY - height - 5
            z: 1000
            
            Text {
                id: clockTooltipText
                anchors.centerIn: parent
                text: {
                    var now = new Date()
                    return now.toLocaleDateString('fr-FR', {
                        weekday: 'long',
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                    }) + " " + now.toLocaleTimeString('fr-FR')
                }
                color: "#ffffff"
                font.pixelSize: 10
            }
        }
    }
}
