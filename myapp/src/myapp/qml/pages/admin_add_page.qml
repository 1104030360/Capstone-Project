import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import QtQuick.Controls.Material 2.15

Rectangle {
    id: addPage
    width: parent.width
    height: parent.height
    Material.theme: Material.Light
    Material.accent: Material.Green

    property string selectedAccountId: ""
    property string selectedAccountLevel: "1" // Assume default user level
    property string dialogMessage: "" // Initialize the message property

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 40 // Increased spacing for better visibility
        width: 0.8 * parent.width // Adjusted to use 80% of the parent's width

        // Username
        Label {
            text: "Username"
            font.pixelSize: 20 // Increased font size
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: usernameField
            placeholderText: "Enter username"
            font.pixelSize: 18 // Increased font size for text input
            Layout.fillWidth: true
            height: 40 // Increased height for better UI
        }

        // Password
        Label {
            text: "Password"
            font.pixelSize: 20 // Increased font size
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: passwordField
            placeholderText: "Enter password"
            echoMode: TextInput.Password
            font.pixelSize: 18
            Layout.fillWidth: true
            height: 40
        }

        // Name
        Label {
            text: "Name"
            font.pixelSize: 20 // Increased font size
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: nameField
            placeholderText: "Enter name"
            font.pixelSize: 18
            Layout.fillWidth: true
            height: 40
        }

        // Account Level
        Label {
            text: "Account Level"
            font.pixelSize: 20 // Increased font size
            Layout.alignment: Qt.AlignLeft
        }
        ComboBox {
            id: levelField
            model: ["1", "2", "3", "4", "5"] // Adjust based on your levels
            currentIndex: 0
            font.pixelSize: 18
            Layout.fillWidth: true
            height: 40
        }

        // Occupation
        Label {
            text: "Occupation"
            font.pixelSize: 20 // Increased font size
            Layout.alignment: Qt.AlignLeft
        }
        TextField {
            id: occupationField
            placeholderText: "Enter occupation"
            font.pixelSize: 18
            Layout.fillWidth: true
            height: 40
        }

        RowLayout {
            spacing: 30 // Increased spacing between buttons
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: "Add Account"
                font.pixelSize: 20
                width: 200
                height: 50
                Material.background: Material.Green
                Material.foreground: Material.White
                onClicked: {
                    accountManager.add_account(usernameField.text, passwordField.text, nameField.text, levelField.currentText, occupationField.text)
                }
            }

            Button {
                text: "Update Account"
                font.pixelSize: 20
                width: 200
                height: 50
                Material.background: Material.Blue
                Material.foreground: Material.White
                onClicked: {
                    if (selectedAccountId !== "") {
                        accountManager.update_account(selectedAccountId, usernameField.text, passwordField.text, nameField.text, levelField.currentText, occupationField.text)
                    } else {
                        dialogMessage = "Please select an account to update."
                        messageDialog.open()
                    }
                }
            }
        }
    }

    Dialog {
        id: messageDialog
        modal: true
        title: "Message"
        width: 0.5 * parent.width // Increased dialog width

        ColumnLayout {
            anchors.fill: parent
            spacing: 20 // Increased spacing for readability

            Label {
                id: dialogText
                text: dialogMessage // Bind directly to dialogMessage
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                font.pixelSize: 18 // Larger font for the message
            }

            Button {
                text: "OK"
                font.pixelSize: 18
                width: 100
                height: 40
                Layout.alignment: Qt.AlignHCenter
                onClicked: {
                    messageDialog.close()
                }
            }
        }
    }
}
