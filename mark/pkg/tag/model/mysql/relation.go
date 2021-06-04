package mysql

import (
	"database/sql"
	"errors"
	"fmt"
)

var (
	RelationTableName = "relation"
)

type Relation struct {
	ID     uint32 `json:"id,omitempty"`
	TagID  uint32 `json:"tag_id,omitempty"`
	MarkID uint32 `json:"mark_id,omitempty"`
}

const (
	mysqlRelationCreateTable = iota
	mysqlRelationInsert
	mysqlRelationDelete
	mysqlRelationSelectByMarkID
)

var (
	errInvalidRelationInsert = errors.New("[relation] invalid insert ")
	errInvalidRelationDelete = errors.New("[relation] invalid delete ")

	relationSQLString = map[int]string{
		mysqlRelationCreateTable: fmt.Sprintf(`CREATE TABLE IF NOT EXISTS %s.%s(
		id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		tag_id INT UNSIGNED  NOT NULL DEFAULT 0 COMMENT 'label ID',
		mark_id INT UNSIGNED  NOT NULL DEFAULT 0 COMMENT 'mark ID'
	)ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_bin;`, DBName, RelationTableName),
		mysqlRelationInsert:         fmt.Sprintf(`INSERT INTO %s.%s (tag_id, mark_id) VALUES (?, ?)`, DBName, RelationTableName),
		mysqlRelationDelete:         fmt.Sprintf(`DELETE FROM %s.%s WHERE id=? LIMIT 1`, DBName, RelationTableName),
		mysqlRelationSelectByMarkID: fmt.Sprintf(`SELECT id, tag_id, mark_id FROM %s.%s WHERE mark_id = ?`, DBName, RelationTableName),
	}
)

func CreateRelationTable(db *sql.DB) error {
	_, err := db.Exec(relationSQLString[mysqlRelationCreateTable])
	if err != nil {
		return err
	}

	return nil
}

// InsertRelation insert a new relation
func InsertRelation(db *sql.DB, TagID, MarkID uint32) error {
	result, err := db.Exec(relationSQLString[mysqlRelationInsert], TagID, MarkID)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidRelationInsert
	}

	return nil
}

// DeleteRelation delete a relation
func DeleteRelation(db *sql.DB, id uint32) error {
	result, err := db.Exec(relationSQLString[mysqlRelationDelete], id)
	if err != nil {
		return err
	}

	if rows, _ := result.RowsAffected(); rows == 0 {
		return errInvalidRelationDelete
	}

	return nil
}

func SelectRelation(db *sql.DB, markID uint32) ([]*Relation, error) {
	var (
		relations []*Relation

		ID     uint32
		MarkID uint32
		TagID  uint32
	)

	rows, err := db.Query(relationSQLString[mysqlRelationSelectByMarkID], markID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &TagID, &MarkID); err != nil {
			return nil, err
		}

		relation := &Relation{
			ID:     ID,
			TagID:  TagID,
			MarkID: MarkID,
		}

		relations = append(relations, relation)
	}

	return relations, nil
}

func TxSelectRelation(db *sql.Tx, markID uint32) ([]*Relation, error) {
	var (
		relations []*Relation

		ID     uint32
		MarkID uint32
		TagID  uint32
	)

	rows, err := db.Query(relationSQLString[mysqlRelationSelectByMarkID], markID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		if err := rows.Scan(&ID, &TagID, &MarkID); err != nil {
			return nil, err
		}

		relation := &Relation{
			ID:     ID,
			TagID:  TagID,
			MarkID: MarkID,
		}

		relations = append(relations, relation)
	}

	return relations, nil
}
