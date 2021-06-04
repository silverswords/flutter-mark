package controller

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/silverswords/mark/pkg/mark/model/mysql"
)

type MarkController struct {
	db *sql.DB
}

func New(db *sql.DB) *MarkController {
	return &MarkController{
		db: db,
	}
}

func (mc *MarkController) RegistRouter(r gin.IRouter) {
	if r == nil {
		log.Fatal("[InitRouter] server is nil")
	}

	err := mysql.CreateDatabase(mc.db)
	if err != nil {
		log.Fatal(err)
	}

	err = mysql.CreateTable(mc.db)
	if err != nil {
		log.Fatal(err)
	}

	r.GET("/list", mc.listMark)

	r.POST("/insert", mc.insert)
	r.POST("/delete", mc.delete)
}

func (mc *MarkController) insert(c *gin.Context) {
	var (
		req struct {
			Url   string `json:"url,omitempty"`
			Title string `json:"title,omitempty"`
		}
	)

	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	err = mysql.InsertMark(mc.db, req.Url, req.Title)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusAlreadyReported, gin.H{"status": http.StatusAlreadyReported, "err": "重复创建用户"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}

func (mc *MarkController) listMark(c *gin.Context) {
	marks, err := mysql.SelectMark(mc.db)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "marks": marks})
}

func (mc *MarkController) delete(c *gin.Context) {
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

	err = mysql.DeleteMark(mc.db, req.ID)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": http.StatusInternalServerError})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}
