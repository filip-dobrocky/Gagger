/*Copyrigth (C) 2014 Filip Dobrocký <filip.dobrocky@gmail.com>
This file is part of Gagger.

Gagger is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Gagger is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Gagger.  If not, see <http://www.gnu.org/licenses/>*/

import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Extras.Browser 0.1
import "../components"

Page {
    property string postId

    title: i18n.tr("Comments")
    tools: ToolbarItems {
        ToolbarButton {
            text: i18n.tr("Refresh")
            iconSource: Qt.resolvedUrl("../graphics/reload.svg")

            onTriggered: commentsView.reload()
        }
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent

        color: "white"

        UbuntuWebView {
            id: commentsView
            anchors {
                fill: parent
                leftMargin: units.gu(1)
                rightMargin: units.gu(1)
            }

            clip: true
            url: "http://comment.9gag.com/comment/list?url=http://9gag.com/gag/"
                 + postId + "&appId=a_dd8f2b7d304a10edaf6f29517ea0ca4100a43d1b&readOnly=1"
        }

        ThinProgressbar {
            id: progressBar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            opacity: 0.8

            progress: commentsView.loadProgress
            visible: commentsView.loading
        }
    }
}

