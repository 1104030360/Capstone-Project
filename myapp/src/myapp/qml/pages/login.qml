import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: login_window
    visible: true
    width: 1024
    height: 768
    title: "Welcome to ADAM"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Item {
            width: parent.width
            height: parent.height

            Image {
                id: logo
                source: "../../images/logo.jpg" // 请确保这是正确的文件路径
                anchors.fill: parent
                opacity: 0 // 初始透明度为 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 2000 // 淡入时间为 2000 毫秒
                    }
                }

                Component.onCompleted: {
                    console.log("Logo image loaded")
                    logo.opacity = 1 // 触发淡入动画
                }
            }

            Timer {
                interval: 2500 // 比动画稍长，确保动画完全展示
                running: true
                repeat: false
                onTriggered: {
                    console.log("Timer triggered")
                    stackView.replace(loginComponent) // 动画结束后切换页面
                }
            }
        }

        Component {
            id: loginComponent
            Rectangle {
                anchors.fill: parent
                color: "transparent" // 背景透明以显示背景图片

                Image {
                    id: login_image
                    anchors.fill: parent
                    source: "../../images/ADAM_login.png"
                    fillMode: Image.PreserveAspectCrop
                }

                Rectangle {
                    id: login_rectangle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.4
                    height: parent.height * 0.6
                    opacity: 0.5
                    color: "#f0f0f0"
                    radius: 20
                }

                Text {
                    id: logo_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: login_rectangle.y + 50
                    width: 203
                    height: 60
                    color: "#2C3E50"
                    text: qsTr("ADAM")
                    font.pixelSize: 60
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.weight: Font.Bold
                    font.family: "Arial"
                }

                TextField {
                    id: username_textfield
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: logo_text.y + logo_text.height + 60
                    width: 300
                    height: 36
                    placeholderText: qsTr("Username")
                    font.pixelSize: 18
                    background: Rectangle {
                        color: "#FFFFFF"
                        radius: 20
                        border.color: "#BDC3C7"
                        border.width: 1
                    }
                }

                TextField {
                    id: password_textfield
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: username_textfield.y + username_textfield.height + 40
                    width: 300
                    height: 36
                    placeholderText: qsTr("Password")
                    font.pixelSize: 18
                    echoMode: TextInput.Password // 隐藏输入的密码
                    background: Rectangle {
                        color: "#FFFFFF"
                        radius: 20
                        border.color: "#BDC3C7"
                        border.width: 1
                    }
                }

                Rectangle {
                    id: button
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: password_textfield.y + password_textfield.height + 50
                    width: 200
                    height: 50
                    color: mouseArea.containsMouse ? (mouseArea.pressed ? "#21618C" : "#2980B9") : "#3498DB"
                    radius: 10

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: {
                            console.log("Login button clicked")
                            var result = mainWindow.checkLogin(username_textfield.text, password_textfield.text)
                            if (result.success) {
                                console.log("Login successful, account level: " + result.account_level + ", account ID: " + result.account_id)
                                if (result.account_level === "1") {
                                    mainWindow.launchServerHome(result.account_id)
                                } else {
                                    mainWindow.launchAdminHome(result.account_id)
                                }
                                login_window.close()
                            } else {
                                console.log("Login failed")
                                error_message.text = "Login failed, please try again."
                                error_message.visible = true
                            }
                        }

                        onPressed: {
                            button.color = "#21618C"
                        }

                        onReleased: {
                            button.color = mouseArea.containsMouse ? "#2980B9" : "#3498DB"
                        }
                    }

                    Text {
                        text: "Login"
                        anchors.centerIn: parent
                        color: "#ffffff"
                        font.pixelSize: 16
                    }
                }

                Text {
                    id: error_message
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: button.y + button.height + 20
                    color: "red"
                    visible: false
                }
            }
        }
    }
}
