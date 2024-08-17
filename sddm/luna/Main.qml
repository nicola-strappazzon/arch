import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080

    Component {
        id: componentTextField

        TextField {
            property string placeholder: ""
            property int fieldWidth: 200
            property bool isPasswordField: false

            id: componentTextField
            echoMode: isPasswordField ? TextInput.Password : TextInput.Normal
            placeholderText: placeholder
            placeholderTextColor: config.textPlaceholder
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignHLeft
            width: fieldWidth
            height: 30
            font {
                family: config.Font
                pixelSize: config.FontSize
                bold: false
            }

            background: Rectangle {
                id: componentTextFieldBackground
                color: config.lineeditBgNormal
                border.color: config.lineeditBorderNormal
                border.width: 1
                radius: 2
                opacity: config.opacityDefault
            }

            palette {
                highlight: "#dadadc"
                highlightedText: "#7f7f81"
            }

            states: [
                State {
                    name: "hovered"
                    when: componentTextField.hovered
                    PropertyChanges {
                        target: componentTextFieldBackground
                        border.color: config.lineeditBorderHovered
                    }
                },
                State {
                    name: "focused"
                    when: componentTextField.activeFocus
                    PropertyChanges {
                        target: componentTextFieldBackground
                        border.color: config.lineeditBorderFocused
                    }
                }
            ]
        }
    }

    Component {
        id: componentButton

        Button {
            property string iconSource: ""
            property bool isEnabled: true
            property var onClickAction: null

            id: componentButton
            width: 30
            height: 30
            enabled: isEnabled
            hoverEnabled: true
            icon {
                source: iconSource
                color: config.textDefault
            }

            background: Rectangle {
                id: componentButtonBackground
                gradient: Gradient {
                    GradientStop { id: componentButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                    GradientStop { id: componentButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                }
                border.color: config.buttonBorderNormal
                border.width: 1
                radius: 2
                opacity: config.opacityDefault
            }

            states: [
                State {
                    name: "pressed"
                    when: componentButton.down
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.buttonBorderPressed
                        opacity: 1
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop0
                        color: config.buttonBgPressed
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop1
                        color: config.buttonBgPressed
                    }
                },
                State {
                    name: "hovered"
                    when: componentButton.hovered
                    PropertyChanges {
                        target: componentButtonGradientStop0
                        color: config.buttonBgHovered0
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop1
                        color: config.buttonBgHovered1
                    }
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.lineeditBorderHovered
                    }
                },
                State {
                    name: "focused"
                    when: componentButton.activeFocus
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.lineeditBorderFocused
                    }
                },
                State {
                    name: "enabled"
                    when: componentButton.enabled
                    PropertyChanges {
                        target: componentButtonBackground
                    }
                    PropertyChanges {
                        target: componentButtonBackground
                    }
                }
            ]

            onClicked: {
                if (onClickAction) {
                    onClickAction();
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#141416"
        anchors.fill: parent
    }

    Rectangle {
        width: 256
        height: 144
        color: config.bgDark
        anchors.centerIn: parent
        opacity: config.opacityPanel

        Column {
            spacing: 8
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            Loader {
                id: usernameInput
                sourceComponent: componentTextField
                onLoaded: {
                    item.placeholder = "username"
                    item.isPasswordField = false
                }
            }

            Row {
                spacing: 8

                Loader {
                    id: passwordInput
                    sourceComponent: componentTextField
                    onLoaded: {
                        item.width = 162
                        item.placeholder = "password"
                        item.isPasswordField = true
                    }
                }

                Loader {
                    id: loginButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "login.svg"
                        item.isEnabled = usernameInput != "" && passwordInput != "" ? true : false
                        item.onClickAction = function() {
                            sddm.login(usernameInput.text, passwordInput.text, "i3")
                        }
                    }
                }
            }

            Row {
                spacing: 8
                width: parent.width
                height: 30
            }

            Row {
                spacing: 8
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Loader {
                    id: powerButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "power.svg"
                        item.isEnabled = true
                        item.onClickAction = function() {
                            sddm.powerOff()
                        }
                    }
                }

                Loader {
                    id: rebootButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "reboot.svg"
                        item.isEnabled = true
                        item.onClickAction = function() {
                            sddm.reboot()
                        }
                    }
                }

                Loader {
                    id: sleepButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "sleep.svg"
                        item.isEnabled = true
                        item.onClickAction = function() {
                            sddm.suspend()
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            passwordInput.text = ""
            passwordInput.focus = true
        }
    }
}
