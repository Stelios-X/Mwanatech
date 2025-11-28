#include "LibraryModel.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

LibraryModel::LibraryModel(QObject *parent)
    : QAbstractListModel(parent)
{
    refresh();
}

int LibraryModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_books.count();
}

QVariant LibraryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_books.count())
        return QVariant();

    const Book &book = m_books[index.row()];

    switch (role) {
    case IdRole:
        return book.id;
    case TitleRole:
        return book.title;
    case AuthorRole:
        return book.author;
    case StatusRole:
        return book.status;
    case ContactNameRole:
        return book.contactName;
    case ContactNumberRole:
        return book.contactNumber;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> LibraryModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[TitleRole] = "title";
    roles[AuthorRole] = "author";
    roles[StatusRole] = "status";
    roles[ContactNameRole] = "contactName";
    roles[ContactNumberRole] = "contactNumber";
    return roles;
}

void LibraryModel::refresh()
{
    beginResetModel();
    m_books.clear();

    QSqlQuery query("SELECT id, title, author, status, contact_name, contact_number FROM books ORDER BY id DESC");
    while (query.next()) {
        Book book;
        book.id = query.value(0).toInt();
        book.title = query.value(1).toString();
        book.author = query.value(2).toString();
        book.status = query.value(3).toString();
        book.contactName = query.value(4).toString();
        book.contactNumber = query.value(5).toString();
        m_books.append(book);
    }
    endResetModel();
}

void LibraryModel::addBook(const QString &title, const QString &author, const QString &status, const QString &contactName, const QString &contactNumber)
{
    QSqlQuery query;
    query.prepare("INSERT INTO books (title, author, status, contact_name, contact_number) VALUES (:title, :author, :status, :contactName, :contactNumber)");
    query.bindValue(":title", title);
    query.bindValue(":author", author);
    query.bindValue(":status", status);
    query.bindValue(":contactName", contactName);
    query.bindValue(":contactNumber", contactNumber);

    if (query.exec()) {
        refresh();
    } else {
        qCritical() << "Failed to add book:" << query.lastError().text();
    }
}

void LibraryModel::updateBook(int id, const QString &title, const QString &author, const QString &status, const QString &contactName, const QString &contactNumber)
{
    QSqlQuery query;
    query.prepare("UPDATE books SET title = :title, author = :author, status = :status, contact_name = :contactName, contact_number = :contactNumber WHERE id = :id");
    query.bindValue(":title", title);
    query.bindValue(":author", author);
    query.bindValue(":status", status);
    query.bindValue(":contactName", contactName);
    query.bindValue(":contactNumber", contactNumber);
    query.bindValue(":id", id);

    if (query.exec()) {
        refresh();
    } else {
        qCritical() << "Failed to update book:" << query.lastError().text();
    }
}

void LibraryModel::removeBook(int index)
{
    if (index < 0 || index >= m_books.count()) return;

    int id = m_books[index].id;
    QSqlQuery query;
    query.prepare("DELETE FROM books WHERE id = :id");
    query.bindValue(":id", id);

    if (query.exec()) {
        refresh();
    } else {
        qCritical() << "Failed to delete book:" << query.lastError().text();
    }
}
