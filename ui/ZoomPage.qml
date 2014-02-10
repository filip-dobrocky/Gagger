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
    property string imageUrl
    property bool zoomed: false

    tools: ToolbarItems {
        ToolbarButton {
            text: i18n.tr("Zoom in")
            iconSource: "../graphics/zoom_in.svg"

            onTriggered: {
                image.width += rectangle.width * 0.2
                image.height += rectangle.height * 0.2
                zoomed = false
            }
        }

        ToolbarButton {
            text: i18n.tr("Zoom out")
            iconSource: "../graphics/zoom_out.svg"

            onTriggered: {
                if (image.width > rectangle.width && image.height > rectangle.height) {
                    image.width -= rectangle.width * 0.2
                    image.height -= rectangle.height * 0.2
                    zoomed = false
                }
            }
        }
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "black"

        ActivityIndicator {
            id: imageLoading
            anchors.centerIn: parent

            running: (image.status == Image.Ready) ? false : true
        }

        Flickable {
            id: imageFlickable
            anchors.fill: parent
            contentWidth: image.width; contentHeight: image.height

            Image {
                id: image
                width: rectangle.width; height: rectangle.height
                anchors.centerIn: parent

                source: imageUrl
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(8192, 8192)
                asynchronous: true
                cache: false

                MouseArea {
                    anchors.fill: parent

                    onDoubleClicked: {
                        if (zoomed == false) {
                            image.width += rectangle.width * 0.6
                            image.height += rectangle.height * 0.6
                            imageFlickable.contentX = mouseX
                            imageFlickable.contentY = mouseY
                            zoomed = true
                        } else {
                            image.width -= rectangle.width * 0.6
                            image.height -= rectangle.height * 0.6
                            zoomed = false
                        }
                    }
                }
            }
        }
    }
}
