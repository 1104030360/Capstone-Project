import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Page {
    width: 1024
    height: 768
    Material.theme: Material.Light
    Material.accent: Material.Blue

    Rectangle {
        id: reportsPage
        width: parent.width
        height: parent.height
        color: "#f0f0f0"

        Row {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 30

            Column {
                spacing: 20
                width: parent.width * 0.25

                Text {
                    text: "PDF Reports Viewer"
                    font.pixelSize: 32
                    font.bold: true
                    color: "#333333"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    text: "Open PDF"
                    width: 130
                    height: 40
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: pdfHandler.open_pdf("example.pdf")
                }
            }

            // 使用 Rectangle 包裹 Image
            Rectangle {
                width: parent.width * 0.7
                height: parent.height * 0.9
                border.color: "#999999"
                border.width: 2
                radius: 10
                color: "transparent"

                Image {
                    id: pdfImage
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: ""

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            zoomDialog.visible = true  // 点击图片后显示对话框
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: pdfHandler
        function onPdfPageChanged(newImageSource) {
            pdfImage.source = "file:///" + newImageSource.replace(/\\/g, "/");
        }
    }

    // 使用 Dialog 实现透明的放大窗口
    Dialog {
        id: zoomDialog
        modal: true
        focus: true
        width: parent.width  // 让 Dialog 充满全屏
        height: parent.height
        visible: false  // 初始状态为 false，不显示对话框

        // 背景设置为透明
        background: Rectangle {
            color: "transparent"  // 设置背景为透明
        }

        // Dialog 内容部分
        Rectangle {
            id: zoomContainer
            anchors.fill: parent
            color: "transparent"  // 背景也设置为透明

            Flickable {
                id: flickableArea
                width: parent.width
                height: parent.height
                contentWidth: zoomedImage.width * zoomedImage.scale
                contentHeight: zoomedImage.height * zoomedImage.scale
                interactive: true
                boundsBehavior: Flickable.StopAtBounds  // 限制边界

                Image {
                    id: zoomedImage
                    source: pdfImage.source
                    fillMode: Image.PreserveAspectFit
                    scale: 1.0  // 初始缩放比例

                    // 动态调整 Flickable 内容大小
                    onScaleChanged: {
                        flickableArea.contentWidth = zoomedImage.width * zoomedImage.scale
                        flickableArea.contentHeight = zoomedImage.height * zoomedImage.scale
                    }

                    // 鼠标滚轮缩放
                    WheelHandler {
                        onWheel: {
                            if (wheel.angleDelta && wheel.angleDelta.y !== undefined) {
                                zoomedImage.scale += wheel.angleDelta.y > 0 ? 0.1 : -0.1
                            } else if (wheel.pixelDelta && wheel.pixelDelta.y !== undefined) {
                                zoomedImage.scale += wheel.pixelDelta.y > 0 ? 0.05 : -0.05
                            }

                            if (zoomedImage.scale < 1.0) zoomedImage.scale = 1.0
                            if (zoomedImage.scale > 4.0) zoomedImage.scale = 4.0

                            // 更新内容大小
                            flickableArea.contentWidth = zoomedImage.width * zoomedImage.scale
                            flickableArea.contentHeight = zoomedImage.height * zoomedImage.scale
                        }
                    }
                }
            }

            // 关闭按钮
            Button {
                text: "Close"
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 10
                onClicked: zoomDialog.visible = false  // 点击关闭按钮时隐藏对话框
            }
        }
    }
}
