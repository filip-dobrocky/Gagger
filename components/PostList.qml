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
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../JSONListModel"

Item {
    property string section
    property string currentPage: "0"
    property string listModelUrl: "http://infinigag.eu01.aws.af.cm/" + section + "/" + currentPage

    //reload current page
    function reload() {
        jsonModel.source = ""
        jsonModel.source = listModelUrl
        jsonPaging.source = ""
        jsonPaging.source = listModelUrl
    }

    //set page to zero and reload
    function refresh() {
        currentPage = "0"
        reload()
    }

    ActivityIndicator {
        id: activityIndicator
        anchors.centerIn: parent

        running: (list.count > 0) ? false : true
    }

    ListView {
        id: list
        anchors {
            fill: parent
            topMargin: units.gu(0.5)
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)
        }
        spacing: units.gu(1)
        visible: (count > 0) ? true : false

        cacheBuffer: contentHeight
        clip: true
        model: jsonModel.model
        delegate: ListItem.Empty {
            //there's an undefined property at the end of the model.
            //haven't found another way to fix it, than using ternary operators each time it assigns a value

            width: parent.width; height: (caption != undefined) ? column.height + units.gu(1) : 0
            visible: (caption != undefined) ? true : false

            Column {
                id: column
                width: parent.width
                spacing: units.gu(1)
                anchors.margins: units.gu(1)


                Label {
                    id: captionLabel
                    width: parent.width

                    text: (caption != undefined) ? caption : ""
                    fontSize: "large"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                UbuntuShape {
                    id: imageBaseShape
                    width: image.paintedWidth
                    height: image.paintedHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    image: AnimatedImage {
                        id: image
                        width: column.width

                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: (images != undefined) ? ((list.width < units.gu(60)) ? images.normal : images.large) : ""
                    }

                    ActivityIndicator {
                        id: gifLoading
                        anchors.centerIn: parent

                        running: (testGifImage != null && image.status == Image.Ready && testGifImage.status == Image.Loading)
                                 ? true : false
                    }

                    Image {
                        //this determines if the image is a gif

                        id: testGifImage
                        visible: false
                        source: "http://d24w6bsrhbeh9d.cloudfront.net/photo/" + id + "_460sa.gif"
                        asynchronous: true

                        onStatusChanged: {
                            if (status == Image.Error) {
                                gifShape.visible = false
                                destroy()
                            } else if (status == Image.Ready) {
                                gifShape.visible = true
                                destroy()
                            }
                        }
                    }

                    UbuntuShape {
                        id: gifShape
                        height: width
                        anchors.centerIn: parent
                        visible: false

                        color: "#b0000000"

                        Label {
                            anchors.centerIn: parent

                            text: "GIF"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if (gifShape.visible) {
                                image.source = "http://d24w6bsrhbeh9d.cloudfront.net/photo/" + id + "_460sa.gif"
                                if (!image.playing || image.paused) {
                                    image.playing = true
                                    image.paused = false
                                    gifShape.opacity = 0
                                } else {
                                    image.paused = true
                                    gifShape.opacity = 1
                                }
                            } else {
                                pageStack.push(Qt.resolvedUrl("../ui/ZoomPage.qml"), {imageUrl: images.large})
                            }
                        }

                        onPressAndHold: PopupUtils.open(popoverComponent, imageBaseShape)

                    }
                }

                Row {
                    width: parent.width
                    spacing: units.gu(1)

                    UbuntuShape {
                        width: (parent.width - units.gu(1)) / 2; height: units.gu(5)

                        color: "#50000000"

                        Label {
                            anchors {
                                leftMargin: units.gu(1)
                                rightMargin:  units.gu(1)
                                verticalCenter: parent.verticalCenter
                                left: parent.left
                            }

                            text: (votes != undefined) ? i18n.tr("Score") + ": " + votes.count : ""
                            color: "#f3f3e7"
                        }
                    }

                    Button {
                        width: (parent.width - units.gu(1)) / 2; height: units.gu(5)

                        text: i18n.tr("Comments")
                        color: "#50000000"
                        iconSource: "../graphics/comments.svg"
                        iconPosition: "right"

                        onClicked: pageStack.push(Qt.resolvedUrl("../ui/CommentsPage.qml"), {postId: id})
                    }
                }

                Component {
                    id: popoverComponent

                    Popover {
                        id: popover

                        ListItem.Standard {
                            text: i18n.tr("Open post via 9gag.com")

                            onClicked: {
                                Qt.openUrlExternally("http://m.9gag.com/gag/" + id)
                                PopupUtils.close(popover)
                            }
                        }
                    }
                }
            }
        }

        footer: Item {
            width: parent.width; height: units.gu(7)

            Button {
                id: moreButton
                anchors {
                    fill: parent
                    bottomMargin: units.gu(1)
                }

                text: i18n.tr("More")

                onClicked: {
                    currentPage = jsonPaging.model.get(0).next
                    reload()
                }
            }
        }
    }

    JSONListModel {
        id: jsonModel

        source: listModelUrl
    }

    JSONListModel {
        id: jsonPaging

        source: listModelUrl
        query: "$.paging"
    }
}
