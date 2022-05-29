import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property date datetime: new Date()
    property alias title: titleField.text
    property bool edit: false

    id: dialog

    canAccept: titleField.text.length > 0

    Column {
        width: parent.width
        spacing: Theme.paddingLarge

        DialogHeader {
            id: header
            title: edit ?
                       //% "Edit event"
                       qsTrId("id-edit-event") :
                       //% "Add event"
                       qsTrId("id-add-event")
            acceptText: edit ?
                            //% "Save"
                            qsTrId("id-save") :
                            //% "Add"
                            qsTrId("id-add")
        }

        TextField {
            id: titleField
            width: parent.width

            //% "Title"
            label: qsTrId("id-title")
            //% "Enter title"
            placeholderText: qsTrId("id-title-placeholder")

            focus: true
        }

        DatePicker {
            id: datePicker
            x: Theme.horizontalPageMargin
            width: parent.width - 2*x
            daysVisible: true
            monthYearVisible: true
            weeksVisible: true
            date: datetime

        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            datetime = datePicker.date
        }
    }
}
