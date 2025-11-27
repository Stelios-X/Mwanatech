import QtQuick
import QtQuick.Controls

Window {
    id: secondWindow
    width: 400
    height: 300
    title: "Second Window"
    visible: false

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "This is the Second Window"
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Close"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                secondWindow.close()
            }
        }
    }
}
