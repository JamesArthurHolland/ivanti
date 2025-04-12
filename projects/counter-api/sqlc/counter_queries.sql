-- name: FetchCounter :one
SELECT count FROM counters WHERE id = $1;

-- name: InsertCounter :one
UPDATE counters SET count = count + 1 WHERE id = $1 RETURNING *;