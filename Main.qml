import QtQuick
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello Brandon")

    SecondWindow {
        id: secondWindow
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Text {
            id: messageText
            text: "Welcome to Mwanatech"
            font.pixelSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Option 1"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                messageText.text = "You clicked Option 1 - we have a winner"
            }
        }

        Button {
            text: "Option 2"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                messageText.text = "You clicked Option 2 - Second round's on me"
            }
        }

        Button {
            text: "Option 3"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                messageText.text = "You have finally clocked Option 3 - Knockout B"
            }
        }

        Button {
            text: "4th Street"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                messageText.text = "You have finally clocked Option 4 - welcome to club 40/40"
            }
        }

        Button {
            text: "Open Second Window"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                secondWindow.show()
            }
        }

        Rectangle {
            width: 100
            height: 100
            color: "lightblue"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors.centerIn: parent
                text: "Box"
            }
        }
    }
}
