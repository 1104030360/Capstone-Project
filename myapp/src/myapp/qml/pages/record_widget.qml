import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    anchors.fill: parent
    Material.theme: Material.Light
    Material.accent: Material.Blue

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "Select Customer Camera (cam0)"
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignCenter
            color: "#2C3E50"
        }
        ComboBox {
            id: cam0ComboBox
            Layout.fillWidth: true
            model: deviceFinder.cameras
            font.pixelSize: 16
        }

        Text {
            text: "Select Staff Camera (cam1)"
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignCenter
            color: "#2C3E50"
        }
        ComboBox {
            id: cam1ComboBox
            Layout.fillWidth: true
            model: deviceFinder.cameras
            font.pixelSize: 16
        }

        Text {
            text: "Select Microphone"
            font.pixelSize: 18
            font.bold: true
            Layout.alignment: Qt.AlignCenter
            color: "#2C3E50"
        }
        ComboBox {
            id: micComboBox
            Layout.fillWidth: true
            model: deviceFinder.microphones
            font.pixelSize: 16
        }

        Button {
            text: qsTr("Activate")
            Layout.fillWidth: true
            font.pixelSize: 18
            font.bold: true
            onClicked: {
                if (cam0ComboBox.currentIndex !== cam1ComboBox.currentIndex) {
                    deviceFinder.startRecording(cam0ComboBox.currentIndex, cam1ComboBox.currentIndex, micComboBox.currentIndex)
                } else {
                    console.log("Staff and Customer cameras must be different!")
                }
            }
        }

        Text {
            id: warningText
            visible: false
            color: "#E74C3C"
            text: "Staff and Customer cameras must be different!"
            font.pixelSize: 14
            Layout.alignment: Qt.AlignCenter
        }

        Connections {
            target: cam0ComboBox
            function onCurrentIndexChanged() {
                warningText.visible = cam0ComboBox.currentIndex === cam1ComboBox.currentIndex
            }
        }

        Connections {
            target: cam1ComboBox
            function onCurrentIndexChanged() {
                warningText.visible = cam0ComboBox.currentIndex === cam1ComboBox.currentIndex
            }
        }
    }
}
