import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080

    Component {
        id: componentTextField

        TextField {
            property string textFieldPlaceholder: ""
            property int textFieldWidth: 200
            property bool isPasswordField: false

            id: componentTextField
            echoMode: isPasswordField ? TextInput.Password : TextInput.Normal
            placeholderText: textFieldPlaceholder
            placeholderTextColor: config.textPlaceholder
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignHLeft
            width: textFieldWidth
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
                    item.textFieldPlaceholder = "username"
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
                        item.textFieldPlaceholder = "password"
                        item.isPasswordField = true
                    }
                }

                Button {
                    id: loginButton
                    width: 30
                    height: 30
                    enabled: usernameInput != "" && passwordInput != "" ? true : false
                    hoverEnabled: true
                    icon {
                        source: "login.svg"
                        color: config.textDefault
                    }

                    background: Rectangle {
                        id: loginButtonBackground
                        gradient: Gradient {
                            GradientStop { id: loginButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: loginButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: loginButton.down
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: loginButton.hovered
                            PropertyChanges {
                                target: loginButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: loginButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: loginButton.activeFocus
                            PropertyChanges {
                                target: loginButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: loginButton.enabled
                            PropertyChanges {
                                target: loginButtonBackground
                            }
                            PropertyChanges {
                                target: loginButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.login(usernameInput.text, passwordInput.text, "i3")
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

                Button {
                    id: powerButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("power.svg")
                        color: config.textDefault
                    }

                    background: Rectangle {
                        id: powerButtonBackground
                        gradient: Gradient {
                            GradientStop { id: powerButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: powerButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: powerButton.down
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: powerButton.hovered
                            PropertyChanges {
                                target: powerButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: powerButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: powerButton.activeFocus
                            PropertyChanges {
                                target: powerButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: powerButton.enabled
                            PropertyChanges {
                                target: powerButtonBackground
                            }
                            PropertyChanges {
                                target: powerButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.powerOff()
                    }
                }

                Button {
                    id: rebootButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("reboot.svg")
                        color: config.textDefault
                    }

                   background: Rectangle {
                        id: rebootButtonBackground
                        gradient: Gradient {
                            GradientStop { id: rebootButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: rebootButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: rebootButton.down
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: rebootButton.hovered
                            PropertyChanges {
                                target: rebootButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: rebootButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: rebootButton.activeFocus
                            PropertyChanges {
                                target: rebootButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: rebootButton.enabled
                            PropertyChanges {
                                target: rebootButtonBackground
                            }
                            PropertyChanges {
                                target: rebootButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.reboot()
                    }
                }

                Button {
                    id: sleepButton
                    width: 30
                    height: 30
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("sleep.svg")
                        color: config.textDefault
                    }

                   background: Rectangle {
                        id: sleepButtonBackground
                        gradient: Gradient {
                            GradientStop { id: sleepButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                            GradientStop { id: sleepButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                        }
                        border.color: config.buttonBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: sleepButton.down
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: sleepButton.hovered
                            PropertyChanges {
                                target: sleepButtonGradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: sleepButtonGradientStop1
                                color: config.buttonBgHovered1
                            }
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.lineeditBorderHovered
                            }
                        },
                        State {
                            name: "focused"
                            when: sleepButton.activeFocus
                            PropertyChanges {
                                target: sleepButtonBackground
                                border.color: config.lineeditBorderFocused
                            }
                        },
                        State {
                            name: "enabled"
                            when: sleepButton.enabled
                            PropertyChanges {
                                target: sleepButtonBackground
                            }
                            PropertyChanges {
                                target: sleepButtonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.suspend()
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
