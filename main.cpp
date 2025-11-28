#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "DatabaseManager.h"
#include "LibraryModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Initialize Database
    DatabaseManager dbManager;
    if (!dbManager.connectToDatabase()) {
        qWarning() << "Failed to connect to database. Check credentials in DatabaseManager.cpp";
    }

    QQmlApplicationEngine engine;

    // Register LibraryModel
    LibraryModel libraryModel;
    engine.rootContext()->setContextProperty("libraryModel", &libraryModel);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Mwanatech", "Main");

    return app.exec();
}
