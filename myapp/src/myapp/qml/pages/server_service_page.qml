import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls.Material 2.15

Item {
    id: searchPage
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Date Selection
        RowLayout {
            spacing: 10

            TextField {
                id: startDateField
                placeholderText: "Start Date (YYYY-MM-DD)"
                Layout.fillWidth: true
            }

            TextField {
                id: endDateField
                placeholderText: "End Date (YYYY-MM-DD)"
                Layout.fillWidth: true
            }
        }

        // Search Button
        Button {
            text: "Search"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                serviceManager.search_services(
                    startDateField.text,
                    endDateField.text
                )
            }
        }

        // Fixed Headers
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#dddddd"
            border.color: "#cccccc"
            border.width: 1
            radius: 5

            RowLayout {
                anchors.fill: parent
                spacing: 20
                anchors.margins: 10

                Text {
                    text: "Service ID"
                    font.bold: true
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "Name"
                    font.bold: true
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "Date"
                    font.bold: true
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    text: "Details"
                    font.bold: true
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // Result List
        Rectangle {
            id: resultArea
            color: "#f4f4f4"
            radius: 10
            border.color: "#cccccc"
            border.width: 1
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop

            ColumnLayout {
                anchors.fill: parent
                spacing: 10
                anchors.margins: 10

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ListView {
                        id: resultListView
                        width: parent.width
                        model: resultsModel  // Bind to serviceManager.resultsModel
                        clip: true

                        delegate: Rectangle {
                            width: parent.width
                            height: 60
                            color: index % 2 == 0 ? "#ffffff" : "#f2f2f2"
                            border.color: "#cccccc"
                            border.width: 1
                            radius: 5

                            RowLayout {
                                anchors.fill: parent
                                spacing: 20

                                Text {
                                    text: service_id
                                    font.bold: true
                                    width: parent.width * 0.25
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text: name
                                    font.bold: true
                                    width: parent.width * 0.25
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text: start_datetime
                                    width: parent.width * 0.25
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Button {
                                    text: "Details"
                                    width: parent.width * 0.25
                                    onClicked: {
                                        serverHome.load_service_media(service_id)
                                        mainContentLoader.source = "../../qml/pages/server_service_detail_page.qml"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}