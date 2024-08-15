import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080

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

            TextField {
                id: usernameInput
                echoMode: TextInput.Normal
                placeholderText: "username"
                placeholderTextColor: config.textPlaceholder
                renderType: Text.NativeRendering
                horizontalAlignment: Text.AlignHLeft
                width: 200
                font {
                    family: config.Font
                    pixelSize: config.FontSize
                    bold: false
                }

                background: Rectangle {
                    color: config.lineeditBgNormal
                    border.color: config.lineeditBorderNormal
                    border.width: 1
                    radius: 2
                    opacity: config.opacityDefault
                }
            }

            Row {
                spacing: 8

                TextField {
                    id: passwordInput
                    echoMode: TextInput.Password
                    placeholderText: "password"
                    placeholderTextColor: config.textPlaceholder
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignHLeft
                    width: 162
                    font {
                        family: config.Font
                        pixelSize: config.FontSize
                        bold: false
                    }
                    
                    background: Rectangle {
                        color: config.lineeditBgNormal
                        border.color: config.lineeditBorderNormal
                        border.width: 1
                        radius: 2
                        opacity: config.opacityDefault
                    }
                }

                Button {
                    id: loginButton
                    width: 30
                    height: 30
                    enabled: usernameInput != "" && passwordInput != "" ? true : false
                    hoverEnabled: true
                    icon {
                        source: Qt.resolvedUrl("../Assets/login.svg")
                        color: config.textDefault
                    }

                    background: Rectangle {
                        id: buttonBackground
                        gradient: Gradient {
                            GradientStop { id: gradientStop0; position: 0.0; color: config.buttonBgNormal }
                        GradientStop { id: gradientStop1; position: 1.0; color: config.buttonBgNormal }
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
                                target: buttonBackground
                                border.color: config.buttonBorderPressed
                                opacity: 1
                            }
                            PropertyChanges {
                                target: gradientStop0
                                color: config.buttonBgPressed
                            }
                            PropertyChanges {
                                target: gradientStop1
                                color: config.buttonBgPressed
                            }
                        },
                        State {
                            name: "hovered"
                            when: loginButton.hovered
                            PropertyChanges {
                                target: buttonBackground
                                border.color: config.buttonBorderHovered
                                opacity: 1
                            }
                            PropertyChanges {
                                target: gradientStop0
                                color: config.buttonBgHovered0
                            }
                            PropertyChanges {
                                target: gradientStop1
                                color: config.buttonBgHovered1
                            }
                        },
                        State {
                            name: "enabled"
                            when: loginButton.enabled
                            PropertyChanges {
                                target: buttonBackground
                            }
                            PropertyChanges {
                                target: buttonBackground
                            }
                        }
                    ]

                    onClicked: {
                        sddm.login(user, password)
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
