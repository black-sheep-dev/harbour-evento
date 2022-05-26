#include <QtQuick>

#include <sailfishapp.h>
#include <QGuiApplication>

#include "eventsmodel.h"
#include "sortfiltermodel.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> v(SailfishApp::createView());

    app->setApplicationVersion(APP_VERSION);
    app->setApplicationName("evento");
    app->setOrganizationDomain("org.nubecula");
    app->setOrganizationName("org.nubecula");

#ifdef QT_DEBUG
    #define uri "org.nubecula.harbour.evento"
#else
    const auto uri = "org.nubecula.harbour.evento";
#endif

    qmlRegisterType<EventsModel>(uri, 1, 0, "EventsModel");
    qmlRegisterType<SortFilterModel>(uri, 1, 0, "SortFilterModel");

    auto context = v.data()->rootContext();

    auto model = new EventsModel;
    context->setContextProperty("Events", model);

    v->setSource(SailfishApp::pathTo("qml/harbour-evento.qml"));
    v->show();

    return app->exec();
}
