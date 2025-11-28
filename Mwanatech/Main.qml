import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Digital Home Library")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "My Library"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Input Form
        GridLayout {
            columns: 2
            rowSpacing: 10
            columnSpacing: 10

            Label { text: "Title:" }
            TextField { id: titleField; placeholderText: "Book Title"; Layout.fillWidth: true }

            Label { text: "Author:" }
            TextField { id: authorField; placeholderText: "Author Name"; Layout.fillWidth: true }

            Label { text: "Status:" }
            ComboBox {
                id: statusCombo
                model: ["SHELF", "LOANED", "BORROWED"]
                Layout.fillWidth: true
            }

            Label { text: "Contact Name:" }
            TextField { 
                id: contactNameField
                placeholderText: "Borrower/Lender Name"
                enabled: statusCombo.currentText !== "SHELF"
                Layout.fillWidth: true 
            }

            Label { text: "Contact #:" }
            TextField { 
                id: contactNumberField
                placeholderText: "Phone Number"
                enabled: statusCombo.currentText !== "SHELF"
                Layout.fillWidth: true 
            }
        }

        Button {
            text: "Add Book"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                if (titleField.text === "" || authorField.text === "") return;
                
                libraryModel.addBook(
                    titleField.text,
                    authorField.text,
                    statusCombo.currentText,
                    contactNameField.text,
                    contactNumberField.text
                )

                // Clear fields
                titleField.text = ""
                authorField.text = ""
                contactNameField.text = ""
                contactNumberField.text = ""
                statusCombo.currentIndex = 0
            }
        }

        // List View
        ListView {
            id: bookList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: libraryModel
            spacing: 5

            delegate: Rectangle {
                width: bookList.width
                height: 80
                color: "#f0f0f0"
                border.color: "#ddd"
                radius: 5

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { text: model.title; font.bold: true; font.pixelSize: 16 }
                        Text { text: "by " + model.author; font.italic: true }
                    }

                    ColumnLayout {
                        Layout.preferredWidth: 200
                        Text { 
                            text: model.status 
                            color: model.status === "SHELF" ? "green" : (model.status === "LOANED" ? "blue" : "orange")
                            font.bold: true
                        }
                        Text { 
                            text: model.status !== "SHELF" ? (model.status === "LOANED" ? "To: " : "From: ") + model.contactName : ""
                            visible: model.status !== "SHELF"
                        }
                        Text { 
                            text: model.status !== "SHELF" ? "Tel: " + model.contactNumber : ""
                            visible: model.status !== "SHELF"
                        }
                    }

                    Button {
                        text: "Delete"
                        onClicked: libraryModel.removeBook(index)
                    }
                }
            }
        }
    }
}
