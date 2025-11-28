import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// LandingPage.qml
// Welcome page with library statistics and navigation options

Rectangle {
    id: landingPage
    color: "#ffffff"
    
    // Signals to navigate to different sections
    signal navigateToBrowse
    signal navigateToAdd
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 30
        
        // Header with logo area
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "#f8f9fa"
            radius: 8
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 5
                
                // Logo placeholder (simple styled box)
                Rectangle {
                    width: 60
                    height: 60
                    color: "#3b82f6"
                    radius: 8
                    Layout.alignment: Qt.AlignHCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "📚"
                        font.pixelSize: 36
                    }
                }
                
                Text {
                    text: "Digital Home Library"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#1f2937"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Organize and manage your personal book collection"
                    font.pixelSize: 13
                    color: "#6b7280"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        
        // Statistics cards
        RowLayout {
            Layout.fillWidth: true
            spacing: 20
            
            // Total books card
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: "#dbeafe"
                radius: 8
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 5
                    
                    Text {
                        text: "Total Books"
                        font.pixelSize: 12
                        color: "#1e40af"
                        font.bold: true
                    }
                    
                    Text {
                        text: libraryModel.count
                        font.pixelSize: 32
                        font.bold: true
                        color: "#1e40af"
                    }
                }
            }
            
            // On shelf card
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: "#dcfce7"
                radius: 8
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 5
                    
                    Text {
                        text: "On Shelf"
                        font.pixelSize: 12
                        color: "#15803d"
                        font.bold: true
                    }
                    
                    Text {
                        text: libraryModel.shelfCount
                        font.pixelSize: 32
                        font.bold: true
                        color: "#15803d"
                    }
                }
            }
            
            // Loaned out card
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: "#dbeafe"
                radius: 8
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 5
                    
                    Text {
                        text: "Loaned Out"
                        font.pixelSize: 12
                        color: "#1e40af"
                        font.bold: true
                    }
                    
                    Text {
                        text: libraryModel.loanedCount
                        font.pixelSize: 32
                        font.bold: true
                        color: "#1e40af"
                    }
                }
            }
        }
        
        // Quick action buttons
        Text {
            text: "Quick Actions"
            font.pixelSize: 16
            font.bold: true
            color: "#1f2937"
        }
        
        RowLayout {
            Layout.fillWidth: true
            spacing: 15
            
            Button {
                text: "Browse Library"
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                font.pixelSize: 13
                
                background: Rectangle {
                    color: "#3b82f6"
                    radius: 6
                    border.color: "#1e40af"
                    border.width: 2
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 13
                    font.bold: true
                }
                
                onClicked: navigateToBrowse()
            }
            
            Button {
                text: "Add New Book"
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                font.pixelSize: 13
                
                background: Rectangle {
                    color: "#10b981"
                    radius: 6
                    border.color: "#059669"
                    border.width: 2
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 13
                    font.bold: true
                }
                
                onClicked: navigateToAdd()
            }
        }
        
        Item { Layout.fillHeight: true }
    }
}
