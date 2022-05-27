import QtQuick 2.0
import Sailfish.Silica 1.0

import org.nubecula.harbour.evento 1.0

Dialog {
    id: dialog

    Column {
        width: parent.width
        spacing: Theme.paddingLarge

        DialogHeader {
            id: header
            //% "Change sorting"
            title: qsTrId("id-sort-dialog-title")
            //% "Sort"
            acceptText: qsTrId("id-sort")
        }

        ComboBox {
            id: sortRoleCombo
            width: parent.width
            //% "Sort by"
            label: qsTrId("id-sort-by")

            menu: ContextMenu {
                MenuItem {
                    //% "Title"
                    text: qsTrId("id-title")
                }
                MenuItem {
                    //% "Days left"
                    text: qsTrId("id-days-left")
                }
                MenuItem {
                    //% "Date"
                    text: qsTrId("id-date")
                }
                MenuItem {
                    //% "Date added"
                    text: qsTrId("id-date-added")
                }
            }

            Component.onCompleted: {
                switch (settings.sortRole) {
                case EventsModel.TitleRole:
                    currentIndex = 0
                    break

                case EventsModel.RemainingRole:
                    currentIndex = 1
                    break

                case EventsModel.DateRole:
                    currentIndex = 2
                    break

                case EventsModel.CreatedRole:
                    currentIndex = 3
                    break

                default:
                    currentIndex = 0
                    break
                }
            }
        }

        ComboBox {
            id: sortOrderCombo
            width: parent.width
            //% "Sort order"
            label: qsTrId("id-sort-order")

            menu: ContextMenu {
                MenuItem {
                    //% "Ascending"
                    text: qsTrId("id-ascending")
                }
                MenuItem {
                    //% "Descending"
                    text: qsTrId("id-descending")
                }
            }

            Component.onCompleted: currentIndex = settings.sortOrder
        }
    }

    onDone: {
        if (result != DialogResult.Accepted) return

        settings.sortOrder = sortOrderCombo.currentIndex

        switch (sortRoleCombo.currentIndex) {
        case 0:
            settings.sortRole = EventsModel.TitleRole
            break

        case 1:
            settings.sortRole = EventsModel.RemainingRole
            break

        case 2:
            settings.sortRole = EventsModel.DateRole
            break

        case 3:
            settings.sortRole = EventsModel.CreatedRole
            break

        default:
            break
        }
    }
}

