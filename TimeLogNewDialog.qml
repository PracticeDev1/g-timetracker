import QtQuick 2.4
import QtQuick.Dialogs 1.2

Dialog {
    id: newDialog

    property alias startTimeAfter: delegateEditor.startTimeAfter
    property alias startTimeBefore: delegateEditor.startTimeBefore
    property int indexBefore

    function openDialog(indexBefore, timeAfter, timeBefore) {
        newDialog.indexBefore = indexBefore
        newDialog.startTimeAfter = timeAfter
        newDialog.startTimeBefore = timeBefore
        open()
    }

    signal dataAccepted(var newData)

    width: delegateEditor.implicitWidth
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    title: "Add new entry"

    TimeLogEntryEditor {
        id: delegateEditor
    }

    onVisibleChanged: {
        if (!visible) {
            return
        }

        delegateEditor.category = ""
        delegateEditor.startTime = startTimeBefore
        delegateEditor.comment = ""
    }

    onAccepted: {
        newDialog.dataAccepted(TimeLog.createTimeLogData(delegateEditor.startTime, 0,
                                                         delegateEditor.category,
                                                         delegateEditor.comment))
    }
}