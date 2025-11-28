import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// NavigationMenu.qml
// Horizontal navigation bar for switching between sections

Rectangle {
    id: navMenu
    color: "#ffffff"
    height: 50
    border.width: 1
    border.color: "#e5e7eb"
    
    // Signals for navigation
    signal homePage
    signal browsePage
    signal addPage
    signal searchPage
    
    property string currentPage: "home"
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5
        
        // App logo/name
        Text {
            text: "📚 Library"
            font.pixelSize: 16
            font.bold: true
            color: "#1f2937"
            Layout.margins: 5
        }
        
        Rectangle {
            width: 1
            height: 30
            color: "#d1d5db"
            Layout.margins: 5
        }
        
        // Navigation buttons
        Button {
            text: "Home"
            Layout.preferredWidth: 80
            Layout.preferredHeight: 35
            flat: true
            
            background: Rectangle {
                color: navMenu.currentPage === "home" ? "#eff6ff" : "transparent"
                radius: 4
                border.color: navMenu.currentPage === "home" ? "#3b82f6" : "transparent"
                border.width: 1
            }
            
            contentItem: Text {
                text: parent.text
                color: navMenu.currentPage === "home" ? "#1e40af" : "#6b7280"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
                font.bold: navMenu.currentPage === "home"
            }
            
            onClicked: {
                currentPage = "home"
                homePage()
            }
        }
        
        Button {
            text: "Browse"
            Layout.preferredWidth: 80
            Layout.preferredHeight: 35
            flat: true
            
            background: Rectangle {
                color: navMenu.currentPage === "browse" ? "#eff6ff" : "transparent"
                radius: 4
                border.color: navMenu.currentPage === "browse" ? "#3b82f6" : "transparent"
                border.width: 1
            }
            
            contentItem: Text {
                text: parent.text
                color: navMenu.currentPage === "browse" ? "#1e40af" : "#6b7280"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
                font.bold: navMenu.currentPage === "browse"
            }
            
            onClicked: {
                currentPage = "browse"
                browsePage()
            }
        }
        
        Button {
            text: "Add Book"
            Layout.preferredWidth: 80
            Layout.preferredHeight: 35
            flat: true
            
            background: Rectangle {
                color: navMenu.currentPage === "add" ? "#eff6ff" : "transparent"
                radius: 4
                border.color: navMenu.currentPage === "add" ? "#3b82f6" : "transparent"
                border.width: 1
            }
            
            contentItem: Text {
                text: parent.text
                color: navMenu.currentPage === "add" ? "#1e40af" : "#6b7280"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
                font.bold: navMenu.currentPage === "add"
            }
            
            onClicked: {
                currentPage = "add"
                addPage()
            }
        }
        
        Button {
            text: "Search"
            Layout.preferredWidth: 80
            Layout.preferredHeight: 35
            flat: true
            
            background: Rectangle {
                color: navMenu.currentPage === "search" ? "#eff6ff" : "transparent"
                radius: 4
                border.color: navMenu.currentPage === "search" ? "#3b82f6" : "transparent"
                border.width: 1
            }
            
            contentItem: Text {
                text: parent.text
                color: navMenu.currentPage === "search" ? "#1e40af" : "#6b7280"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 12
                font.bold: navMenu.currentPage === "search"
            }
            
            onClicked: {
                currentPage = "search"
                searchPage()
            }
        }
        
        Item { Layout.fillWidth: true }
    }
}
