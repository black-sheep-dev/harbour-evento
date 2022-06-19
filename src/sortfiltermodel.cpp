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
    sort(0, m_sortOrder);
}

void SortFilterModel::setSortOrder(Qt::SortOrder order)
{
    if (m_sortOrder == order) {
        return;
    }
    m_sortOrder = order;
    sortModel();
}
