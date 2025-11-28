import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// AddBookForm.qml
// Dedicated page for adding new books with improved layout

Rectangle {
    id: addBookForm
    color: "#f9fafb"
    
    signal bookAdded
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Header
        Text {
            text: "Add New Book"
            font.pixelSize: 24
            font.bold: true
            color: "#1f2937"
        }
        
        // Form card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 450
            color: "#ffffff"
            border.color: "#e5e7eb"
            border.width: 1
            radius: 8
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 25
                spacing: 15
                
                // Title field
                ColumnLayout {
                    spacing: 6
                    
                    Text {
                        text: "Book Title *"
                        font.bold: true
                        font.pixelSize: 12
                        color: "#1f2937"
                    }
                    
                    TextField {
                        id: titleField
                        placeholderText: "Enter book title"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        
                        background: Rectangle {
                            border.color: "#d1d5db"
                            border.width: 1
                            radius: 4
                            color: "#ffffff"
                        }
                    }
                }
                
                // Author field
                ColumnLayout {
                    spacing: 6
                    
                    Text {
                        text: "Author *"
                        font.bold: true
                        font.pixelSize: 12
                        color: "#1f2937"
                    }
                    
                    TextField {
                        id: authorField
                        placeholderText: "Enter author name"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        
                        background: Rectangle {
                            border.color: "#d1d5db"
                            border.width: 1
                            radius: 4
                            color: "#ffffff"
                        }
                    }
                }
                
                // Status field
                ColumnLayout {
                    spacing: 6
                    
                    Text {
                        text: "Status *"
                        font.bold: true
                        font.pixelSize: 12
                        color: "#1f2937"
                    }
                    
                    ComboBox {
                        id: statusCombo
                        model: ["SHELF", "LOANED", "BORROWED"]
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                    }
                }
                
                // Contact info fields (shown based on status)
                ColumnLayout {
                    visible: statusCombo.currentText !== "SHELF"
                    spacing: 15
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#e5e7eb"
                    }
                    
                    Text {
                        text: statusCombo.currentText === "LOANED" ? "Loaned To:" : "Borrowed From:"
                        font.bold: true
                        font.pixelSize: 12
                        color: "#1f2937"
                    }
                    
                    ColumnLayout {
                        spacing: 6
                        
                        Text {
                            text: "Contact Name"
                            font.pixelSize: 11
                            color: "#6b7280"
                        }
                        
                        TextField {
                            id: contactNameField
                            placeholderText: "Enter contact name"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 38
                            
                            background: Rectangle {
                                border.color: "#d1d5db"
                                border.width: 1
                                radius: 4
                                color: "#ffffff"
                            }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 6
                        
                        Text {
                            text: "Phone Number"
                            font.pixelSize: 11
                            color: "#6b7280"
                        }
                        
                        TextField {
                            id: contactNumberField
                            placeholderText: "Enter phone number"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 38
                            
                            background: Rectangle {
                                border.color: "#d1d5db"
                                border.width: 1
                                radius: 4
                                color: "#ffffff"
                            }
                        }
                    }
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Button {
                text: "Add Book"
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                
                background: Rectangle {
                    color: "#10b981"
                    radius: 6
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 13
                    font.bold: true
                }
                
                onClicked: {
                    if (titleField.text === "" || authorField.text === "") {
                        errorDialog.open()
                        return
                    }
                    
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
                    
                    bookAdded()
                }
            }
            
            Button {
                text: "Clear"
                Layout.preferredWidth: 100
                Layout.preferredHeight: 44
                
                background: Rectangle {
                    color: "#f3f4f6"
                    border.color: "#d1d5db"
                    border.width: 1
                    radius: 6
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#6b7280"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 13
                    font.bold: true
                }
                
                onClicked: {
                    titleField.text = ""
                    authorField.text = ""
                    contactNameField.text = ""
                    contactNumberField.text = ""
                    statusCombo.currentIndex = 0
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
    
    Dialog {
        id: errorDialog
        title: "Error"
        standardButtons: Dialog.Ok
        
        Text {
            text: "Please fill in all required fields (marked with *)."
            anchors.fill: parent
            anchors.margins: 15
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
        }
    }
}
