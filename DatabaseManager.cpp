#include "DatabaseManager.h"

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject{parent}
{
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

bool DatabaseManager::connectToDatabase()
{
    // NOTE: Update these credentials to match your local PostgreSQL setup
    m_db = QSqlDatabase::addDatabase("QPSQL");
    m_db.setHostName("localhost");
    m_db.setDatabaseName("mwanatech_db");
    m_db.setUserName("gallink");
    m_db.setPassword("LS83^#NdhTSBs%^SB944dhadk52");

    if (!m_db.open()) {
        qCritical() << "Error: connection with database failed";
        qCritical() << m_db.lastError().text();
        qCritical() << "Available drivers:" << QSqlDatabase::drivers();
        return false;
    }

    qDebug() << "Database: connection ok";
    
    // Ensure table exists
    QSqlQuery query;
    bool success = query.exec(
        "CREATE TABLE IF NOT EXISTS books ("
        "id SERIAL PRIMARY KEY, "
        "title TEXT NOT NULL, "
        "author TEXT NOT NULL, "
        "status TEXT NOT NULL, "
        "contact_name TEXT, "
        "contact_number TEXT)"
    );

    if (!success) {
        qCritical() << "Error creating table:" << query.lastError().text();
    }

    return true;
}

QSqlDatabase DatabaseManager::db() const
{
    return m_db;
}
