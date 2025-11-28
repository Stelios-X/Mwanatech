-- Script to create the library database
-- Run this in your PostgreSQL database

CREATE TABLE IF NOT EXISTS books (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    -- Status can be:
    -- 'SHELF': On the shelf (owned)
    -- 'LOANED': Loaned out to someone (owned)
    -- 'BORROWED': Borrowed from someone (not owned)
    status TEXT NOT NULL DEFAULT 'SHELF',
    contact_name TEXT,   -- Person loaned to OR borrowed from
    contact_number TEXT  -- Contact number of that person
);
