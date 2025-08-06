import QtQuick
import QtQuick.Layouts

Item {
    id: clockGroup
    
    width: clockRow.width + 16
    height: 30
    
    // Background with black color and 0.1 opacity
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.1
        radius: 6
        border.color: "#c5e8ff"
        border.width: 1
    }
    
    RowLayout {
        id: clockRow
        anchors.centerIn: parent
        spacing: 8
        
        ClockModule {
            id: clock
        }
    }
}
