#ifndef SORTFILTERMODEL_H
#define SORTFILTERMODEL_H

#include <QSortFilterProxyModel>

class SortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit SortFilterModel(QObject *parent = nullptr);

public slots:
    void sortModel();

};

#endif // SORTFILTERMODEL_H
