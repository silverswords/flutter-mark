package mysql

import (
	"database/sql"
	"errors"
	"fmt"

	tag "github.com/silverswords/mark/pkg/tag/model/mysql"
)

var (
	DBName        = "project"
	MarkTableName = "mark"
)

type Mark struct {
	ID       uint32     `json:"id,omitempty"`
	Url      string     `json:"url,omitempty"`
	Title    string     `json:"title,omitempty"`
	SubTitle string     `json:"sub_title, omitempty"`
	Icon     string     `json:"icon,omitempty"`
	Tags     []*tag.Tag `json:"tags,omitempty"`
	Picture  string     `json:"picture,omitempty"`
}

const (
	mysqlMarkCreateDatabase = iota
	mysqlMarkCreateTable
	mysqlMarkInsert
	mysqlMarkDelete
	mysqlMarkSelect
)

var (
	errInvalidMarkInsert = errors.New("[mark] invalid insert ")
	errInvalidMarkDelete = errors.New("[mark] invalid delete ")

	markSQLString = map[int]string{
		mysqlMarkCreateDatabase: fmt.Sprintf(`CREATE DATABASE IF NOT EXISTS %s`, DBName),
		mysqlMarkCreateTable: fmt.Sprintf(`CREATE TABLE IF NOT EXISTS %s.%s(
		id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		url VARCHAR(512) NOT NULL DEFAULT '' COMMENT '地址',
		title VARCHAR(512) NOT NULL DEFAULT '' COMMENT '标题',
		sub_title VARCHAR(512) NOT NULL DEFAULT '' COMMENT '副标题',
		icon VARCHAR(512) NOT NULL DEFAULT '' COMMENT '图标',
		picture VARCHAR(512) NOT NULL DEFAULT '' COMMENT '图片'
	)ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;`, DBName, MarkTableName),
		mysqlMarkInsert: fmt.Sprintf(`INSERT INTO %s.%s (url, title, sub_title, icon, picture) VALUES (?, ?, ?,?,?)`, DBName, MarkTableName),
		mysqlMarkDelete: fmt.Sprintf(`DELETE FROM %s.%s WHERE id=? LIMIT 1`, DBName, MarkTableName),
		mysqlMarkSelect: fmt.Sprintf(`SELECT id, url, title,sub_title, icon,picture FROM %s.%s`, DBName, MarkTableName),
	}
)

func CreateDatabase(db *sql.DB) error {
	_, err := db.Exec(markSQLString[mysqlMarkCreateDatabase])
	if err != nil {
		return err
	}

	return nil
}

func CreateTable(db *sql.DB) error {
	_, err := db.Exec(markSQLString[mysqlMarkCreateTable])
	if err != nil {
		return err
	}

	return nil
}

// InsertMark insert a new mark
func InsertMark(db *sql.DB, url, title, subTitle, icon, picture string) error {
	result, err := db.Exec(markSQLString[mysqlMarkInsert], url, title, subTitle, icon, picture)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidMarkInsert
	}

	return nil
}

// DeleteMark delete a mark
func DeleteMark(db *sql.DB, id uint32) error {
	result, err := db.Exec(markSQLString[mysqlMarkDelete], id)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidMarkDelete
	}

	return nil
}

func SelectMark(db *sql.DB) ([]*Mark, error) {
	var (
		marks []*Mark

		ID       uint32
		Url      string
		Title    string
		SubTitle string
		Icon     string
		Picture  string
	)

	rows, err := db.Query(markSQLString[mysqlMarkSelect])
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &Url, &Title, &SubTitle, &Icon, &Picture); err != nil {
			return nil, err
		}

		mark := &Mark{
			ID:       ID,
			Url:      Url,
			Title:    Title,
			SubTitle: SubTitle,
			Icon:     Icon,
			Picture:  Picture,
		}

		marks = append(marks, mark)
	}

	return marks, nil
}
