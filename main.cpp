#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include "DatabaseManager.h"
#include "LibraryModel.h"
#include "SearchModel.h"

int main(int argc, char *argv[])
{
    // Force non-native style
    qputenv("QT_QUICK_CONTROLS_STYLE", "Material");
    qputenv("QT_STYLE_OVERRIDE", "Material");

    // FIX: Force Qt to look in the system plugin directory for drivers (Arch Linux specific)
    // This fixes the "Driver not loaded" error when running from Qt Creator
    qputenv("QT_PLUGIN_PATH", "/usr/lib/qt6/plugins");

    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    // Initialize Database
    DatabaseManager dbManager;
    if (!dbManager.connectToDatabase()) {
        qWarning() << "Failed to connect to database. Check credentials in DatabaseManager.cpp";
    }

    QQmlApplicationEngine engine;

    // Register LibraryModel - Main book list model
    LibraryModel libraryModel;
    engine.rootContext()->setContextProperty("libraryModel", &libraryModel);

    // Register SearchModel - Search and filter model
    SearchModel searchModel;
    engine.rootContext()->setContextProperty("searchModel", &searchModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Mwanatech", "Main");

    return app.exec();
}
