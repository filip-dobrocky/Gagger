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
import "../JSONListModel"

Item {
    property string section
    property string currentPage: "0"

    //reload current page
    function reload() {
        jsonModel.source = ""
        jsonModel.source = "http://infinigag.eu01.aws.af.cm/" + section + "/" + currentPage
    }

    //set page to zero and reload
    function refresh() {
        currentPage = "0"
        reload()
    }

    ActivityIndicator {
        id: activityIndicator
        anchors.centerIn: parent

        running: true
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
        visible: false

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
                    width: image.paintedWidth
                    height: image.paintedHeight
                    anchors.horizontalCenter: parent.horizontalCenter

                    image: AnimatedImage {
                        id: image
                        width: column.width

                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: (images != undefined) ? images.normal : ""

                        onStatusChanged: {
                            if (testGifImage != null && status == Image.Ready && testGifImage.status == Image.Loading) {
                                gifLoading.running = true
                            }
                        }
                    }

                    ActivityIndicator {
                        id: gifLoading
                        anchors.centerIn: parent

                        running: false
                    }

                    Image {
                        //this determines if the image is a gif

                        id: testGifImage
                        visible: false
                        source: "http://d24w6bsrhbeh9d.cloudfront.net/photo/" + id + "_460sa.gif"
                        asynchronous: true

                        onStatusChanged: {
                            if (status == Image.Error) {
                                gifLoading.running = false
                                gifShape.visible = false
                                destroy()
                            } else if(status == Image.Loading && image.status == Image.Ready) {
                                gifLoading.running = true
                            } else if (status == Image.Ready) {
                                gifLoading.running = false
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

        onCountChanged: {
            if (count > 0) {
                visible = true
                activityIndicator.running = false
            } else {
                visible = false
                activityIndicator.running = true
            }
        }

    }

    Scrollbar {
        flickableItem: list
        align: Qt.AlignTrailing
    }

    JSONListModel {
        id: jsonModel

        source: "http://infinigag.eu01.aws.af.cm/" + section + "/" + currentPage
    }

    JSONListModel {
        id: jsonPaging

        source: "http://infinigag.eu01.aws.af.cm/" + section + "/" + currentPage
        query: "$.paging"
    }
}
