package controller

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/silverswords/mark/pkg/tag/model/mysql"
)

type TagController struct {
	db *sql.DB
}

func New(db *sql.DB) *TagController {
	return &TagController{
		db: db,
	}
}

func (tc *TagController) RegistRouter(r gin.IRouter) {
	if r == nil {
		log.Fatal("[InitRouter] server is nil")
	}

	err := mysql.CreateTable(tc.db)
	if err != nil {
		log.Fatal(err)
	}

	err = mysql.CreateRelationTable(tc.db)
	if err != nil {
		log.Fatal(err)
	}

	r.POST("/insert", tc.insert)
	r.POST("/delete", tc.delete)
}

func (tc *TagController) insert(c *gin.Context) {
	var (
		req struct {
			MarkID  uint32 `json:"mark_id" binding:"required"`
			TagName string `json:"tag_name" binding:"required"`
		}
	)

	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	tagID, err := mysql.SelectTagByName(tc.db, req.TagName)
	if err != nil {
		if err != sql.ErrNoRows {
			_ = c.Error(err)
			c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
			return
		}
	}

	if tagID == 0 {
		tagID, err = mysql.InsertTag(tc.db, req.TagName)
		if err != nil {
			log.Println(2)
			_ = c.Error(err)
			c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
			return
		}
	}

	err = mysql.InsertRelation(tc.db, tagID, req.MarkID)
	if err != nil {
		log.Println(3)
		_ = c.Error(err)
		c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}

func (tc *TagController) delete(c *gin.Context) {
	var (
		req struct {
			ID uint32 `json:"id" binding:"required"`
		}
	)

	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	err = mysql.DeleteRelation(tc.db, req.ID)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}
