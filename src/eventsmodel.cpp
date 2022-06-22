#include "eventsmodel.h"

#define     EVENTO_FILE_MAGIC       0x4556454e544f  // EVENTO
#define     EVENTO_FILE_VERSION     2               // don't use 79

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

void EventsModel::addEvent(const QString &title, const QDateTime &date, quint8 repeat)
{
    Event event;
    event.title = title;
    event.date = date;
    event.created = QDateTime::currentDateTime();
    event.repeat = repeat;

    event.remaining = QDateTime::currentDateTime().daysTo(event.date);

    beginInsertRows(QModelIndex(), m_events.count(), m_events.count());
    m_events.append(event);
    endInsertRows();
    emit changed();
}

bool EventsModel::updateEvent(int id, const QString &title, const QDateTime &date, quint8 repeat)
{
    const auto idx = index(id);
    if (!idx.isValid()) {
        return false;
    }

    m_events[id].title = title;
    m_events[id].date = date;
    m_events[id].remaining = QDateTime::currentDateTime().daysTo(m_events[id].date);
    m_events[id].repeat = repeat;
    emit dataChanged(idx, idx);

    return true;
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
    for (int i = 0; i < m_events.count(); i++) {
        QVector<int> roles;

        const qint64 remaining = QDateTime::currentDateTime().daysTo(m_events[i].date);
        if (m_events[i].remaining != remaining) {
            m_events[i].remaining = remaining;
            roles << RemainingRole;
        }

        if (m_events[i].repeat && m_events[i].remaining < 0) {
            switch (m_events[i].repeat) {
            case RepeatWeekly:
                m_events[i].date = m_events[i].date.addDays(7);
                roles << DateRole;
                break;

            case RepeatMonthly:
                m_events[i].date = m_events[i].date.addMonths(1);
                roles << DateRole;
                break;

            case RepeatYearly:
                m_events[i].date = m_events[i].date.addYears(1);
                roles << DateRole;
                break;

            default:
                break;
            }
        }

        if (!roles.isEmpty()) {
            emit dataChanged(index(i), index(i), roles);
        }
    }
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

    // fixed bug initial release
    if (version == 79) {
        version = 1;
    }

    int count{0};
    in >> count;


    beginResetModel();
    for (int i = 0; i < count; ++i) {
        Event event;
        in >> event.title;
        in >> event.date;
        in >> event.created;

        event.remaining = QDateTime::currentDateTime().daysTo(event.date);

        if (version > 1) {
            in >> event.repeat;
        }

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
    out << quint8(EVENTO_FILE_VERSION);

    out << m_events.count();

    for (const auto &event : m_events) {
        out << event.title;
        out << event.date;
        out << event.created;
        out << event.repeat;
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
        return event.remaining;

    case CreatedRole:
        return event.created;

    case DateRole:
        return event.date;

    case IdRole:
        return index.row();

    case RepeatRole:
        return event.repeat;

    default:
        return QVariant();
    }
}

QHash<int, QByteArray> EventsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[CreatedRole]      = "created";
    roles[DateRole]         = "date";
    roles[IdRole]           = "id";
    roles[RemainingRole]    = "remaining";
    roles[RepeatRole]       = "repeat";
    roles[TitleRole]        = "title";

    return roles;
}
