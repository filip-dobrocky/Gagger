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

Page {
    id: aboutPage

    title: i18n.tr("About")
    
    property string version: "0.1"

    Column {
        anchors {
            fill: parent
            margins: units.gu(1)
        }

        spacing: units.gu(1)

        Label {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Gagger"
            fontSize: "large"
        }

        UbuntuShape {
            width: units.gu(10); height: units.gu(10)
            anchors.horizontalCenter: parent.horizontalCenter

            radius: "medium"
            image: Image {
                source: Qt.resolvedUrl("../graphics/Gagger.png")
            }
        }

        Label {
            width: parent.width

            linkColor: UbuntuColors.orange
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "<b>Version:</b> " + version + "<br><br>
Gagger is an <b>unofficial</b> app for browsing <a href=\"http://9gag.com/\">9gag.com</a>.
 It uses <a href=\"https://github.com/k3min/infinigag\">InfiniGAG API</a> and <a href=\"https://github.com/kromain/qml-utils\">JSONListModel</a>."


            onLinkActivated: Qt.openUrlExternally(link)
        }

        Label {
            width: parent.width

            linkColor: UbuntuColors.orange
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "<b>Author:</b> Filip Dobrocký<br>
<b>Contact:</b> <a href=\"https://plus.google.com/u/0/106056788722129106018/posts\">Filip Dobrocký (Google Plus)</a><br>
<b>License:</b> <a href=\"http://www.gnu.org/licenses/gpl.txt\">GNU GPL v3</a><br>
<b>Source code:</b> <a href=\"https://github.com/filip-dobrocky/Gagger\">GitHub</a>"

            onLinkActivated: Qt.openUrlExternally(link)
        }

        Label {
            width: parent.width

            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: "<b>Copyright (C) 2014 Filip Dobrocký &lt;filip.dobrocky@gmail.com&gt;</b>"
        }
    }
}
