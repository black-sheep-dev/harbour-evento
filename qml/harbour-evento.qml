import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0

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

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
