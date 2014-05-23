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
    title: i18n.tr("Help")
    Flickable {
        anchors {
            fill: parent
            margins: units.gu(1)
        }
        contentHeight: helpLabel.height
        flickableDirection: Flickable.VerticalFlick

        Label {
            id: helpLabel
            width: parent.width

            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: "<b>Playing GIF animations</b><br>
If the picture is loaded and there's still a loading icon visible, it means the app is checking if the image is a GIF or not.
When there's a GIF icon is visible, it means you can load and play the GIF by clicking on the image. You can pause playing GIF animations
 by clicking on them.<br><br>
<b>Zooming images</b><br>
You can open an image (that isn't a GIF) in full size by clicking on it. You can zoom using the toolbar buttons or by double-clicking on the image.
The 'pinch to zoom' feature is yet to be implemented.<br><br>
<b>Refreshing</b><br>
You can click 'Refresh' in the toolbar to refresh either posts, or comments.<br><br>
<b>Opening posts via 9gag</b><br>
This app does not support voting, commenting or uploading. So if you want to do any of these things, you'll have to long-press the image you want to open
 and click 'Open post via 9gag.com'."
        }
    }
}
