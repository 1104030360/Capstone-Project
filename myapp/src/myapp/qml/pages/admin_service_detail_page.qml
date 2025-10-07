import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.5
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Page {
    id: detailPage
    anchors.fill: parent
    title: "Service Details"

    Column {
        spacing: 10
        anchors.fill: parent

        // Back Button
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "< Back"
                Layout.alignment: Qt.AlignLeft
                onClicked: {
                    mainContentLoader.source = "../../qml/pages/admin_service_page.qml"  // Go back to the search page
                }
            }
        }

        // Tab Bar to switch between Video and Charts
        TabBar {
            id: tabBar
            width: parent.width

            TabButton {
                text: "Video Playback"
                onClicked: {
                    viewLoader.sourceComponent = videoPlaybackComponent
                }
            }

            TabButton {
                text: "Chart Viewer"
                onClicked: {
                    viewLoader.sourceComponent = chartsComponent
                }
            }
        }

        // Loader to dynamically load content based on Tab selection
        Loader {
            id: viewLoader
            width: parent.width
            height: parent.height - tabBar.height

            // Load the default component (Video Playback) at the start
            sourceComponent: videoPlaybackComponent
        }
    }

    // Video Playback Component
    Component {
        id: videoPlaybackComponent

        Column {
            spacing: 20
            anchors.fill: parent

            Row {
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter

                // Customer (Cam0) Video
                Column {
                    spacing: 5

                    Text {
                        text: "Customer"
                        font.pixelSize: 20
                        color: Material.primary
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    VideoOutput {
                        id: videoOutputCam0
                        width: 500
                        height: 300
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                // Staff (Cam1) Video
                Column {
                    spacing: 5

                    Text {
                        text: "Staff"
                        font.pixelSize: 20
                        color: Material.primary
                        horizontalAlignment: Text.AlignHCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    VideoOutput {
                        id: videoOutputCam1
                        width: 500
                        height: 300
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }

            // Media Players for synchronized videos and audio
            MediaPlayer {
                id: videoPlayerCam0
                source: mediaModel.cam0Source
                autoPlay: false
                videoOutput: videoOutputCam0
            }

            MediaPlayer {
                id: videoPlayerCam1
                source: mediaModel.cam1Source
                autoPlay: false
                videoOutput: videoOutputCam1
            }

            MediaPlayer {
                id: audioPlayer
                source: mediaModel.audioSource
                autoPlay: false
                audioOutput: AudioOutput {
                    id: audioOutput
                }
            }

            // Play, Pause, Stop Buttons
            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: videoPlayerCam0.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
                    onClicked: {
                        if (videoPlayerCam0.playbackState === MediaPlayer.PlayingState) {
                            videoPlayerCam0.pause()
                            videoPlayerCam1.pause()
                            audioPlayer.pause()
                        } else {
                            videoPlayerCam0.play()
                            videoPlayerCam1.play()
                            audioPlayer.play()
                        }
                    }
                }

                Button {
                    text: "Stop"
                    onClicked: {
                        videoPlayerCam0.stop()
                        videoPlayerCam1.stop()
                        audioPlayer.stop()
                    }
                }
            }

            // Progress Slider and Volume Slider for audio
            Slider {
                width: 600
                from: 0
                to: videoPlayerCam0.duration
                value: videoPlayerCam0.position
                onMoved: {
                    videoPlayerCam0.seek(value)
                    videoPlayerCam1.seek(value)
                    audioPlayer.seek(value)
                }
            }

            Text {
                text: (videoPlayerCam0.position / 1000).toFixed(0) + " / " + (videoPlayerCam0.duration / 1000).toFixed(0) + " seconds"
            }

            Row {
                spacing: 10
                Text {
                    text: "Volume"
                    font.pixelSize: 16
                    color: Material.primary
                }

                Slider {
                    width: 300
                    from: 0
                    to: 1.0
                    value: 0.5
                    onValueChanged: audioOutput.volume = value
                }
            }
        }
    }

    // Chart Viewer Component
    Component {
        id: chartsComponent

        Column {
            spacing: 20
            anchors.fill: parent

            // Image Display Area with reduced size
            Image {
                id: chartImage
                source: chartsModel.chartsSources.length > 0 ? chartsModel.chartsSources[currentIndex] : ""
                fillMode: Image.PreserveAspectFit
                width: parent.width * 0.8  // 80% of the width
                height: parent.height * 0.7  // 70% of the height
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Row for navigation buttons
            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "Previous"
                    enabled: currentIndex > 0
                    onClicked: {
                        if (currentIndex > 0) {
                            currentIndex--
                        }
                    }
                }

                Button {
                    text: "Next"
                    enabled: currentIndex < chartsModel.chartsSources.length - 1
                    onClicked: {
                        if (currentIndex < chartsModel.chartsSources.length - 1) {
                            currentIndex++
                        }
                    }
                }
            }
        }
    }

    // Tracks the current index of the displayed chart
    property int currentIndex: 0
}
