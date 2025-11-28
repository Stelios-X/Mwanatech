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
    
    // ========== TIMER FOR SEARCH DELAY ==========
    // This timer provides a small delay before executing search
    // This prevents searching on every single keystroke for better performance
    Timer {
        id: searchDelayTimer
        interval: 300  // Wait 300ms after user stops typing before searching
        running: false
        repeat: false
        
        // When timer fires, execute the search
        onTriggered: {
            executeSearch()
        }
    }
    
    // ========== HELPER FUNCTION ==========
    // This function executes the search based on current UI state
    function executeSearch() {
        // Show loading indicator
        searchBusy.running = true
        
        // Only search if there's input text
        if (searchInput.text.length > 0) {
            // Get the selected filter type
            let filterType = filterCombo.currentText.toLowerCase()
            
            // Convert filter type to model parameter
            let searchType = filterType === "all" ? "all" :
                           filterType === "title" ? "title" :
                           filterType === "author" ? "author" : "status"
            
            // Execute the search in C++ model
            searchModel.performSearch(searchInput.text, searchType)
            
            // Update grid model to show results
            resultsGrid.model = searchModel
        } else {
            // If search box is empty, show empty grid (no results until user searches)
            resultsGrid.model = null
        }
        
        // Hide loading indicator
        searchBusy.running = false
    }
    
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
                    spacing: 12
                    
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
                                
                                // Handle Enter key press for search
                                onAccepted: {
                                    executeSearch()
                                }
                                
                                // Trigger search as user types (real-time search with delay)
                                onTextChanged: {
                                    // Reset and restart the search delay timer
                                    searchDelayTimer.restart()
                                }
                            }
                            
                            // Loading indicator (shown while searching)
                            BusyIndicator {
                                id: searchBusy
                                running: false
                                implicitWidth: 24
                                implicitHeight: 24
                                visible: running
                            }
                        }
                    }
                    
                    // Filter type selector dropdown
                    ComboBox {
                        id: filterCombo
                        model: ["All", "Title", "Author", "Status"]
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 40
                    }
                    
                    // Search button - explicitly trigger search
                    Button {
                        text: "Search"
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 40
                        
                        background: Rectangle {
                            color: "#3b82f6"
                            radius: 4
                            border.color: "#1e40af"
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            color: "#ffffff"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 12
                            font.bold: true
                        }
                        
                        // Execute search when clicked
                        onClicked: executeSearch()
                    }
                    
                    // Clear search button
                    Button {
                        text: "Clear"
                        Layout.preferredWidth: 70
                        Layout.preferredHeight: 40
                        
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
                            font.pixelSize: 12
                        }
                        
                        // Clear the search when clicked
                        onClicked: {
                            searchInput.text = ""
                            searchModel.clearSearch()
                            resultsGrid.model = null  // Clear grid until new search
                        }
                    }
                }
            }
        }
        
        // ========== RESULTS DISPLAY SECTION ==========
        // This section shows the grid of search results
        
        // ========== RESULTS HEADER ==========
        // Shows the count and status of search results
        Rectangle {
            Layout.fillWidth: true
            height: 45
            color: "#ffffff"
            border.width: 1
            border.color: "#e5e7eb"
            visible: resultsGrid.model !== null  // Only show when there are results
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10
                
                // Display search results count or empty state message
                Text {
                    text: {
                        // If grid is empty, show appropriate message
                        if (resultsGrid.model === null) {
                            return "Enter a search term to find books"
                        } else if (searchModel.resultCount === 0) {
                            return "No results found for \"" + searchModel.currentSearch + "\""
                        } else {
                            return "Search Results (" + searchModel.resultCount + ")"
                        }
                    }
                    font.pixelSize: 14
                    font.bold: true
                    color: searchModel.resultCount === 0 ? "#ef4444" : "#1f2937"
                }
                
                Item { Layout.fillWidth: true }
            }
        }
        
        // ========== RESULTS DISPLAY AREA ==========
        // Shows either empty state or search results in a grid
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Empty state message - shown when no search has been performed
            Rectangle {
                id: emptyStateArea
                anchors.fill: parent
                color: "#f9fafb"
                visible: resultsGrid.model === null
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 15
                    
                    Text {
                        text: "🔍"
                        font.pixelSize: 48
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Start Searching"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#1f2937"
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: "Enter a book title, author name, or select a status filter to see results"
                        font.pixelSize: 13
                        color: "#6b7280"
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
            
            // Results grid - shown when search has been performed
            ScrollView {
                anchors.fill: parent
                visible: resultsGrid.model !== null
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                
                GridView {
                    id: resultsGrid
                    model: null  // Start with no model until user searches
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