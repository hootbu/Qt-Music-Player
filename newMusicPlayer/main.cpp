#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QString>
#include "filemanagebackend.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    FileManageBackend filemanage;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("FileManageBackend", &filemanage);

    const QUrl url(QStringLiteral("qrc:/newMusicPlayer/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
