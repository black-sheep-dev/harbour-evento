import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import Nemo.Configuration 1.0

import org.nubecula.harbour.evento 1.0

import "pages"

ApplicationWindow {

    function save() {
        if (!Events.save()) {
            //% "Failed to save events"
            notification.show(qsTrId("id-failed-to-save"))
        }
    }

    function load() {
        if (!Events.load()) {
            //% "Failed to load events"
            notification.show(qsTrId("id-failed-to-load"))
        }
    }

    function addEvent() {
        __silica_applicationwindow_instance.activate()
        var dialog = pageStack.push(Qt.resolvedUrl("dialogs/EditEventDialog.qml"), {
                                        edit: false
                                    })

        dialog.accepted.connect(function() {
            Events.addEvent(dialog.title, dialog.datetime)
            save()
        })
    }

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-evento"
        synchronous: true

        property bool coverAutoSwitch: false
        property int coverSwitchInterval: 5000
        property int sortOrder: Qt.AscendingOrder
        property int sortRole: EventsModel.TitleRole

        onSortOrderChanged: sortFilterModel.setSortOrder(sortOrder)
        onSortRoleChanged: sortFilterModel.sortRole = sortRole
    }

    Notification {
        function show(message) {
            replacesId = 0
            previewSummary = ""
            previewBody = message
            icon = "/usr/share/icons/hicolor/86x86/apps/harbour-evento.png"
            publish()
        }

        id: notification
        appName: "Evento"
        expireTimeout: 3000
    }

    SortFilterModel {
        id: sortFilterModel
        sourceModel: Events

        Component.onCompleted: setSortOrder(settings.sortOrder)
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
