/*
 * Project: MP3 Player
 * Description: This project is a MP3 player application developed using Qt 6.7.2.
 * It features a sleek user interface, robust playback controls, and seamless audio performance.
 * Author: Emir Yorgun
 * Date: 18.10.2024
 *
 * This project demonstrates the practical use of Qt for multimedia applications,
 * offering a solid foundation for future enhancements. Users can easily access songs from any folder,
 * view album covers, and enjoy a seamless listening experience with shuffle and replay options.
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.platform

Window {
    id: root

    width: 1280
    height: 720
    visible: true
    title: qsTr("Music Player")

    color: "#c4c4c4"

    property bool isPlaying: false
    property bool manualSongChange: false
    property bool isLooping: false
    property bool isShuffling: false

    property var playedIndices: []
    property var musicNameFilters: ["All audio files (*.mp3)"]

    property string folderpath: ""
    property string selectedMusicName: ""
    property string artistName: "Unknown Artist"
    property string songName: "Unknown Song"


    function getRandomIndex() {
        if (musicModel && musicModel.count > 0) {
            if (playedIndices.length === musicModel.count) {
                playedIndices = []
            }
            var newIndex
            do {
                newIndex = Math.floor(Math.random() * musicModel.count)
            } while (playedIndices.includes(newIndex) && playedIndices.length < musicModel.count)
            playedIndices.push(newIndex)
            return newIndex
        } else {
            console.error("musicModel is undefined or has no elements")
            return -1
        }
    }


    Connections {
        target: FileManageBackend
    }

    Column {
        x: 230
        y: 80

        anchors.verticalCenter: parent.verticalCenter

        spacing: 20

        Rectangle {
            id: coverRect

            width: 300
            height: 300

            anchors.horizontalCenter: parent.horizontalCenter

            color: "#a1a1a1"
            radius: 10

            border.color: "black"
            border.width: 3

            AnimatedImage {
                id: albumCoverGif

                width: 285
                height: 285

                anchors.centerIn: parent

                source: FileManageBackend.coverImagePath !== "" ? FileManageBackend.coverImagePath : "ui/assets/defaultCover.gif"
            }
        }

        Rectangle {
            id: infoBox

            width: 290
            height: 100

            anchors.horizontalCenter: parent.horizontalCenter

            color: "#c4c4c4"

            Column {
                spacing: 10

                width: infoBox.width

                Text {
                    id: songNameText

                    width: infoBox.width
                    height: implicitHeight

                    horizontalAlignment: Text.AlignHCenter

                    text: FileManageBackend.title
                    color: "Black"
                    font.pointSize: 25
                    font.bold: true
                    wrapMode: Text.WordWrap

                }

                Text {
                    id: artistNameText

                    y: songNameText.height
                    width: infoBox.width

                    horizontalAlignment: Text.AlignHCenter

                    text: FileManageBackend.artist
                    color: "Black"
                    font.pointSize: 15
                    wrapMode: Text.WordWrap
                }
            }
        }

        GridLayout {
            id: gridButtons

            rows: 2
            columns: 3
            rowSpacing: 5

            Slider {
                id: musicSlider

                Text {
                    id: musicTimeText

                    x: musicSlider.leftPadding
                    y: musicSlider.topPadding + musicSlider.availableHeight / 2 - height / 2 - 12

                    Layout.minimumHeight: 18
                    Layout.minimumWidth: 50
                    horizontalAlignment: Text.AlignRight

                    text: {
                        var m = Math.floor(playMusic.position / 60000)
                        var ms = (playMusic.position / 1000 - m * 60).toFixed(1)
                        return `${m}:${ms.padStart(4, 0)}`
                    }
                }

                background: Rectangle {
                    x: musicSlider.leftPadding
                    y: musicSlider.topPadding + musicSlider.availableHeight / 2 - height / 2

                    implicitHeight: 4
                    implicitWidth: 200

                    width: musicSlider.availableWidth
                    height: implicitHeight

                    color: "#bababa"

                    radius: 2

                    Rectangle {
                        width: musicSlider.visualPosition * parent.width
                        height: parent.height

                        color: "#000000"

                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: musicSlider.leftPadding + musicSlider.visualPosition * (musicSlider.availableWidth - width)
                    y: musicSlider.topPadding + musicSlider.availableHeight / 2 - height / 2

                    implicitHeight: 10
                    implicitWidth: 10

                    color: musicSlider.pressed ? "CDC2A5" : "#7a7361"

                    radius: 10
                }

                enabled: playMusic.seekable
                to: 1.0
                value: playMusic.position / playMusic.duration
                onMoved: playMusic.setPosition(value * playMusic.duration)

                Layout.columnSpan: 3
                Layout.fillWidth: true
            }

            Row {
                spacing: 5

                Image {
                    id: previousButton

                    width: 100
                    height: 100

                    source: "ui/assets/previousSong.png"

                    MouseArea{
                        id: prevMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        onClicked: {
                            if (listMusics.currentIndex > 0) {
                                manualSongChange = true
                                playMusic.stop()
                                isPlaying = false
                                listMusics.currentIndex -= 1
                                playMusic.play()
                                isPlaying = true
                            }
                            else {
                                listMusics.currentIndex = musicModel.count - 1
                            }
                        }
                    }
                }

                Image {
                    id: playButton

                    width: 100
                    height: 100

                    source: "ui/assets/playButton.png"

                    visible: !isPlaying

                    MouseArea{
                        id: playMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        onClicked: {
                            playMusic.source = folderpath + "/" + selectedMusicName
                            isPlaying = true
                            console.log("The song is playing!")
                            playMusic.play()
                        }
                    }
                }

                Image {
                    id: stopButton

                    width: 100
                    height: 100

                    source: "ui/assets/stopButton.png"

                    visible: isPlaying

                    MouseArea{
                        id: stopMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        onClicked: {
                            isPlaying = false
                            console.log("The song is stopped!")
                            playMusic.pause()
                        }
                    }
                }

                Image {
                    id: nextButton

                    width: 100
                    height: 100

                    source: "ui/assets/nextSong.png"

                    MouseArea{
                        id: nextMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        onClicked: {
                            if (listMusics.currentIndex < musicModel.count - 1) {
                                manualSongChange = true
                                playMusic.stop()
                                isPlaying = false
                                listMusics.currentIndex += 1
                                playMusic.play()
                                isPlaying = true
                            }
                            else {
                                listMusics.currentIndex = 0
                                selectedMusicName = musicModel.get(listMusics.currentIndex).name
                            }
                        }
                    }
                }

                Row {
                    spacing: 20

                    Slider {
                        id: soundSlider

                        height: 100
                        orientation: Qt.Vertical

                        from: 0.
                        value: 0.7
                        to: 1.

                        background: Rectangle {
                            x: soundSlider.leftPadding + soundSlider.availableWidth / 2 - width / 2
                            y: soundSlider.topPadding

                            implicitWidth: 4
                            implicitHeight: 200

                            width: implicitWidth
                            height: soundSlider.availableHeight

                            color: "#000000"

                            radius: 2

                            Rectangle {
                                height: soundSlider.visualPosition * parent.height
                                width: parent.width

                                color: "#bababa"

                                radius: 2
                            }
                        }

                        handle: Rectangle {
                            x: soundSlider.leftPadding + soundSlider.availableWidth / 2 - width / 2
                            y: soundSlider.topPadding + soundSlider.visualPosition * (soundSlider.availableHeight - height)

                            implicitHeight: 10
                            implicitWidth: 10

                            color: soundSlider.pressed ? "CDC2A5" : "#7a7361"

                            radius: 10
                        }

                        Item {
                            anchors {
                                top: soundSlider.top
                                left: soundSlider.right

                                topMargin: 2
                                leftMargin: 1
                                rightMargin: 10
                            }

                            Image {
                                width: 10
                                height: 10

                                source: "ui/assets/plus.png"
                            }
                        }

                        Item {
                            anchors {
                                bottom: soundSlider.bottom
                                left: soundSlider.right

                                bottomMargin: 10
                                leftMargin: 1
                                rightMargin: 10
                            }

                            Image {
                                width: 10
                                height: 10

                                source: "ui/assets/minus.png"
                            }
                        }
                    }

                    Column{
                        anchors.verticalCenter: parent.verticalCenter

                        spacing: 20

                        Image {
                            id: replayButton

                            width: 35
                            height: 35

                            source: isLooping ? "ui/assets/replayPassive.png" : "ui/assets/replay.png"

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    isLooping = !isLooping;
                                    console.log("Looping state:", isLooping);
                                }
                            }
                        }

                        Image {
                            id: shuffleButton

                            width: 35
                            height: 35

                            source: isShuffling ? "ui/assets/shufflePassive.png" : "ui/assets/shuffle.png"

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    isShuffling = !isShuffling
                                    console.log("Shuffling state:", isShuffling)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        width: 400
        height: 360

        color: "#a1a1a1"

        radius: 10

        border.color: "black"
        border.width: 3

        anchors {
            verticalCenter: parent.verticalCenter

            right: parent.right

            margins: 10
            rightMargin: 40
        }

        ListModel {
            id: musicModel
        }

        Component {
            id: musicDelegate

            Rectangle {
                id: musicDelegateRect

                implicitHeight: txt.implicitHeight
                implicitWidth: txt.implicitWidth

                color: listMusics.currentIndex == index ? "#c4c4c4" : "#a1a1a1"

                border {
                    width: 2

                    color: listMusics.currentIndex == index ? "black" : "transparent"
                }

                radius: 10

                anchors {
                    left: parent.left
                    right: parent.right

                    margins: 10
                }

                Text {
                    id: txt

                    width: musicDelegateRect.width - 40

                    text: model.name;
                    font.pixelSize: 27

                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log(index, model.name)
                        listMusics.currentIndex = index
                        selectedMusicName = model.name
                    }
                }
            }
        }

        ListView {
            id: listMusics

            model: musicModel
            delegate: musicDelegate

            anchors.fill: parent
            clip: true

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom

                margins: 10
            }

            ScrollBar.vertical: ScrollBar {
                id: verticalScrollBar

                policy: ScrollBar.AlwaysOn

                background: Rectangle {
                    implicitWidth: 10
                    implicitHeight: 100

                    color: "#bababa"
                }
            }

            onCurrentIndexChanged: {
                manualSongChange = true
                playMusic.stop()
                isPlaying = false

                var validIndex = listMusics.currentIndex
                if (!musicModel || listMusics.currentIndex < 0 || listMusics.currentIndex >= musicModel.count || !musicModel.get(listMusics.currentIndex)) {
                    validIndex = getRandomIndex()
                }

                var musicItem = musicModel.get(validIndex)
                if (musicItem && musicItem.name) {
                    selectedMusicName = musicItem.name
                    playMusic.source = folderpath + "/" + selectedMusicName
                    playMusic.play()
                    isPlaying = true

                    var fullPath = folderpath + "/" + selectedMusicName
                    fullPath = fullPath.replace("file://", "")
                    FileManageBackend.parseMp3(fullPath)
                }
                else {
                    console.error("Music item or name is undefined")
                }

                if (validIndex === musicModel.count - 1 && !isLooping) {
                    playMusic.stop()
                    isPlaying = false
                }
            }
        }
    }

    Rectangle {
        width: 120
        height: 30

        color: "#c4c4c4"

        radius: 10

        border.color: "black"
        border.width: 3

        Text {
            anchors.centerIn: parent

            text: "Load MP3s"
            font.pixelSize: 15
            color: "black"
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                filesOpen.open()
            }
        }
    }

    FileDialog {
        id: filesOpen

        folder: folderpath
        fileMode: FileDialog.ReadOnly
        nameFilters: musicNameFilters
        title: "Select MP3 Files"

        onAccepted: {
            musicModel.clear()
            console.log(folderpath = folder)
            var fileList = FileManageBackend.fileSearch(folderpath = folder)
            for (var i = 0; i < fileList.length; i++) {
                musicModel.append({ name: fileList[i] })
            }
            console.log(musicModel)
        }
    }

    MediaPlayer {
        id: playMusic

        source: ""

        audioOutput: AudioOutput {
            volume: soundSlider.value
        }

        onPlaybackStateChanged: {
            if (playMusic.playbackState === MediaPlayer.StoppedState && isPlaying) {
                if (isLooping) {
                    if (!manualSongChange){
                        if (listMusics.currentIndex < musicModel.count - 1) {
                            listMusics.currentIndex += 1
                        }
                        else {
                            listMusics.currentIndex = 0
                        }
                    }
                    selectedMusicName = musicModel.get(listMusics.currentIndex).name
                    playMusic.source = folderpath + "/" + selectedMusicName
                    playMusic.play();
                }
                else if (isShuffling) {
                    var newIndex = getRandomIndex()
                    listMusics.currentIndex = newIndex
                    if (listMusics.currentIndex >= 0 && listMusics.currentIndex < musicModel.count) {
                        playMusic.play()
                    }
                }
                else if (!manualSongChange) {
                    if (listMusics.currentIndex < musicModel.count - 1) {
                        listMusics.currentIndex += 1
                        selectedMusicName = musicModel.get(listMusics.currentIndex).name
                        playMusic.source = folderpath + "/" + selectedMusicName
                        playMusic.play()
                    }
                    else {
                        playMusic.stop()
                        isPlaying = false
                    }
                }
            }
            manualSongChange = false
        }
    }
}
