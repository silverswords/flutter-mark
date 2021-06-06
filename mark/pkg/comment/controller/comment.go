package controller

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/silverswords/mark/pkg/comment/model/mysql"
)

type CommentController struct {
	db *sql.DB
}

func New(db *sql.DB) *CommentController {
	return &CommentController{
		db: db,
	}
}

func (mc *CommentController) RegistRouter(r gin.IRouter) {
	if r == nil {
		log.Fatal("[InitRouter] server is nil")
	}

	err := mysql.CreateTable(mc.db)
	if err != nil {
		log.Fatal(err)
	}

	r.GET("/list", mc.listComment)

	r.POST("/insert", mc.insert)
	r.POST("/delete", mc.delete)
}

func (mc *CommentController) insert(c *gin.Context) {
	var (
		req struct {
			MarkID  uint32 `json:"url,omitempty"`
			Content string `json:"baseUrl,omitempty"`
			// Title string `json:"title,omitempty"`
		}
	)
	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	err = mysql.InsertComment(mc.db, req.MarkID, req.Content)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusAlreadyReported, gin.H{"status": http.StatusAlreadyReported, "err": "重复创建用户"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}

func (mc *CommentController) listComment(c *gin.Context) {
	var (
		req struct {
			MarkID uint32 `json:"url,omitempty"`
		}
	)
	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	comments, err := mysql.SelectComment(mc.db, req.MarkID)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusAlreadyReported, gin.H{"status": http.StatusAlreadyReported, "err": "重复创建用户"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "comments": comments})
}

func (mc *CommentController) delete(c *gin.Context) {
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

	err = mysql.DeleteComment(mc.db, req.ID)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusInternalServerError, gin.H{"status": http.StatusInternalServerError})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK})
}
