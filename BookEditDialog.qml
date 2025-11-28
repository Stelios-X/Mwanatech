import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// BookEditDialog.qml
// Reusable dialog for adding/editing book records
// Maintains OOP principles with signals and properties

Dialog {
    id: editDialog
    
    // Properties for data binding
    property int bookId: -1
    property string bookTitle: ""
    property string bookAuthor: ""
    property string bookStatus: "SHELF"
    property string bookContactName: ""
    property string bookContactNumber: ""
    
    // Signals emitted to parent
    signal addBookRequested(string title, string author, string status, string contactName, string contactNumber)
    signal updateBookRequested(int id, string title, string author, string status, string contactName, string contactNumber)
    
    // Dialog configuration
    width: 450
    height: 550
    title: bookId === -1 ? "Add New Book" : "Edit Book"
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    // Form validation
    property bool isFormValid: titleInput.text.length > 0 && authorInput.text.length > 0
    
    onAccepted: {
        if (!isFormValid) return
        
        if (bookId === -1) {
            addBookRequested(
                titleInput.text,
                authorInput.text,
                statusCombo.currentText,
                contactNameInput.text,
                contactNumberInput.text
            )
        } else {
            updateBookRequested(
                bookId,
                titleInput.text,
                authorInput.text,
                statusCombo.currentText,
                contactNameInput.text,
                contactNumberInput.text
            )
        }
    }
    
    onOpened: {
        titleInput.text = bookTitle
        authorInput.text = bookAuthor
        statusCombo.currentIndex = statusCombo.indexOfValue(bookStatus)
        contactNameInput.text = bookContactName
        contactNumberInput.text = bookContactNumber
        titleInput.forceActiveFocus()
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Title:"; Layout.preferredWidth: 80 }
            TextField {
                id: titleInput
                placeholderText: "Book title"
                Layout.fillWidth: true
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Author:"; Layout.preferredWidth: 80 }
            TextField {
                id: authorInput
                placeholderText: "Author name"
                Layout.fillWidth: true
            }
        }
        
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Status:"; Layout.preferredWidth: 80 }
            ComboBox {
                id: statusCombo
                model: ["SHELF", "LOANED", "BORROWED"]
                Layout.fillWidth: true
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: "#f5f5f5"
            radius: 3
            visible: statusCombo.currentText !== "SHELF"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8
                
                Text {
                    text: statusCombo.currentText === "LOANED" ? "Loaned To:" : "Borrowed From:"
                    font.bold: true
                }
                
                TextField {
                    id: contactNameInput
                    placeholderText: "Contact name"
                    Layout.fillWidth: true
                }
                
                TextField {
                    id: contactNumberInput
                    placeholderText: "Phone number"
                    Layout.fillWidth: true
                }
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
