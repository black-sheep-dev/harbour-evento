#ifndef EVENTSMODEL_H
#define EVENTSMODEL_H

#include <QAbstractListModel>

#include <QDateTime>

struct Event {
    QDateTime created;
    QDateTime date;
    QString title;
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
        RemainingRole
    };
    Q_ENUM(EventRoles)

    explicit EventsModel(QObject *parent = nullptr);

public slots:
    void addEvent(const QString &title, const QDateTime &date);
    void clear();
    void removeEvent(int index);

    // save & load
    bool load();
    bool save();

private:
    QList<Event> m_events;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QHash<int, QByteArray> roleNames() const override;
};

#endif // EVENTSMODEL_H
