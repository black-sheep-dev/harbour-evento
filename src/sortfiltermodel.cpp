#include "sortfiltermodel.h"

#include "eventsmodel.h"

SortFilterModel::SortFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setDynamicSortFilter(true);
    setSortRole(EventsModel::TitleRole);
}

void SortFilterModel::sortModel()
{
    sort(0, sortOrder());
}
