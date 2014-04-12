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
    property Flickable flickable: list
    property string section
    property string currentPage: "0"
    property string pageUrl: "http://infinigag.eu01.aws.af.cm/" + section + "/" + currentPage

    //reload current page
    function reload() {
        jsonModel.source = jsonPaging.source = ""
        jsonModel.source = jsonPaging.source = pageUrl
    }

    //set page to zero and reload
    function refresh() {
        currentPage = "0"
        reload()
    }

    ActivityIndicator {
        id: activityIndicator
        anchors.centerIn: parent

        running: !jsonModel.loaded
    }

    ListView {
        id: list
        anchors {
            fill: parent
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)
        }
        spacing: units.gu(1)
        visible: jsonModel.loaded

        cacheBuffer: contentHeight
        clip: true
        model: jsonModel.model
        delegate: ListItem.Empty {
            //there's an undefined property at the end of the model.
            //haven't found a better way to fix it than using ternary operators each time it assigns a value

            width: parent.width; height: (caption != undefined) ? column.height + units.gu(1) : 0
            visible: caption != undefined

            Column {
                id: column
                width: parent.width
                spacing: units.gu(1)

                Label {
                    id: captionLabel
                    width: parent.width

                    text: (caption != undefined) ? caption : ""
                    fontSize: "large"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                ProgressBar {
                    width: parent.width
                    visible: imageBaseShape.image.status == Image.Loading

                    value: imageBaseShape.image.progress
                }

                UbuntuShape {
                    id: imageBaseShape
                    width: image.paintedWidth; height: image.paintedHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: imageBaseShape.image.status != Image.Loading

                    image: Image {
                        id: jpgImage
                        width: column.width

                        source: (images != undefined) ? ((list.width < units.gu(60)) ? images.normal : images.large) : ""
                        fillMode: Image.PreserveAspectFit
                        sourceSize: Qt.size(8192, 8192)
                        asynchronous: true
                    }

                    property int gifVersion: 2
                    property string gifUrl: "http://d24w6bsrhbeh9d.cloudfront.net/photo/" + id + "_460sa_v" + gifVersion + ".gif"

                    Component.onCompleted: {
                        var checkGif = new XMLHttpRequest;
                        checkGif.open("GET", gifUrl)
                        checkGif.onreadystatechange = function() {
                            if (checkGif.readyState == XMLHttpRequest.DONE && checkGif.status == 200) {
                                gifShape.visible = true
                                gifLoading.running = false
                            }
                            else if (checkGif.readyState == XMLHttpRequest.DONE && checkGif.status == 404) {
                                if (gifVersion > 0) {
                                    gifVersion--
                                    checkGif.open("GET", gifUrl)
                                    checkGif.send()
                                }

                                gifShape.visible = gifLoading.running = false
                            } else {
                                gifShape.visible = false
                                gifLoading.running = true
                            }
                        }
                        checkGif.send()
                    }

                    ActivityIndicator {
                        id: gifLoading
                        anchors.centerIn: parent

                        running: false
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
                                if (imageBaseShape.image == jpgImage) {
                                    var gifImage = Qt.createComponent("GifImage.qml")
                                    imageBaseShape.image = gifImage.createObject(parent, {"width": column.width,
                                                                                     "source": imageBaseShape.gifUrl})
                                    gifShape.opacity = 0
                                } else if (imageBaseShape.image.paused) {
                                    imageBaseShape.image.paused = false
                                    gifShape.opacity = 0
                                } else {
                                    imageBaseShape.image.paused = true
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

                    ActionSelectionPopover {
                        id: popover

                        actions: Action {
                            text: i18n.tr("Open post via 9gag.com")
                            onTriggered: Qt.openUrlExternally("http://m.9gag.com/gag/" + id)
                        }
                    }
                }
            }
        }

        header: Item {
            width: parent.width; height: units.gu(1)
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

        source: pageUrl
        onErrorChanged: if (error) PopupUtils.open(errorDialogComponent)
    }

    JSONListModel {
        id: jsonPaging

        source: pageUrl
        query: "$.paging"
    }

    Component {
        id: errorDialogComponent

        Dialog {
            id: errorDialog

            title: i18n.tr("Error")
            text: i18n.tr("There was an error loading the page.")

            Button {
                text: i18n.tr("Reload")
                onClicked: {
                    reload()
                    PopupUtils.close(errorDialog)
                }
            }
        }
    }
}
