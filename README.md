# Qt Music Player
###### Created by Emir Yorgun

Music player application developed using Qt 6.7.2. It provides a user-friendly interface, robust playback controls, and seamless audio performance.

## Features

- **Sleek User Interface:** Display album covers and user-friendly design.
- **Playback Controls:** Play, pause, and skip to previous and next songs.
- **Volume Controls:** Adjust the volume level.
- **Playback Modes:** Shuffle and repeat options.
- **File Loading:** Easily load MP3 files.

## Installation

### Requirements

- Qt 6.7.2 or later

### Steps

1. Clone the repository:
    ```bash
    git clone https://github.com/hootbu/Qt-Music-Player.git
    cd Qt-Music-Player
    ```
2. Create a new Qt project or add the files to an existing project.
3. Navigate to the `newMusicPlayer` directory and add the necessary files (or just open **CMakeLists.txt** file as project) to your project.
4. Build and run the project.


## Usage

1. **Loading MP3 Files:**
   - Click the **Load MP3s** button to open the file loading dialog.
   - **Select** and **load** the desired MP3 files.

2. **Playback Controls:**
   - **Play/Pause:** Click the play button to **play**, and the stop button to **pause**.
   - **Previous/Next Song:** Click the left arrow button for the **previous song** and the right arrow button for the **next song**.

3. **Volume Controls:**
   - Use the vertical **volume slider** to adjust the volume level.

4. **Playback Modes:**
   - **Repeat:** Click the replay button to toggle **repeat mode**.
   - **Shuffle:** Click the shuffle button to toggle **shuffle mode**.
  
## File Structure

- `Main.qml`: Defines the main user interface of the application.
- `filemanagebackend.cpp/h`: Contains classes for managing MP3 files and parsing ID3 tags.
- `main.cpp`: Entry point of the application and initializes the QML engine.

## Screenshot

#### Final Look of the Music Player
![image](https://github.com/user-attachments/assets/aeb8e789-e47b-4fff-bec0-d24ea1a21917)

------------

This project demonstrates the practical use of Qt for multimedia applications and provides a solid foundation for future enhancements.
