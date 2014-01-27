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
import "../components"


Tab {
    title: i18n.tr("Hot")

    page: Page {
        tools: ToolbarItems {

            ToolbarButton {
                text: i18n.tr("About")
                iconSource: Qt.resolvedUrl("../graphics/help.svg")
                onTriggered: pageStack.push(Qt.resolvedUrl("../ui/AboutPage.qml"))
            }

            ToolbarButton {
                text: i18n.tr("Refresh")
                iconSource: Qt.resolvedUrl("../graphics/reload.svg")
                onTriggered: postList.refresh()
            }
        }

        flickable: postList.children[1]

        PostList {
            id: postList
            anchors.fill: parent

            section: "hot"
        }
    }
}
