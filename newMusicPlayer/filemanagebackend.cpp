#include "filemanagebackend.h"
#include <QDebug>
#include <QDir>
#include <QUrl>
#include <QFile>
#include <QDataStream>
#include <QBuffer>
#include <QImage>

FileManageBackend::FileManageBackend(QObject *parent)
    : QObject{parent}
{

}

QStringList FileManageBackend::fileSearch(const QString &path)
{
    QStringList m_List;

    // Convert file URL to local path
    QUrl url(path);
    QString directoryPath = url.toLocalFile();

    // Debug output
    qDebug() << "Original path:" << path;
    qDebug() << "Converted directory path:" << directoryPath;

    QDir directory(directoryPath);
    if (!directory.exists()) {
        qWarning() << "Directory does not exist:" << directoryPath;
        return m_List; // Return empty list if directory doesn't exist
    }

    // Set filters and get file list
    QStringList filter;
    filter << "*.mp3";
    directory.setNameFilters(filter);
    directory.setFilter(QDir::Files);

    QStringList entries = directory.entryList();
    qDebug() << "Files found:" << entries; // Print found files

    if (entries.isEmpty()) {
        qWarning() << "No MP3 files found in directory.";
    }

    foreach (QString data, entries) {
        QString fileName = QFileInfo(data).fileName(); // Extract file name
        m_List.append(fileName);
        qDebug() << "Added file name:" << fileName; // Debugging output
    }
    return m_List;
}

void FileManageBackend::parseMp3(const QString &filePath){
    parseID3(filePath);
    emit titleChanged();
    emit artistChanged();
    emit coverImagePathChanged();
}

QString FileManageBackend::title() const
{
    return m_title;
}

QString FileManageBackend::artist() const
{
    return m_artist;
}

QString FileManageBackend::coverImagePath() const
{
    return m_coverImagePath;
}

QString decodeText(const QByteArray &data)
{
    if (data.isEmpty()) {
        return QString();
    }

    // Check encoding byte
    char encoding = data[0];
    QByteArray textData = data.mid(1);

    if (encoding == 0) {
        // ISO-8859-1
        return QString::fromLatin1(textData);
    } else if (encoding == 1) {
        // UTF-16 with BOM
        return QString::fromUtf16(reinterpret_cast<const ushort *>(textData.constData() + 2), (textData.size() - 2) / 2);
    } else if (encoding == 2) {
        // UTF-16BE without BOM
        return QString::fromUtf16(reinterpret_cast<const ushort *>(textData.constData()), textData.size() / 2);
    } else if (encoding == 3) {
        // UTF-8
        return QString::fromUtf8(textData);
    }

    // Default to ISO-8859-1 if encoding is unknown
    return QString::fromLatin1(textData);
}

void FileManageBackend::parseID3(const QString &filePath){
    QFile file(filePath);
    m_coverImagePath = "";
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Cannot open file for reading:" << filePath;
        return;
    }

    QByteArray header = file.read(10);
    if (header.mid(0, 3) != "ID3") {
        qWarning() << "No ID3 tag found in file:" << filePath;
        return;
    }

    int tagSize = (header[6] & 0x7F) << 21 | (header[7] & 0x7F) << 14 | (header[8] & 0x7F) << 7 | (header[9] & 0x7F);
    QByteArray tagData = file.read(tagSize);

    int pos = 0;
    while (pos < tagSize) {
        if (pos + 10 > tagData.size()) {
            qWarning() << "Incomplete frame header at position:" << pos;
            break;
        }

        QByteArray frameHeader = tagData.mid(pos, 10);
        int frameSize = (frameHeader[4] & 0x7F) << 21 |
                        (frameHeader[5] & 0x7F) << 14 |
                        (frameHeader[6] & 0x7F) << 7 |
                        (frameHeader[7] & 0x7F);


        if (pos + 10 + frameSize > tagData.size()) {
            qWarning() << "Incomplete frame data at position:" << pos;
            break;
        }

        QByteArray frameData = tagData.mid(pos + 10, frameSize);
        QString frameID = frameHeader.mid(0, 4);

        if (frameID == "TIT2") {
            m_title = decodeText(frameData);
        } else if (frameID == "TPE1") {
            m_artist = decodeText(frameData);
        } else if (frameID == "APIC") {
            int mimeTypeEnd = frameData.indexOf('\0', 1);
            QString mimeType = QString::fromLatin1(frameData.mid(1, mimeTypeEnd - 1));

            int descriptionEnd = frameData.indexOf('\0', mimeTypeEnd + 1);
            QByteArray imageData = frameData.mid(descriptionEnd + 1);

            QImage coverImage;
            if (mimeType.contains("jpeg")) {
                if (!coverImage.loadFromData(imageData, "JPEG")) {
                    qWarning() << "Failed to load JPEG image from APIC frame";
                    break;
                }
            } else if (mimeType.contains("png")) {
                if (!coverImage.loadFromData(imageData, "PNG")) {
                    qWarning() << "Failed to load PNG image from APIC frame";
                    break;
                }
            } else {
                qWarning() << "Unsupported image format in APIC frame:" << mimeType;
                break;
            }

            QString tempPath = QDir::tempPath() + "/coverImage.jpg";

            if (!coverImage.save(tempPath)) {
                qWarning() << "Failed to save cover image to temporary path";
                break;
            }
            m_coverImagePath = "file://" + tempPath;

        }

        pos += 10 + frameSize;
    }
}
