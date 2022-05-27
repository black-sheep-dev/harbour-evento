import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.evento 1.0

CoverBackground {
    property int currentIndex: 0

    function decrement() {
        if (currentIndex === 0) {
            currentIndex = Events.rowCount() - 1
        } else {
            currentIndex--
        }
    }

    function increment() {
        if (currentIndex === (Events.rowCount() - 1)) {
            currentIndex = 0
        } else {
            currentIndex++
        }
    }

    id: coverBackground

    Connections {
        target: Events
        onChanged: currentIndex = 0
    }

    Label {
        id: titleLabel
        anchors {
            top: parent.top
            topMargin: Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }
        font.pixelSize: Theme.fontSizeLarge
        //% "Evento"
        text: qsTrId("id-app-name")
    }
    Separator {
        anchors {
            top: titleLabel.bottom
            topMargin: Theme.paddingMedium
        }
        x: Theme.horizontalPageMargin
        width: parent.width - 2*x
        color: Theme.primaryColor
    }

    Row {
        anchors {
            top: titleLabel.bottom
            topMargin: Theme.paddingLarge
            bottom: coverAction.top
            bottomMargin: Theme.paddingLarge
        }

        x: currentIndex * parent.width * -1
        height: parent.height - titleLabel.height - 256

        Behavior on x {
            NumberAnimation { duration: currentIndex === (Events.rowCount() - 1) ? 0 : 250 }
        }

        Repeater {
            model: sortFilterModel

            Item {
                width: coverBackground.width
                height: parent.height

                Label {
                    x: Theme.horizontalPageMargin
                    width: parent.width - 2*x
                    text: model.title
                    font.bold: true
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }

                    //: "Unit of days"
                    //% "d"
                    text: (model.remaining > 0 ? model.remaining : 0)+ " " + qsTrId("id-days-unit")
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.bold: true
                }
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: decrement()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: addEvent()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: increment()
        }


    }

    onVisibleChanged: Events.refresh()
}
