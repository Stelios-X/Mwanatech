#ifndef LIBRARYMODEL_H
#define LIBRARYMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>

struct Book {
    int id;
    QString title;
    QString author;
    QString status;
    QString contactName;
    QString contactNumber;
};

class LibraryModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum BookRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        AuthorRole,
        StatusRole,
        ContactNameRole,
        ContactNumberRole
    };

    explicit LibraryModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE void addBook(const QString &title, const QString &author, const QString &status, const QString &contactName, const QString &contactNumber);
    Q_INVOKABLE void removeBook(int index);

private:
    QList<Book> m_books;
};

#endif // LIBRARYMODEL_H
