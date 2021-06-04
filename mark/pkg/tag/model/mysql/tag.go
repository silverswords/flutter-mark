package mysql

import (
	"database/sql"
	"errors"
	"fmt"
)

var (
	DBName       = "project"
	TagTableName = "tag"
)

type Tag struct {
	ID   uint32 `json:"id,omitempty"`
	Name string `json:"name,omitempty"`
}

const (
	mysqlTagCreateDatabase = iota
	mysqlTagCreateTable
	mysqlTagInsert
	mysqlTagDelete
	mysqlTagSelect
	mysqlTagSelectByName
	mysqlTagSelectByMarkID
)

var (
	errInvalidTagInsert = errors.New("[tag] invalid insert ")
	errInvalidTagDelete = errors.New("[tag] invalid delete ")

	tagSQLString = map[int]string{
		mysqlTagCreateDatabase: fmt.Sprintf(`CREATE DATABASE IF NOT EXISTS %s`, DBName),
		mysqlTagCreateTable: fmt.Sprintf(`CREATE TABLE IF NOT EXISTS %s.%s(
		id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(512) NOT NULL DEFAULT '' COMMENT '名称'
	)ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;`, DBName, TagTableName),
		mysqlTagInsert:         fmt.Sprintf(`INSERT INTO %s.%s (name) VALUES (?)`, DBName, TagTableName),
		mysqlTagDelete:         fmt.Sprintf(`DELETE FROM %s.%s WHERE id=? LIMIT 1`, DBName, TagTableName),
		mysqlTagSelect:         fmt.Sprintf(`SELECT id, name FROM %s.%s`, DBName, TagTableName),
		mysqlTagSelectByName:   fmt.Sprintf(`SELECT id FROM %s.%s WHERE name = ?`, DBName, TagTableName),
		mysqlTagSelectByMarkID: fmt.Sprintf(`SELECT relation.id, tag.name FROM project.relation LEFT JOIN %s.%s ON tag.id = relation.tag_id WHERE relation.mark_id = ?`, DBName, TagTableName),
	}
)

func CreateDatabase(db *sql.DB) error {
	_, err := db.Exec(tagSQLString[mysqlTagCreateDatabase])
	if err != nil {
		return err
	}

	return nil
}

func CreateTable(db *sql.DB) error {
	_, err := db.Exec(tagSQLString[mysqlTagCreateTable])
	if err != nil {
		return err
	}

	return nil
}

// InsertTag insert a new tag
func InsertTag(db *sql.DB, name string) (uint32, error) {
	result, err := db.Exec(tagSQLString[mysqlTagInsert], name)
	if err != nil {
		return 0, err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return 0, errInvalidTagInsert
	}

	id, err := result.LastInsertId()
	if err != nil {
		return 0, err
	}

	return uint32(id), err
}

// DeleteTag delete a tag
func DeleteTag(db *sql.DB, id uint32) error {
	result, err := db.Exec(tagSQLString[mysqlTagDelete], id)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidTagDelete
	}

	return nil
}

func SelectTag(db *sql.DB) ([]*Tag, error) {
	var (
		tags []*Tag

		ID   uint32
		Name string
	)

	rows, err := db.Query(tagSQLString[mysqlTagSelect])
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &Name); err != nil {
			return nil, err
		}

		tag := &Tag{
			ID:   ID,
			Name: Name,
		}

		tags = append(tags, tag)
	}

	return tags, nil
}

func SelectTagByName(db *sql.DB, name string) (uint32, error) {
	var (
		ID uint32
	)

	row := db.QueryRow(tagSQLString[mysqlTagSelectByName], name)
	if err := row.Err(); err != nil {
		return 0, err
	}

	if err := row.Scan(&ID); err != nil {
		return 0, err
	}

	return ID, nil
}

func SelectTagByMarkID(db *sql.DB, id uint32) ([]*Tag, error) {
	var (
		tags []*Tag

		ID   uint32
		Name string
	)

	rows, err := db.Query(tagSQLString[mysqlTagSelectByMarkID], id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &Name); err != nil {
			return nil, err
		}

		tag := &Tag{
			ID:   ID,
			Name: Name,
		}

		tags = append(tags, tag)
	}

	return tags, nil
}
