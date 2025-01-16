#ifndef FILEMANAGEBACKEND_H
#define FILEMANAGEBACKEND_H

#include <QObject>
#include <QDir>
#include <QMediaMetaData>
#include <QString>

class FileManageBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged)
    Q_PROPERTY(QString coverImagePath READ coverImagePath NOTIFY coverImagePathChanged)


public:
    explicit FileManageBackend(QObject *parent = nullptr);

    Q_INVOKABLE QStringList fileSearch(const QString &path);
    Q_INVOKABLE void parseMp3(const QString &filePath);

    QString title() const;
    QString artist() const;
    QString coverImagePath() const;

private:
    QStringList m_List;

    QString m_title;
    QString m_artist;
    QString m_coverImagePath;

    void parseID3(const QString &filePath);

signals:
    void titleChanged();
    void artistChanged();
    void coverImagePathChanged();
};

#endif // FILEMANAGEBACKEND_H
