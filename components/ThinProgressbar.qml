import QtQuick 2.0
import Ubuntu.Components 0.1

Item {
    property int progress

    height: units.gu(1)

    Rectangle {
        width: parent.width / 100 * progress
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        color: UbuntuColors.orange
    }

    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.bottom
        }
        visible: (progress == 0)

        text: i18n.tr("Loading...")
        color: UbuntuColors.coolGrey
    }
}
