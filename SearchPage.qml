import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// SearchPage.qml
// ============================================================================
// PURPOSE: Provides search and filter interface for the book library
// FEATURES:
//   - Real-time search as user types
//   - Filter by title, author, or status
//   - Display search results in a grid view
//   - Shows result count
//   - Links to edit/delete functionality
// ============================================================================

Rectangle {
    id: searchPage
    color: "#f9fafb"
    
    // ========== SIGNALS ==========
    // These signals communicate with the parent component
    
    // editBookRequested: User clicked edit on a book
    signal editBookRequested(int bookId, string title, string author, string status, string contactName, string contactNumber)
    
    // deleteBookRequested: User wants to delete a book
    signal deleteBookRequested(int index)

    // ========== PROPERTIES ==========
    
    // Note: searchModel is accessed as a global context property from C++
    // No need to declare it here
    
    // ========== MAIN LAYOUT ==========
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // ========== SEARCH CONTROLS SECTION ==========
        // This section contains the search input and filter options
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: "#ffffff"
            border.width: 1
            border.color: "#e5e7eb"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12
                
                // ===== SEARCH TITLE =====
                Text {
                    text: "Search Library"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#1f2937"
                }
                
                // ===== SEARCH INPUT ROW =====
                // Contains the search text field and filter type selector
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    // Search text input field
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        color: "#f3f4f6"
                        border.color: "#d1d5db"
                        border.width: 1
                        radius: 4
                        
                        // Row for icon and text field
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            
                            // Search icon placeholder
                            Text {
                                text: "🔍"
                                font.pixelSize: 16
                            }
                            
                            // Text input field - user types here
                            TextField {
                                id: searchInput
                                placeholderText: "Enter book title, author, or status..."
                                Layout.fillWidth: true
                                background: Rectangle { color: "transparent" }
                                
                                // Trigger search as user types (real-time search)
                                onTextChanged: {
                                    // Only search if there's input text
                                    if (text.length > 0) {
                                        // Get the selected filter type
                                        let filterType = filterCombo.currentText.toLowerCase()
                                        
                                        // Convert filter type to model parameter
                                        let searchType = filterType === "all" ? "all" :
                                                       filterType === "title" ? "title" :
                                                       filterType === "author" ? "author" : "status"
                                        
                                        // Execute the search in C++ model
                                        searchModel.performSearch(text, searchType)
                                    } else {
                                        // If search box is empty, show all books
                                        searchModel.clearSearch()
                                    }
                                }
                            }
                        }
                    }
                    
                    // Filter type selector dropdown
                    ColumnLayout {
                        spacing: 3
                        
                        Text {
                            text: "Filter by:"
                            font.pixelSize: 11
                            color: "#6b7280"
                        }
                        
                        ComboBox {
                            id: filterCombo
                            model: ["All", "Title", "Author", "Status"]
                            Layout.preferredWidth: 120
                            Layout.preferredHeight: 35
                        }
                    }
                    
                    // Clear search button
                    Button {
                        text: "Clear"
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 35
                        
                        background: Rectangle {
                            color: "#f3f4f6"
                            border.color: "#d1d5db"
                            border.width: 1
                            radius: 4
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#6b7280"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 11
                        }
                        
                        // Clear the search when clicked
                        onClicked: {
                            searchInput.text = ""
                            searchModel.clearSearch()
                        }
                    }
                }
            }
        }
        
        // ========== RESULTS DISPLAY SECTION ==========
        // This section shows the grid of search results
        
        // Results header showing count
        Rectangle {
            Layout.fillWidth: true
            height: 45
            color: "#ffffff"
            border.width: 1
            border.color: "#e5e7eb"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                // Display search results count
                Text {
                    text: {
                        // Show different text depending on search state
                        if (searchModel.currentSearch === "") {
                            return "All Books (" + searchModel.resultCount + ")"
                        } else {
                            return "Search Results (" + searchModel.resultCount + ")"
                        }
                    }
                    font.pixelSize: 14
                    font.bold: true
                    color: "#1f2937"
                }
                
                // Show search query if active
                Rectangle {
                    visible: searchModel.currentSearch !== ""
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 28
                    color: "#dbeafe"
                    radius: 4
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Searching for: \"" + searchModel.currentSearch + "\""
                        font.pixelSize: 11
                        color: "#1e40af"
                    }
                }
                
                Item { Layout.fillWidth: true }
            }
        }
        
        // ========== RESULTS GRID ==========
        // Displays books in a responsive grid layout
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            
            GridView {
                id: resultsGrid
                model: searchModel
                cellWidth: Math.max(250, parent.width / Math.max(2, Math.floor(parent.width / 280)))
                cellHeight: 280
                
                // Delegate: Template for each book card in the grid
                delegate: Rectangle {
                    width: resultsGrid.cellWidth - 10
                    height: resultsGrid.cellHeight - 10
                    color: "#ffffff"
                    border.color: "#e5e7eb"
                    border.width: 1
                    radius: 8
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        // ===== BOOK INFO SECTION =====
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            // Book title
                            Text {
                                text: model.title
                                font.bold: true
                                font.pixelSize: 13
                                color: "#1f2937"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            
                            // Author name
                            Text {
                                text: "by " + model.author
                                font.italic: true
                                font.pixelSize: 11
                                color: "#6b7280"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        
                        // ===== STATUS BADGE =====
                        // Color-coded status indicator
                        Rectangle {
                            Layout.fillWidth: true
                            height: 28
                            // Choose color based on status
                            color: model.status === "SHELF" ? "#dcfce7" : 
                                   model.status === "LOANED" ? "#dbeafe" : "#fed7aa"
                            radius: 4
                            
                            Text {
                                anchors.centerIn: parent
                                text: model.status
                                font.bold: true
                                font.pixelSize: 11
                                // Choose text color to match badge
                                color: model.status === "SHELF" ? "#166534" : 
                                       model.status === "LOANED" ? "#1e40af" : "#92400e"
                            }
                        }
                        
                        // ===== CONTACT INFO SECTION =====
                        // Only shown if book is loaned or borrowed
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
                                
                                // Contact type header
                                Text {
                                    text: model.status === "LOANED" ? "To:" : "From:"
                                    font.bold: true
                                    font.pixelSize: 10
                                    color: "#4b5563"
                                }
                                
                                // Contact person name
                                Text {
                                    text: model.contactName
                                    font.pixelSize: 10
                                    color: "#1f2937"
                                    elide: Text.ElideRight
                                }
                                
                                // Contact phone number
                                Text {
                                    text: model.contactNumber
                                    font.pixelSize: 9
                                    color: "#6b7280"
                                }
                            }
                        }
                        
                        Item { Layout.fillHeight: true }
                        
                        // ===== ACTION BUTTONS =====
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            // Edit button
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
                                
                                // Emit edit signal with book data
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
                            
                            // Delete button
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
                                
                                // Emit delete signal
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
    
    // ========== DELETE CONFIRMATION DIALOG ==========
    // Asks user to confirm before deleting a book
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
        
        // User confirmed deletion
        onAccepted: {
            deleteBookRequested(bookIndexToDelete)
        }
    }
}
