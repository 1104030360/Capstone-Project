import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: serverHomeButton
    title: "Service Scores"

    property real dailyServiceCount: 0
    property real weeklyServiceCount: 0
    property var dailyCustomerScores: ({'total': 0, 'text': 0, 'audio': 0, 'facial': 0})
    property var dailyServerScores: ({'total': 0, 'text': 0, 'audio': 0, 'facial': 0})
    property var weeklyCustomerScores: ({'total': 0, 'text': 0, 'audio': 0, 'facial': 0})
    property var weeklyServerScores: ({'total': 0, 'text': 0, 'audio': 0, 'facial': 0})

    property bool showDaily: true

    Connections {
        target: serviceScoreManager

        function onUpdateDailyServiceCount(value) {
            dailyServiceCount = value;
        }

        function onUpdateWeeklyServiceCount(value) {
            weeklyServiceCount = value;
        }

        function onUpdateDailyScores(customerScores, serverScores) {
            dailyCustomerScores = customerScores;
            dailyServerScores = serverScores;
        }

        function onUpdateWeeklyScores(customerScores, serverScores) {
            weeklyCustomerScores = customerScores;
            weeklyServerScores = serverScores;
        }
    }

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: 20
        }
        spacing: 20
        Layout.alignment: Qt.AlignCenter

        // Modernized Button Bar using Rectangle
        RowLayout {
            id: tabbar
            Layout.fillWidth: true
            spacing: 20
            Layout.alignment: Qt.AlignCenter

            Rectangle {
                width: 180
                height: 60
                radius: 30
                color: showDaily ? "#e53935" : "#e0e0e0"  // Red when selected, gray otherwise
                border.color: "#e53935"  // Red border
                border.width: 2

                Text {
                    text: "Daily Scores"
                    anchors.centerIn: parent
                    font.pixelSize: 18
                    color: showDaily ? "#ffffff" : "#000000"  // White text when selected, black otherwise
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: showDaily = true
                }
            }

            Rectangle {
                width: 180
                height: 60
                radius: 30
                color: !showDaily ? "#e53935" : "#e0e0e0"  // Red when selected, gray otherwise
                border.color: "#e53935"  // Red border
                border.width: 2

                Text {
                    text: "Weekly Scores"
                    anchors.centerIn: parent
                    font.pixelSize: 18
                    color: !showDaily ? "#ffffff" : "#000000"  // White text when selected, black otherwise
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: showDaily = false
                }
            }
        }

        // Daily Scores Section
        ColumnLayout {
            visible: showDaily
            spacing: 30
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter

            Text {
                text: "Daily service counts: " + dailyServiceCount
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            // Customer Scores Section
            ColumnLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "Customer Scores"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                }

                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignCenter

                    Repeater {
                        model: ["total", "text", "audio", "facial"]

                        ColumnLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignCenter

                            // Customer Circles for Daily
                            Canvas {
                                width: 150
                                height: 150

                                onPaint: {
                                    var ctx = getContext("2d");
                                    var centerX = width / 2;
                                    var centerY = height / 2;
                                    var radius = width / 2.5;
                                    var startAngle = -Math.PI / 2;
                                    var scoreValue = dailyCustomerScores[modelData] / 100;
                                    var endAngle = startAngle + (isNaN(scoreValue) ? 0 : scoreValue) * 2 * Math.PI;

                                    // Determine color based on score range
                                    var scoreColor;
                                    if (scoreValue >= 0.85) {
                                        scoreColor = "green"; // 100~85
                                    } else if (scoreValue >= 0.7) {
                                        scoreColor = "orange"; // 85~70
                                    } else {
                                        scoreColor = "red"; // Below 70
                                    }

                                    ctx.strokeStyle = "#e0e0e0";
                                    ctx.lineWidth = 14;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                                    ctx.stroke();

                                    ctx.strokeStyle = scoreColor;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                                    ctx.stroke();

                                    ctx.fillStyle = "#000";
                                    ctx.font = "bold 24px Arial";
                                    ctx.textAlign = "center";
                                    ctx.textBaseline = "middle";
                                    ctx.fillText(Math.round(scoreValue * 100).toString(), centerX, centerY);
                                }
                            }

                            Text {
                                text: (modelData == "total") ? "OVERALL" : (modelData == "text") ? "TEXT" : (modelData == "audio") ? "AUDIO" : "FACIAL"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }

            // Server Scores Section
            ColumnLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "Server Scores"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                }

                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignCenter

                    Repeater {
                        model: ["total", "text", "audio", "facial"]

                        ColumnLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignCenter

                            // Server Circles for Daily
                            Canvas {
                                width: 150
                                height: 150

                                onPaint: {
                                    var ctx = getContext("2d");
                                    var centerX = width / 2;
                                    var centerY = height / 2;
                                    var radius = width / 2.5;
                                    var startAngle = -Math.PI / 2;
                                    var scoreValue = dailyServerScores[modelData] / 100;
                                    var endAngle = startAngle + (isNaN(scoreValue) ? 0 : scoreValue) * 2 * Math.PI;

                                    // Determine color based on score range
                                    var scoreColor;
                                    if (scoreValue >= 0.85) {
                                        scoreColor = "green"; // 100~85
                                    } else if (scoreValue >= 0.7) {
                                        scoreColor = "orange"; // 85~70
                                    } else {
                                        scoreColor = "red"; // Below 70
                                    }

                                    ctx.strokeStyle = "#e0e0e0";
                                    ctx.lineWidth = 14;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                                    ctx.stroke();

                                    ctx.strokeStyle = scoreColor;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                                    ctx.stroke();

                                    ctx.fillStyle = "#000";
                                    ctx.font = "bold 24px Arial";
                                    ctx.textAlign = "center";
                                    ctx.textBaseline = "middle";
                                    ctx.fillText(Math.round(scoreValue * 100).toString(), centerX, centerY);
                                }
                            }

                            Text {
                                text: (modelData == "total") ? "OVERALL" : (modelData == "text") ? "TEXT" : (modelData == "audio") ? "AUDIO" : "FACIAL"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }
        }

        // Weekly Scores Section
        ColumnLayout {
            visible: !showDaily
            spacing: 30
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter

            Text {
                text: "Weekly service counts: " + weeklyServiceCount
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignCenter
            }

            // Customer Scores Section
            ColumnLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "Customer Scores"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                }

                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignCenter

                    Repeater {
                        model: ["total", "text", "audio", "facial"]

                        ColumnLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignCenter

                            // Customer Circles for Weekly
                            Canvas {
                                width: 150
                                height: 150

                                onPaint: {
                                    var ctx = getContext("2d");
                                    var centerX = width / 2;
                                    var centerY = height / 2;
                                    var radius = width / 2.5;
                                    var startAngle = -Math.PI / 2;
                                    var scoreValue = weeklyCustomerScores[modelData] / 100;
                                    var endAngle = startAngle + (isNaN(scoreValue) ? 0 : scoreValue) * 2 * Math.PI;

                                    // Determine color based on score range
                                    var scoreColor;
                                    if (scoreValue >= 0.85) {
                                        scoreColor = "green"; // 100~85
                                    } else if (scoreValue >= 0.7) {
                                        scoreColor = "orange"; // 85~70
                                    } else {
                                        scoreColor = "red"; // Below 70
                                    }

                                    ctx.strokeStyle = "#e0e0e0";
                                    ctx.lineWidth = 14;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                                    ctx.stroke();

                                    ctx.strokeStyle = scoreColor;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                                    ctx.stroke();

                                    ctx.fillStyle = "#000";
                                    ctx.font = "bold 24px Arial";
                                    ctx.textAlign = "center";
                                    ctx.textBaseline = "middle";
                                    ctx.fillText(Math.round(scoreValue * 100).toString(), centerX, centerY);
                                }
                            }

                            Text {
                                text: (modelData == "total") ? "OVERALL" : (modelData == "text") ? "TEXT" : (modelData == "audio") ? "AUDIO" : "FACIAL"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }

            // Server Scores Section
            ColumnLayout {
                spacing: 20
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "Server Scores"
                    font.pixelSize: 22
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignCenter
                }

                RowLayout {
                    spacing: 30
                    Layout.alignment: Qt.AlignCenter

                    Repeater {
                        model: ["total", "text", "audio", "facial"]

                        ColumnLayout {
                            spacing: 10
                            Layout.alignment: Qt.AlignCenter

                            // Server Circles for Weekly
                            Canvas {
                                width: 150
                                height: 150

                                onPaint: {
                                    var ctx = getContext("2d");
                                    var centerX = width / 2;
                                    var centerY = height / 2;
                                    var radius = width / 2.5;
                                    var startAngle = -Math.PI / 2;
                                    var scoreValue = weeklyServerScores[modelData] / 100;
                                    var endAngle = startAngle + (isNaN(scoreValue) ? 0 : scoreValue) * 2 * Math.PI;

                                    // Determine color based on score range
                                    var scoreColor;
                                    if (scoreValue >= 0.85) {
                                        scoreColor = "green"; // 100~85
                                    } else if (scoreValue >= 0.7) {
                                        scoreColor = "orange"; // 85~70
                                    } else {
                                        scoreColor = "red"; // Below 70
                                    }

                                    ctx.strokeStyle = "#e0e0e0";
                                    ctx.lineWidth = 14;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                                    ctx.stroke();

                                    ctx.strokeStyle = scoreColor;
                                    ctx.beginPath();
                                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                                    ctx.stroke();

                                    ctx.fillStyle = "#000";
                                    ctx.font = "bold 24px Arial";
                                    ctx.textAlign = "center";
                                    ctx.textBaseline = "middle";
                                    ctx.fillText(Math.round(scoreValue * 100).toString(), centerX, centerY);
                                }
                            }

                            Text {
                                text: (modelData == "total") ? "OVERALL" : (modelData == "text") ? "TEXT" : (modelData == "audio") ? "AUDIO" : "FACIAL"
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                Layout.alignment: Qt.AlignCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
