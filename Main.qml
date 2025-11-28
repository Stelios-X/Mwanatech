import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 1100
    height: 750
    visible: true
    title: qsTr("Digital Home Library")

    // Dialog for editing books
    BookEditDialog {
        id: editDialog
        
        onUpdateBookRequested: function(id, title, author, status, contactName, contactNumber) {
            libraryModel.updateBook(id, title, author, status, contactName, contactNumber)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Navigation Menu
        NavigationMenu {
            id: navigationMenu
            Layout.fillWidth: true
            
            onHomePage: stackView.currentIndex = 0
            onBrowsePage: stackView.currentIndex = 1
            onAddPage: stackView.currentIndex = 2
            onSearchPage: stackView.currentIndex = 3
        }

        // Stack view for different pages
        StackLayout {
            id: stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            // Page 0: Landing/Home
            LandingPage {
                onNavigateToBrowse: {
                    stackView.currentIndex = 1
                    navigationMenu.currentPage = "browse"
                }
                onNavigateToAdd: {
                    stackView.currentIndex = 2
                    navigationMenu.currentPage = "add"
                }
            }

            // Page 1: Browse Books
            BooksGrid {
                id: booksGridComponent
                bookModel: libraryModel
                
                onEditBookRequested: function(bookId, title, author, status, contactName, contactNumber) {
                    editDialog.bookId = bookId
                    editDialog.bookTitle = title
                    editDialog.bookAuthor = author
                    editDialog.bookStatus = status
                    editDialog.bookContactName = contactName
                    editDialog.bookContactNumber = contactNumber
                    editDialog.open()
                }
                
                onDeleteBookRequested: function(index) {
                    libraryModel.removeBook(index)
                }
            }

            // Page 2: Add Book
            AddBookForm {
                onBookAdded: {
                    // Show success feedback
                    stackView.currentIndex = 1
                    navigationMenu.currentPage = "browse"
                }
            }

            // Page 3: Search
            SearchPage {
                onEditBookRequested: function(bookId, title, author, status, contactName, contactNumber) {
                    editDialog.bookId = bookId
                    editDialog.bookTitle = title
                    editDialog.bookAuthor = author
                    editDialog.bookStatus = status
                    editDialog.bookContactName = contactName
                    editDialog.bookContactNumber = contactNumber
                    editDialog.open()
                }
                
                onDeleteBookRequested: function(index) {
                    libraryModel.removeBook(index)
                }
            }
        }
    }
}
