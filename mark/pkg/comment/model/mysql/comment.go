package mysql

import (
	"database/sql"
	"errors"
	"fmt"
)

var (
	DBName    = "project"
	TableName = "comment"
)

type Comment struct {
	ID      uint32 `json:"id,omitempty"`
	MarkID  uint32 `json:"mark_id,omitempty"`
	Content string `json:"content,omitempty"`
}

const (
	mysqlCommentCreateTable = iota
	mysqlCommentInsert
	mysqlCommentDelete
	mysqlCommentSelectByMarkID
)

var (
	errInvalidCommentInsert = errors.New("[comment] invalid insert ")
	errInvalidCommentDelete = errors.New("[comment] invalid delete ")

	commentSQLString = map[int]string{
		mysqlCommentCreateTable: fmt.Sprintf(`CREATE TABLE IF NOT EXISTS %s.%s(
		id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		mark_id INT UNSIGNED  NOT NULL DEFAULT 0 COMMENT 'mark ID',
		content TEXT NOT NULL DEFAULT '' COMMENT '标题',
	)ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;`, DBName, TableName),
		mysqlCommentInsert:         fmt.Sprintf(`INSERT INTO %s.%s (mark_id, content) VALUES (?, ?)`, DBName, TableName),
		mysqlCommentDelete:         fmt.Sprintf(`DELETE FROM %s.%s WHERE id=? LIMIT 1`, DBName, TableName),
		mysqlCommentSelectByMarkID: fmt.Sprintf(`SELECT id, mark_id, content FROM %s.%s WHERE mark_id = ?`, DBName, TableName),
	}
)

func CreateTable(db *sql.DB) error {
	_, err := db.Exec(commentSQLString[mysqlCommentCreateTable])
	if err != nil {
		return err
	}

	return nil
}

// InsertComment insert a new comment
func InsertComment(db *sql.DB, mark_id uint32, content string) error {
	result, err := db.Exec(commentSQLString[mysqlCommentInsert], mark_id, content)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidCommentInsert
	}

	return nil
}

// DeleteComment delete a comment
func DeleteComment(db *sql.DB, id uint32) error {
	result, err := db.Exec(commentSQLString[mysqlCommentDelete], id)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidCommentDelete
	}

	return nil
}

func SelectComment(db *sql.DB, markID uint32) ([]*Comment, error) {
	var (
		comments []*Comment

		ID      uint32
		MarkID  uint32
		Content string
	)

	rows, err := db.Query(commentSQLString[mysqlCommentSelectByMarkID], markID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &MarkID, &Content); err != nil {
			return nil, err
		}

		comment := &Comment{
			ID: ID,
		}

		comments = append(comments, comment)
	}

	return comments, nil
}
