
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.XmlListModel 2.0
import QtWebView 1.0
//import QtWebKit 3.0

ApplicationWindow {
    title: qsTr("xRSS")
    id: mainWindow
    width: 540
    height: 960
    visible: true
    property string url: ""

    XmlListModel {
        id: xmlModel
        source: textInput.text
        query: "/rss/channel/item"

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "pubDate"; query: "pubDate/string()" }
        XmlRole { name: "description"; query: "description/string()" }
        XmlRole { name: "link"; query: "link/string()" }
    }

    TextInput {
            id: textInput;
            width: mainWindow.width
            height: 50
            focus: false
            selectByMouse: true
            font.pointSize: 20;
            color: "gray";

            anchors {
                top: parent.top;
                topMargin: 5;
                left: parent.left;
                leftMargin: 5;
                right: parent.right;
                rightMargin: 150;
            }
            text: "enter initial url"
    }

    Rectangle {
        id: rectangle
        width: 150
        height: textInput.height
        color: "gray"
        border.color: "black"
        border.width: 5
        radius: 10
        anchors {
            top: parent.top;
            topMargin: 5;
            left: textInput.right;
            leftMargin: 5;
            right: parent.right;
            rightMargin: 5;
        }

        Button {
            id: button
            anchors.fill: parent
            text: "Reload"
            onPressedChanged: xmlModel.reload()
        }
    }

    ListView {
        id: news
        anchors {
            top: textInput.bottom;
            left: parent.left;
            leftMargin: 5;
            right: parent.right;
            rightMargin: 5;
            bottom: parent.bottom
        }
        spacing: 15
        model: xmlModel
        delegate: Column {
            width: parent.width

            Text {
                color: "steelblue"
                text: title
                textFormat: Text.StyledText
                width: parent.width
                font.pixelSize: 25
                wrapMode: Text.WordWrap
                MouseArea {
                    anchors.fill:parent
                    onClicked: {

                        Qt.openUrlExternally(link);
                        
                        // if opening within this app
                        /*console.log(link)
                        url = link
                        webView.url = link
                        webView.update()

                        scrollViewWebView.visible = true
                        scrollViewWebView.x = 0*/
                    }
                }
            }

            Text {
                text: pubDate
                width: parent.width
                font.pixelSize: 10
                font.italic: true
                wrapMode: Text.WordWrap
            }

            Text {
                text: description
                width: parent.width
                font.pixelSize: 20
                wrapMode: Text.WordWrap
            }

        }
    }

    ScrollView {
        id: scrollViewWebView
        x: mainWindow.width
        y: mainWindow.height/4
        width: mainWindow.width
        height: mainWindow.height*3/4
        visible: false
        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 1500
            }
        }

        WebView {
            id: webView
            url: url
            anchors.fill: parent
        }
    }

    Rectangle {
        focus: true // important - otherwise we'll get no key events

        Keys.onReleased: {
            if (event.key == Qt.Key_Back) {
                console.log("Back button captured")
                scrollViewWebView.x = mainWindow.width
                scrollViewWebView.visible = false
                webView.stop()
                event.accepted = true
            }
        }
    }
}
