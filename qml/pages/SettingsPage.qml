import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width:parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //% "Settings"
                title: qsTrId("id-settings")
            }

            SectionHeader{
                //% "Cover"
                text: qsTrId("id-cover")
            }

            TextSwitch {
                id: coverAutoSwitch
                //% "Auto switch"
                text: qsTrId("id-cover-auto-switch")
                //% "Turn on automatic switch between events on cover page in a defined interval"
                description: qsTrId("id-cover-auto-switch-desc")

                Component.onCompleted: checked = settings.coverAutoSwitch
            }

            TextField {
                id: coverSwitchInterval
                visible: coverAutoSwitch.checked
                text: settings.coverSwitchInterval
                //% "Interval (msec)"
                label: qsTrId("id-cover-switch-interval-title")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 1000 }
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }
        }
    }

    onStatusChanged: {
        if (status !== PageStatus.Deactivating) return
        settings.coverAutoSwitch = coverAutoSwitch.checked
        settings.coverSwitchInterval =  coverSwitchInterval.text
    }
}
