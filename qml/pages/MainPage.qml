import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.evento 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    SilicaListView {
        PullDownMenu {
            MenuItem {
                //% "About"
                text: qsTrId("id-about")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                //% "Settings"
                text: qsTrId("id-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                //% "Sorting"
                text: qsTrId("id-sorting")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/SortingDialog.qml"))
                }
            }
            MenuItem {
                //% "Add"
                text: qsTrId("id-add")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/EditEventDialog.qml"), {
                                                    edit: false
                                                })

                    dialog.accepted.connect(function() {
                        Events.addEvent(dialog.title, dialog.datetime, dialog.repeat)
                        save()
                        sortFilterModel.sortModel()
                    })
                }
            }
        }

        id: listView

        anchors.fill: parent
        header: PageHeader {
            //% "Eventlist"
            title: qsTrId("id-main-title")
        }
        model: sortFilterModel

        delegate: ListItem {
            id: delegate

            menu: ContextMenu {
                MenuItem {
                    //% "Delete"
                    text: qsTrId("id-delete")
                    onClicked: delegate.remorseAction(qsTrId("Deleting event"), function() {
                        Events.removeEvent(model.id)
                        save()
                        sortFilterModel.sortModel()
                    })
                }
                MenuItem {
                    //% "Edit"
                    text: qsTrId("id-edit")

                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/EditEventDialog.qml"), {
                                                        edit: true,
                                                        title: model.title,
                                                        datetime: model.date,
                                                        repeat: model.repeat
                                                    })

                        dialog.accepted.connect(function() {
                            Events.updateEvent(model.id, dialog.title, dialog.datetime, dialog.repeat)
                            Events.refresh()
                            save()
                        })
                    }
                }
            }

            contentHeight: contentColumn.height + topSeparator.height + 2*Theme.paddingMedium

            Separator {
                id: topSeparator
                visible: index > 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                color: Theme.primaryColor
            }

            Column {              
                id: contentColumn
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x

                spacing: Theme.paddingMedium

                Label {
                    text: model.title
                    wrapMode: Text.Wrap
                    color: delegate.highlighted ? Theme.secondaryHighlightColor : Theme.highlightColor
                }

                Label {
                    text: model.date.toLocaleDateString(Qt.locale())
                    wrapMode: Text.Wrap
                    color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                }

                Item {
                    visible: model.repeat > 0
                    width: repeatIcon.width + repeatLabel.width + Theme.paddingMedium
                    height: repeatLabel.height

                    Icon {
                        id: repeatIcon
                        anchors.verticalCenter: parent.verticalCenter
                        source: "image://theme/icon-s-retweet"
                    }
                    Label {
                        id: repeatLabel
                        anchors {
                            left: repeatIcon.right
                            leftMargin: Theme.paddingMedium
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        text: {
                            switch (model.repeat) {
                            case EventsModel.RepeatWeekly:
                                //% "weekly"
                                return qsTrId("id-weekly")

                            case EventsModel.RepeatMonthly:
                                //% "monthly"
                                return qsTrId("id-monthly")

                            case EventsModel.RepeatYearly:
                                //% "weekly"
                                return qsTrId("id-yearly")

                            default:
                                return ""
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: daysLabel.height + 2*Theme.paddingSmall

                    Label {
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        text: model.remaining > 0 ?
                                  //% "Days until"
                                  qsTrId("id-days-until") :
                                  //% "Days since"
                                  qsTrId("id-day-since")
                    }

                    Label {
                        id: daysLabel
                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraLarge
                        font.bold: true
                        text: Math.abs(model.remaining) + " "
                            //: "Unit of days"
                            //% "d"
                            + qsTrId("id-days-unit")
                    }
                }
            }
        }
        VerticalScrollDecorator {}

        ViewPlaceholder {
            enabled: listView.count == 0
            //% "No events available"
            text: qsTrId("id-view-placeholder-text")
            //% "Pull down to add new event"
            hintText: qsTrId("id-view-placeholder-hint")
        }
    }

    Component.onCompleted: {
        load()
        sortFilterModel.sortModel()
    }

    onVisibleChanged: {
        Events.refresh()
        sortFilterModel.sortModel()
    }
}
