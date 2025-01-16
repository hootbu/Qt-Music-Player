cmake_minimum_required(VERSION 3.16)

project(newMusicPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Quick Multimedia Core Widgets)
set(TagLib_DIR "/usr/local/lib/cmake/taglib")
set(CMAKE_PREFIX_PATH "/usr/local")
find_package(TagLib REQUIRED)
find_package(ZLIB REQUIRED)


qt_add_executable(appnewMusicPlayer
    main.cpp

)

qt_add_qml_module(appnewMusicPlayer
    URI newMusicPlayer
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES ui/assets/minus.png ui/assets/nextSong.png ui/assets/playButton.png ui/assets/plus.png ui/assets/previousSong.png ui/assets/stopButton.png
        RESOURCES
        SOURCES   main.cpp
        SOURCES filemanagebackend.h filemanagebackend.cpp
        RESOURCES
        RESOURCES ui/assets/replay.png
        RESOURCES ui/assets/shuffle.png
        QML_FILES
        RESOURCES ui/assets/shufflePassive.png
        RESOURCES ui/assets/replayPassive.png
        RESOURCES ui/assets/defaultCover.gif
        RESOURCES ui/assets/defaultCover.gif
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appnewMusicPlayer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appnewMusicPlayer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appnewMusicPlayer
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Multimedia
    PRIVATE TagLib::TagLib
    PRIVATE ZLIB::ZLIB
)

include(GNUInstallDirs)
install(TARGETS appnewMusicPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
