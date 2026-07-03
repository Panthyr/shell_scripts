#!/bin/bash

SRC_DB="/home/panthyr/data/panthyr.db"
DST_DB="/home/panthyr/data/panthyr_new.db"

rm -f "$DST_DB"

# Create tables and views
#
# "-init /dev/null" makes sqlite3 skip .sqliterc , 
#   so settings like .headers on, .mode column, or .separator 
#   won't interfere with the piped SQL output.
#
# "sql IS NOT NULL" skips SQLite's internal autoindexes
sqlite3 -noheader -init /dev/null "$SRC_DB" "
SELECT sql || ';'
FROM sqlite_master
WHERE type IN ('table', 'view')
  AND name IN (
    'protocol',
    'settings',
    'logs',
    'queue',
    'measurements',
    'logs_desc',
    'Possible Issues'
  )
  AND sql IS NOT NULL
ORDER BY
  CASE type
    WHEN 'table' THEN 1
    WHEN 'view'  THEN 2
  END;
" | sqlite3 "$DST_DB"

# Copy indexes and triggers belonging to those tables
sqlite3 -noheader -init /dev/null "$SRC_DB" "
SELECT sql || ';'
FROM sqlite_master
WHERE type IN ('index', 'trigger')
  AND tbl_name IN (
    'protocol',
    'settings',
    'logs',
    'queue',
    'measurements'
  )
  AND sql IS NOT NULL;
" | sqlite3 "$DST_DB"

# Copy data only for protocol and settings
sqlite3 "$DST_DB" "
ATTACH '$SRC_DB' AS src;

INSERT INTO protocol
SELECT * FROM src.protocol;

INSERT INTO settings
SELECT * FROM src.settings;

DETACH src;
"

# Preserve AUTOINCREMENT counters so IDs do not restart.
if [ "$(sqlite3 -noheader -init /dev/null "$SRC_DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='sqlite_sequence';")" -gt 0 ]; then
sqlite3 "$DST_DB" "
ATTACH '$SRC_DB' AS src;

INSERT OR REPLACE INTO sqlite_sequence(name, seq)
SELECT name, seq
FROM src.sqlite_sequence
WHERE name IN (
  'protocol',
  'settings',
  'logs',
  'queue',
  'measurements'
);

DETACH src;
"
fi

# Set correct permissions
chmod 666 "$DST_DB"

# give user further instructions
echo "To remove the old database and put the new one in place use:"
echo "mv -f \"$DST_DB\" \"$SRC_DB\""
