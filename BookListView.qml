import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// BookListView.qml
// Reusable list view component for displaying library books
// Maintains OOP design with signals and properties

Rectangle {
    id: bookListView
    color: "transparent"
    
    // Signals to parent component
    signal editBookRequested(int bookId, string title, string author, string status, string contactName, string contactNumber)
    signal deleteBookRequested(int index)
    
    // Property for the book model
    property var bookModel
    
    ListView {
        id: listView
        anchors.fill: parent
        model: bookModel
        spacing: 8
        clip: true
        
        // Delegate for each book item
        delegate: Rectangle {
            width: listView.width
            height: 90
            color: "#f5f5f5"
            border.color: "#ddd"
            border.width: 1
            radius: 4
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15
                
                // Book Info
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3
                    
                    Text {
                        text: model.title
                        font.bold: true
                        font.pixelSize: 14
                        elide: Text.ElideRight
                    }
                    
                    Text {
                        text: "by " + model.author
                        font.italic: true
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }
                }
                
                // Status
                ColumnLayout {
                    Layout.preferredWidth: 160
                    spacing: 2
                    
                    Text {
                        text: model.status
                        font.bold: true
                        color: model.status === "SHELF" ? "#27ae60" : 
                               model.status === "LOANED" ? "#2980b9" : "#e67e22"
                    }
                    
                    Text {
                        visible: model.status !== "SHELF"
                        text: (model.status === "LOANED" ? "To: " : "From: ") + model.contactName
                        font.pixelSize: 10
                    }
                    
                    Text {
                        visible: model.status !== "SHELF"
                        text: "Tel: " + model.contactNumber
                        font.pixelSize: 10
                    }
                }
                
                // Buttons
                RowLayout {
                    Layout.preferredWidth: 140
                    spacing: 5
                    
                    Button {
                        text: "Edit"
                        Layout.fillWidth: true
                        onClicked: {
                            editBookRequested(
                                model.id,
                                model.title,
                                model.author,
                                model.status,
                                model.contactName,
                                model.contactNumber
                            )
                        }
                    }
                    
                    Button {
                        text: "Delete"
                        Layout.fillWidth: true
                        onClicked: deleteBookRequested(index)
                    }
                }
            }
        }
    }
}
