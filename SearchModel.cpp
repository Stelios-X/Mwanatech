// SearchModel.cpp
// ============================================================================
// Implementation of the SearchModel class for book search and filtering
// ============================================================================

#include "SearchModel.h"
#include "DatabaseManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

// ============================================================================
// CONSTRUCTOR
// ============================================================================
// Initializes the search model and loads all books from the database
SearchModel::SearchModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // Load all books from database into cache for fast searching
    loadAllBooks();
}

// ============================================================================
// Qt MODEL INTERFACE IMPLEMENTATION
// ============================================================================
// These methods are required by QAbstractListModel for the model to work

// rowCount: Returns the number of books in the current search results
int SearchModel::rowCount(const QModelIndex &parent) const
{
    // Return 0 if parent is valid (model is a flat list, no sub-items)
    if (parent.isValid())
        return 0;
    
    // Return the count of results matching current search criteria
    return m_results.count();
}

// data: Retrieve data for a specific book and role (property)
// index: Position of the book in the results list
// role: Which property to retrieve (title, author, status, etc.)
QVariant SearchModel::data(const QModelIndex &index, int role) const
{
    // Validate the index is within bounds
    if (!index.isValid() || index.row() < 0 || index.row() >= m_results.count())
        return QVariant();

    // Get the book at this index
    const BookResult &book = m_results[index.row()];

    // Return the appropriate property based on the role
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
        return QVariant();  // Unknown role
    }
}

// roleNames: Map role enums to property names accessible from QML
// This allows QML to access properties like: model.title, model.author, etc.
QHash<int, QByteArray> SearchModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";                           // Book ID
    roles[TitleRole] = "title";                     // Book title
    roles[AuthorRole] = "author";                   // Author name
    roles[StatusRole] = "status";                   // Book status
    roles[ContactNameRole] = "contactName";         // Contact person
    roles[ContactNumberRole] = "contactNumber";     // Contact phone
    return roles;
}

// ============================================================================
// PUBLIC SEARCH METHODS
// ============================================================================

// performSearch: Execute a search based on user query and search type
// This is the main entry point for searching books
void SearchModel::performSearch(const QString &query, const QString &searchType)
{
    // Update the current search query for display purposes
    m_currentSearch = query;

    // Perform the appropriate type of search based on user selection
    if (searchType == "title") {
        // Search by title only
        performTitleSearch(query);
    } 
    else if (searchType == "author") {
        // Search by author only
        performAuthorSearch(query);
    } 
    else if (searchType == "status") {
        // Filter by status (exact match)
        performStatusSearch(query);
    } 
    else {
        // Default: search both title and author
        performFullSearch(query);
    }

    // Notify QML that results have changed
    emit resultsChanged();
    emit searchChanged();

    // Log search results for debugging
    qDebug() << "Search completed:" << query << "Results:" << m_results.count();
}

// clearSearch: Reset search and show all books
void SearchModel::clearSearch()
{
    // Reset search state
    m_currentSearch = "";
    
    // Reset results to show all books
    beginResetModel();
    m_results = m_allBooks;
    endResetModel();

    // Notify QML of state change
    emit resultsChanged();
    emit searchChanged();

    qDebug() << "Search cleared. Showing all" << m_results.count() << "books";
}

// ============================================================================
// PRIVATE SEARCH IMPLEMENTATION METHODS
// ============================================================================

// loadAllBooks: Load all books from database into memory
// This is called once during initialization for fast searching
void SearchModel::loadAllBooks()
{
    // Clear any existing data
    m_results.clear();
    m_allBooks.clear();

    // Query all books from the database ordered by ID (newest first)
    QSqlQuery query("SELECT id, title, author, status, contact_name, contact_number FROM books ORDER BY id DESC");

    // Iterate through each row returned by the query
    while (query.next()) {
        // Create a new book result object
        BookResult book;
        book.id = query.value(0).toInt();                   // Get ID
        book.title = query.value(1).toString();             // Get title
        book.author = query.value(2).toString();            // Get author
        book.status = query.value(3).toString();            // Get status
        book.contactName = query.value(4).toString();       // Get contact name
        book.contactNumber = query.value(5).toString();     // Get contact number

        // Add to both cache lists
        m_allBooks.append(book);
        m_results.append(book);
    }

    // Check for database errors
    if (query.lastError().isValid()) {
        qCritical() << "Failed to load books for search:" << query.lastError().text();
    }

    qDebug() << "Loaded" << m_allBooks.count() << "books for searching";
}

// performTitleSearch: Search books by title (case-insensitive partial match)
// Example: "the fix" finds "The Fix" and "The Five"
void SearchModel::performTitleSearch(const QString &query)
{
    // Clear previous results
    m_results.clear();

    // Convert search query to lowercase for case-insensitive comparison
    QString lowerQuery = query.toLower();

    // Iterate through all books in cache
    for (const BookResult &book : m_allBooks) {
        // Check if book title contains the search query (case-insensitive)
        if (book.title.toLower().contains(lowerQuery)) {
            m_results.append(book);  // Add matching book to results
        }
    }

    qDebug() << "Title search for" << query << "found" << m_results.count() << "matches";
}

// performAuthorSearch: Search books by author (case-insensitive partial match)
// Example: "smith" finds "John Smith" and "Adam Smith"
void SearchModel::performAuthorSearch(const QString &query)
{
    // Clear previous results
    m_results.clear();

    // Convert search query to lowercase for case-insensitive comparison
    QString lowerQuery = query.toLower();

    // Iterate through all books in cache
    for (const BookResult &book : m_allBooks) {
        // Check if author name contains the search query (case-insensitive)
        if (book.author.toLower().contains(lowerQuery)) {
            m_results.append(book);  // Add matching book to results
        }
    }

    qDebug() << "Author search for" << query << "found" << m_results.count() << "matches";
}

// performStatusSearch: Filter books by exact status value
// Valid statuses: "SHELF", "LOANED", "BORROWED"
void SearchModel::performStatusSearch(const QString &status)
{
    // Clear previous results
    m_results.clear();

    // Iterate through all books in cache
    for (const BookResult &book : m_allBooks) {
        // Check if book status matches exactly (case-sensitive)
        if (book.status == status) {
            m_results.append(book);  // Add matching book to results
        }
    }

    qDebug() << "Status search for" << status << "found" << m_results.count() << "matches";
}

// performFullSearch: Search both title and author fields
// Example: "tolkien" finds books with "tolkien" in title OR author
void SearchModel::performFullSearch(const QString &query)
{
    // Clear previous results
    m_results.clear();

    // Convert search query to lowercase for case-insensitive comparison
    QString lowerQuery = query.toLower();

    // Iterate through all books in cache
    for (const BookResult &book : m_allBooks) {
        // Check if EITHER title OR author contains the search query
        if (book.title.toLower().contains(lowerQuery) || 
            book.author.toLower().contains(lowerQuery)) {
            m_results.append(book);  // Add matching book to results
        }
    }

    qDebug() << "Full search for" << query << "found" << m_results.count() << "matches";
}
