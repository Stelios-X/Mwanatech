import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// BooksGrid.qml
// Grid-based book display with proper scrolling and compact cards

Rectangle {
    id: booksGrid
    color: "#f9fafb"
    
    // Signals to parent component
    signal editBookRequested(int bookId, string title, string author, string status, string contactName, string contactNumber)
    signal deleteBookRequested(int index)
    
    // Property for the book model
    property var bookModel
    
    // Confirmation dialog for deletion
    Dialog {
        id: deleteConfirmDialog
        title: "Confirm Deletion"
        standardButtons: Dialog.Yes | Dialog.No
        width: 350
        height: 150
        
        property int bookIndexToDelete: -1
        property string bookTitleToDelete: ""
        
        Text {
            text: "Are you sure you want to delete \"" + deleteConfirmDialog.bookTitleToDelete + "\"?"
            wrapMode: Text.Wrap
            anchors.fill: parent
            anchors.margins: 20
            verticalAlignment: Text.AlignVCenter
        }
        
        onAccepted: {
            deleteBookRequested(bookIndexToDelete)
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0
        
        // Header with info
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: "#ffffff"
            border.width: 1
            border.color: "#e5e7eb"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                Text {
                    text: "Books (" + (bookModel ? bookModel.count : 0) + ")"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#1f2937"
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: "Use scroll to view more"
                    font.pixelSize: 11
                    color: "#9ca3af"
                    font.italic: true
                }
            }
        }
        
        // Grid view with scrollbar
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            
            GridView {
                id: gridView
                model: bookModel
                cellWidth: Math.max(250, parent.width / Math.max(2, Math.floor(parent.width / 280)))
                cellHeight: 280
                
                // Delegate for each book item
                delegate: Rectangle {
                    width: gridView.cellWidth - 10
                    height: gridView.cellHeight - 10
                    color: "#ffffff"
                    border.color: "#e5e7eb"
                    border.width: 1
                    radius: 8
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        // Book info section
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            // Title
                            Text {
                                text: model.title
                                font.bold: true
                                font.pixelSize: 13
                                color: "#1f2937"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            
                            // Author
                            Text {
                                text: "by " + model.author
                                font.italic: true
                                font.pixelSize: 11
                                color: "#6b7280"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        
                        // Status badge
                        Rectangle {
                            Layout.fillWidth: true
                            height: 28
                            color: model.status === "SHELF" ? "#dcfce7" : 
                                   model.status === "LOANED" ? "#dbeafe" : "#fed7aa"
                            radius: 4
                            
                            Text {
                                anchors.centerIn: parent
                                text: model.status
                                font.bold: true
                                font.pixelSize: 11
                                color: model.status === "SHELF" ? "#166534" : 
                                       model.status === "LOANED" ? "#1e40af" : "#92400e"
                            }
                        }
                        
                        // Contact info (if applicable)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(50, contactCol.implicitHeight + 8)
                            color: "#f3f4f6"
                            radius: 4
                            visible: model.status !== "SHELF"
                            
                            ColumnLayout {
                                id: contactCol
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 2
                                
                                Text {
                                    text: model.status === "LOANED" ? "To:" : "From:"
                                    font.bold: true
                                    font.pixelSize: 10
                                    color: "#4b5563"
                                }
                                
                                Text {
                                    text: model.contactName
                                    font.pixelSize: 10
                                    color: "#1f2937"
                                    elide: Text.ElideRight
                                }
                                
                                Text {
                                    text: model.contactNumber
                                    font.pixelSize: 9
                                    color: "#6b7280"
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true }
                        
                        // Action buttons
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Button {
                                text: "Edit"
                                Layout.fillWidth: true
                                Layout.preferredHeight: 32
                                font.pixelSize: 11
                                
                                background: Rectangle {
                                    color: "#3b82f6"
                                    radius: 4
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    color: "#ffffff"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 11
                                }
                                
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
                                Layout.preferredHeight: 32
                                font.pixelSize: 11
                                
                                background: Rectangle {
                                    color: "#ef4444"
                                    radius: 4
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    color: "#ffffff"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pixelSize: 11
                                }
                                
                                onClicked: {
                                    deleteConfirmDialog.bookIndexToDelete = index
                                    deleteConfirmDialog.bookTitleToDelete = model.title
                                    deleteConfirmDialog.open()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
