package controller

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/badoux/goscraper"
	"github.com/gin-gonic/gin"
	"github.com/silverswords/mark/pkg/mark/model/mysql"
	tag "github.com/silverswords/mark/pkg/tag/model/mysql"
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
			Url string `json:"url,omitempty"`
			// Title string `json:"title,omitempty"`
		}
	)

	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	s, err := goscraper.Scrape(req.Url, 5)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	err = mysql.InsertMark(mc.db, req.Url, s.Preview.Title, s.Preview.Icon)
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

	for _, mark := range marks {
		tags, err := tag.SelectTagByMarkID(mc.db, mark.ID)
		if err != nil {
			_ = c.Error(err)
			c.JSON(http.StatusBadGateway, gin.H{"status": http.StatusBadGateway})
			return
		}
		mark.Tags = tags
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
