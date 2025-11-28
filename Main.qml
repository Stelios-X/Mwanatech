import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 900
    height: 650
    visible: true
    title: qsTr("Digital Home Library")

    // Dialog for adding/editing books
    BookEditDialog {
        id: editDialog
        
        onAddBookRequested: function(title, author, status, contactName, contactNumber) {
            libraryModel.addBook(title, author, status, contactName, contactNumber)
        }
        
        onUpdateBookRequested: function(id, title, author, status, contactName, contactNumber) {
            libraryModel.updateBook(id, title, author, status, contactName, contactNumber)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Header
        Text {
            text: "My Library"
            font.pixelSize: 24
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Add Book Form
        GroupBox {
            title: "Add Book"
            Layout.fillWidth: true
            
            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                Label { text: "Title:" }
                TextField { 
                    id: quickTitleField
                    placeholderText: "Book Title"
                    Layout.fillWidth: true 
                }

                Label { text: "Author:" }
                TextField { 
                    id: quickAuthorField
                    placeholderText: "Author Name"
                    Layout.fillWidth: true 
                }

                Label { text: "Status:" }
                ComboBox {
                    id: quickStatusCombo
                    model: ["SHELF", "LOANED", "BORROWED"]
                    Layout.fillWidth: true
                }

                Label { text: "Contact Name:" }
                TextField { 
                    id: quickContactNameField
                    placeholderText: "Borrower/Lender Name"
                    enabled: quickStatusCombo.currentText !== "SHELF"
                    Layout.fillWidth: true 
                }

                Label { text: "Contact #:" }
                TextField { 
                    id: quickContactNumberField
                    placeholderText: "Phone Number"
                    enabled: quickStatusCombo.currentText !== "SHELF"
                    Layout.fillWidth: true 
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                RowLayout {
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignRight
                    spacing: 10
                    
                    Button {
                        text: "Add Book"
                        onClicked: {
                            if (quickTitleField.text === "" || quickAuthorField.text === "") return
                            
                            libraryModel.addBook(
                                quickTitleField.text,
                                quickAuthorField.text,
                                quickStatusCombo.currentText,
                                quickContactNameField.text,
                                quickContactNumberField.text
                            )
                            
                            quickTitleField.text = ""
                            quickAuthorField.text = ""
                            quickContactNameField.text = ""
                            quickContactNumberField.text = ""
                            quickStatusCombo.currentIndex = 0
                        }
                    }
                }
            }
        }

        // Books List
        BookListView {
            id: bookListComponent
            Layout.fillWidth: true
            Layout.fillHeight: true
            bookModel: libraryModel
            
            // Handle edit requests from list view
            onEditBookRequested: function(bookId, title, author, status, contactName, contactNumber) {
                editDialog.bookId = bookId
                editDialog.bookTitle = title
                editDialog.bookAuthor = author
                editDialog.bookStatus = status
                editDialog.bookContactName = contactName
                editDialog.bookContactNumber = contactNumber
                editDialog.open()
            }
            
            // Handle delete requests from list view
            onDeleteBookRequested: function(index) {
                libraryModel.removeBook(index)
            }
        }
    }
}
