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

    Timer {
        interval: settings.coverSwitchInterval
        repeat: true
        running: settings.coverAutoSwitch && Events.rowCount() > 1

        onTriggered: increment()
    }

    Image {
        anchors.fill: parent
        height: sourceSize.height * width / sourceSize.width
        fillMode: Image.PreserveAspectCrop
        smooth: true
        source: "/usr/share/harbour-evento/images/cover-background.svg"
        opacity: 0.1
    }

    Row {
        anchors {
            top: parent.top
            topMargin: Theme.paddingLarge 
        }

        x: currentIndex * parent.width * -1
        height: coverBackground.height - 256

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
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }

                Label {
                    anchors {
                        bottom: daysCounter.top
                        bottomMargin: Theme.paddingMedium
                        horizontalCenter: parent.horizontalCenter
                    }
                    font.pixelSize: Theme.fontSizeTiny
                    text: model.remaining > 0 ?
                              //% "Days until"
                              qsTrId("id-days-until") :
                              //% "Days since"
                              qsTrId("id-day-since")
                }

                Label {
                    id: daysCounter
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }

                    //: "Unit of days"
                    //% "d"
                    text: Math.abs(model.remaining) + " " + qsTrId("id-days-unit")
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
