#include "eventsmodel.h"

#define     EVENTO_FILE_MAGIC       0x4556454e544f  // EVENTO
#define     EVENTO_FILE_VERSION     1

#include <QDataStream>
#include <QDir>
#include <QFile>
#include <QStandardPaths>

#include <QDebug>

EventsModel::EventsModel(QObject *parent) :
    QAbstractListModel(parent)
{
    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
}

void EventsModel::addEvent(const QString &title, const QDateTime &date)
{
    Event event;
    event.title = title;
    event.date = date;
    event.created = QDateTime::currentDateTime();

    beginInsertRows(QModelIndex(), m_events.count(), m_events.count());
    m_events.append(event);
    endInsertRows();
    emit changed();
}

void EventsModel::clear()
{
    beginResetModel();
    m_events.clear();
    endResetModel();
    emit changed();
}

void EventsModel::removeEvent(int index)
{
    if (index < 0 || index >= m_events.count())
        return;

    beginRemoveRows(QModelIndex(), index, index);
    m_events.removeAt(index);
    endRemoveRows();
    emit changed();
}

void EventsModel::refresh()
{
    emit dataChanged(index(0), index(m_events.count() - 1), QVector<int>() << RemainingRole);
}

bool EventsModel::load()
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/events.store"));

    if (!file.open(QIODevice::ReadOnly)) {
        return false;
    }

    QDataStream in(&file);
    in.setVersion(QDataStream::Qt_5_6);

    quint64 magic{0};
    in >> magic;

    if (magic != quint64(EVENTO_FILE_MAGIC)) {
        return false;
    }

    quint8 version{0};
    in >> version;

    int count{0};
    in >> count;


    beginResetModel();
    for (int i = 0; i < count; ++i) {
        Event event;
        in >> event.title;
        in >> event.date;
        in >> event.created;

        m_events.append(event);
    }
    endResetModel();

    emit changed();

    return true;
}

bool EventsModel::save()
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + QStringLiteral("/events.store"));

    if (!file.open(QIODevice::WriteOnly)) {
        return false;
    }

    QDataStream out(&file);
    out.setVersion(QDataStream::Qt_5_6);

    out << quint64(EVENTO_FILE_MAGIC);
    out << quint8(EVENTO_FILE_MAGIC);

    out << m_events.count();

    for (const auto &event : m_events) {
        out << event.title;
        out << event.date;
        out << event.created;
    }

    file.close();

    return true;
}

int EventsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_events.count();
}

QVariant EventsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto &event = m_events[index.row()];

    switch (role) {
    case TitleRole:
        return event.title;

    case RemainingRole:
        return QDateTime::currentDateTime().daysTo(event.date);

    case CreatedRole:
        return event.created;

    case DateRole:
        return event.date;

    case IdRole:
        return index.row();

    default:
        return QVariant();
    }
}

bool EventsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid()) {
        return false;
    }

    switch (role) {
    case TitleRole:
        m_events[index.row()].title = value.toString();
        break;

    case DateRole:
        m_events[index.row()].date = value.toDateTime();
        break;

    default:
        return false;
    }

    emit dataChanged(index, index, QVector<int>() << role);
    return true;
}

QHash<int, QByteArray> EventsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[CreatedRole]      = "created";
    roles[DateRole]         = "date";
    roles[IdRole]           = "id";
    roles[RemainingRole]    = "remaining";
    roles[TitleRole]        = "title";

    return roles;
}
