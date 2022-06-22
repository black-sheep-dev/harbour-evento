#ifndef EVENTSMODEL_H
#define EVENTSMODEL_H

#include <QAbstractListModel>

#include <QDateTime>

struct Event {
    QDateTime created;
    QDateTime date;
    QString title;
    qint64 remaining{0};
    quint8 repeat{0};
};

class EventsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum EventRoles {
        TitleRole        = Qt::UserRole + 1,
        CreatedRole,
        DateRole,
        IdRole,
        RemainingRole,
        RepeatRole,
    };
    Q_ENUM(EventRoles)

    enum Repeat {
        RepeatNever,
        RepeatWeekly,
        RepeatMonthly,
        RepeatYearly
    };
    Q_ENUM(Repeat)

    explicit EventsModel(QObject *parent = nullptr);

public slots:
    void addEvent(const QString &title, const QDateTime &date, quint8 repeat = 0);
    bool updateEvent(int id, const QString &title, const QDateTime &date, quint8 repeat = 0);
    void clear();
    void removeEvent(int index);
    void refresh();

    // save & load
    bool load();
    bool save();

signals:
    void changed();


private:
    QList<Event> m_events;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // EVENTSMODEL_H
