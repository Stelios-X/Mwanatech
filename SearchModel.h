// SearchModel.h
// ============================================================================
// Purpose: Provides search and filtering capabilities for the book library
// Responsibilities:
//   - Filters books by title, author, or status
//   - Maintains a list of search results
//   - Emits signals when search results change
//   - Supports real-time search as user types
// ============================================================================

#ifndef SEARCHMODEL_H
#define SEARCHMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QString>

// Book struct - represents a single book record
struct BookResult {
    int id;                    // Unique identifier for the book
    QString title;             // Title of the book
    QString author;            // Author name
    QString status;            // Book status: SHELF, LOANED, BORROWED
    QString contactName;       // Contact person if book is loaned/borrowed
    QString contactNumber;     // Contact phone number
};

// SearchModel class - manages search results and filtering
class SearchModel : public QAbstractListModel
{
    Q_OBJECT
    
    // Q_PROPERTY makes these accessible from QML
    Q_PROPERTY(int resultCount READ getResultCount NOTIFY resultsChanged)
    Q_PROPERTY(QString currentSearch READ getCurrentSearch NOTIFY searchChanged)

public:
    // Define roles for accessing book properties from the model
    enum BookRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        AuthorRole,
        StatusRole,
        ContactNameRole,
        ContactNumberRole
    };

    // Constructor: Initialize the search model
    explicit SearchModel(QObject *parent = nullptr);

    // ========== Qt Model Interface Methods ==========
    // These methods are required for QAbstractListModel to function

    // rowCount: Returns the number of search results
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    // data: Retrieves data for a specific book and role
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // roleNames: Maps role enums to property names for QML access
    QHash<int, QByteArray> roleNames() const override;

    // ========== Public Methods ==========
    
    // performSearch: Execute a search query on all books
    // Parameters:
    //   - query: The search term (title, author, or exact status)
    //   - searchType: "all" (title+author), "title", "author", or "status"
    // Emits: resultsChanged signal when search completes
    Q_INVOKABLE void performSearch(const QString &query, const QString &searchType = "all");

    // clearSearch: Reset search results and show all books
    // Emits: resultsChanged and searchChanged signals
    Q_INVOKABLE void clearSearch();

    // getCurrentSearch: Get the current search query string
    QString getCurrentSearch() const { return m_currentSearch; }

    // getResultCount: Get the number of search results
    int getResultCount() const { return m_results.count(); }

    // ========== Signals ==========
    // These signals notify QML when the search state changes

signals:
    // resultsChanged: Emitted when search results are updated
    void resultsChanged();

    // searchChanged: Emitted when the search query changes
    void searchChanged();

private:
    // ========== Private Member Variables ==========
    
    // m_results: List of books that match the current search criteria
    QList<BookResult> m_results;

    // m_currentSearch: The current search query being used
    QString m_currentSearch;

    // m_allBooks: Cache of all books from the database for searching
    QList<BookResult> m_allBooks;

    // ========== Private Methods ==========

    // loadAllBooks: Load all books from database into memory for searching
    // This is called once to cache all books for fast searching
    void loadAllBooks();

    // performTitleSearch: Search books by title (case-insensitive)
    void performTitleSearch(const QString &query);

    // performAuthorSearch: Search books by author (case-insensitive)
    void performAuthorSearch(const QString &query);

    // performStatusSearch: Filter books by exact status (SHELF, LOANED, BORROWED)
    void performStatusSearch(const QString &status);

    // performFullSearch: Search both title and author fields
    void performFullSearch(const QString &query);
};

#endif // SEARCHMODEL_H
