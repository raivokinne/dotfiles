import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower
import QtQuick

PanelWindow {
    id: bar

    property int notchWidth: 250
    property int pillPadding: 15
    property int workspaceCount: 10

    QtObject {
        id: colors
        readonly property color bg: "#000000"
        readonly property color fg: "#F4F4F5"
        readonly property color comment: "#777783"

        readonly property color gray1: "#121215"
        readonly property color gray2: "#1b1b20"
        readonly property color gray3: "#2c2c34"
        readonly property color gray4: "#43434d"

        readonly property color accent: "#FFAD66"
        readonly property color green: "#6EFF8A"
        readonly property color warn: "#FF5C70"
    }

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 5
        left: 5
        right: 5
    }

    implicitHeight: 34
    color: "transparent"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    component Pill: Rectangle {
        default property alias content: row.data

        implicitHeight: bar.implicitHeight
        implicitWidth: row.implicitWidth + bar.pillPadding * 2
        radius: height / 2
        color: colors.bg
        border.width: 1
        border.color: colors.gray3

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 10
        }
    }

    Pill {
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: bar.notchWidth / 2
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: bar.workspaceCount

            Rectangle {
                id: dot

                required property int index
                property int wsId: index + 1
                property bool focused: Hyprland.focusedWorkspace?.id === wsId
                property bool occupied: Hyprland.workspaces.values.some(w => w.id === wsId)

                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 8
                implicitWidth: focused ? 22 : 8
                radius: height / 2
                color: focused ? colors.accent : occupied ? colors.comment : colors.gray4

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    onClicked: Hyprland.dispatch("workspace " + dot.wsId)
                }
            }
        }
    }

    Pill {
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: bar.notchWidth / 2
        anchors.verticalCenter: parent.verticalCenter

        Row {
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: Qt.formatDateTime(clock.date, "ddd d MMM")
                color: colors.comment
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: Qt.formatDateTime(clock.date, "HH:mm")
                color: colors.fg
                font.pixelSize: 12
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            width: 1
            height: 12
            color: colors.gray4
            anchors.verticalCenter: parent.verticalCenter
            visible: battery.visible
        }

        Row {
            id: battery
            spacing: 6
            anchors.verticalCenter: parent.verticalCenter
            visible: UPower.displayDevice.isPresent

            property real level: UPower.displayDevice.percentage   // 0.0 to 1.0
            property bool charging: UPower.displayDevice.state === UPowerDeviceState.Charging || UPower.displayDevice.state === UPowerDeviceState.FullyCharged
            property color tint: charging ? colors.green : level <= 0.2 ? colors.warn : colors.accent

            Item {
                width: 22
                height: 11
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    id: body
                    width: 20
                    height: 11
                    radius: 3
                    color: "transparent"
                    border.width: 1
                    border.color: colors.comment

                    Rectangle {
                        x: 2
                        y: 2
                        height: parent.height - 4
                        width: Math.max(2, (parent.width - 4) * battery.level)
                        radius: 1.5
                        color: battery.tint

                        Behavior on width {
                            NumberAnimation {
                                duration: 200
                            }
                        }
                    }
                }

                Rectangle {
                    x: 20
                    anchors.verticalCenter: body.verticalCenter
                    width: 2
                    height: 5
                    radius: 1
                    color: colors.comment
                }
            }

            Text {
                text: Math.round(battery.level * 100) + "%"
                color: battery.level <= 0.2 && !battery.charging ? colors.warn : colors.fg
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
