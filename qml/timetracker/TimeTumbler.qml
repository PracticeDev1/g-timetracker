import QtQuick 2.0
import Qt.labs.controls 1.0
import "Util.js" as Util

Row {
    id: timeTumbler

    property date startDateCurrent
    property var startTimeCurrent: new Date()
    property date startTimeAfter
    property date startTimeBefore

    readonly property alias hours: d.hours
    readonly property alias minutes: d.minutes
    readonly property alias seconds: d.seconds

    QtObject {
        id: d

        property int hours: hoursTumbler.currentIndex + minHours
        property int minutes: minutesTumbler.currentIndex + minMinutes
        property int seconds: secondsTumbler.currentIndex + minSeconds

        property int minHours: (currentDayAfter ? startTimeAfter.getHours() + (hoursAfterFit ? 0 : 1) : 0)
        property int maxHours: (currentDayBefore ? startTimeBefore.getHours() - (hoursBeforeFit ? 0 : 1) : 23)

        property int minMinutes: (currentHourAfter ? startTimeAfter.getMinutes() + (minutesAfterFit ? 0 : 1) : 0)
        property int maxMinutes: (currentHourBefore ? startTimeBefore.getMinutes() - (minutesBeforeFit ? 0 : 1) : 59)

        property int minSeconds: (currentMinuteAfter && minutesAfterFit ? startTimeAfter.getSeconds() + 1 : 0)
        property int maxSeconds: (currentMinuteBefore && minutesBeforeFit ? startTimeBefore.getSeconds() - 1 : 59)

        property bool currentDayBefore: (startDateCurrent.getFullYear() === startTimeBefore.getFullYear()
                                         && startDateCurrent.getMonth() === startTimeBefore.getMonth()
                                         && startDateCurrent.getDate() === startTimeBefore.getDate())
        property bool currentDayAfter: (startTimeAfter.getFullYear() === startDateCurrent.getFullYear()
                                        && startTimeAfter.getMonth() === startDateCurrent.getMonth()
                                        && startTimeAfter.getDate() === startDateCurrent.getDate())
        property bool currentHourBefore: (currentDayBefore
                                          && hours === startTimeBefore.getHours())
        property bool currentHourAfter: (currentDayAfter
                                         && startTimeAfter.getHours() === hours)
        property bool currentMinuteBefore: (currentHourBefore
                                            && minutes === startTimeBefore.getMinutes())
        property bool currentMinuteAfter: (currentHourAfter
                                           && startTimeAfter.getMinutes() === minutes)

        property bool minutesBeforeFit: (startTimeBefore.getSeconds() > 0)
        property bool minutesAfterFit: (startTimeAfter.getSeconds() < 59)
        property bool hoursBeforeFit: (startTimeBefore.getMinutes() > 0
                                       || minutesBeforeFit)
        property bool hoursAfterFit: (startTimeAfter.getMinutes() < 59
                                      || minutesAfterFit)
    }

    function setHours(newHours) {
        hoursTumbler.currentIndex = newHours - d.minHours
    }

    function setMinutes(newMinutes) {
        minutesTumbler.currentIndex = newMinutes - d.minMinutes
    }

    function setSeconds(newSeconds) {
        secondsTumbler.currentIndex = newSeconds - d.minSeconds
    }

    Tumbler {
        id: hoursTumbler

        model: (d.minHours < d.maxHours) ? Util.rangeList(d.minHours, d.maxHours + 1)
                                         : [ d.minHours ]
    }

    Tumbler {
        id: minutesTumbler

        model: (d.minMinutes < d.maxMinutes) ? Util.rangeList(d.minMinutes, d.maxMinutes + 1)
                                             : [ d.minMinutes ]
    }

    Tumbler {
        id: secondsTumbler

        model: (d.minSeconds < d.maxSeconds) ? Util.rangeList(d.minSeconds, d.maxSeconds + 1)
                                             : [ d.minSeconds ]
    }

    onStartTimeCurrentChanged: {
        setHours(startTimeCurrent.getHours())
        setMinutes(startTimeCurrent.getMinutes())
        setSeconds(startTimeCurrent.getSeconds())
    }
}