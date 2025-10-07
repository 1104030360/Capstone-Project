import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: 400
    height: 50  // 调整高度以适应单行显示

    Row {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "視窗控制選項"
            font.pixelSize: 24
        }

        CheckBox {
            id: exitFullscreenCheckbox
            width: 150
            text: "視窗模式"
            checked: window ? !window.visible : false// 与全屏复选框相反
            onClicked: {
                if (window) {
                    if (checked) {
                        window.showNormal() // 退出全屏模式
                    }
                }
                fullscreenCheckbox.checked = !checked // 点击后更新全屏复选框状态
            }
        }

        CheckBox {
            id: fullscreenCheckbox
            width: 150
            text: "全螢幕模式"
            checked: !fullscreenCheckbox.checked // 默认全屏时选中
            onClicked: {
                if (window) {
                    if (checked) {
                        window.showFullScreen() // 恢复全屏模式
                    }
                }
                exitFullscreenCheckbox.checked = !checked // 点击后更新退出全屏复选框状态
            }
        }
    }

    property var window

    function setWindow(win) {
        window = win
    }
}