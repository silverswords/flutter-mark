package controller

import (
	"database/sql"
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"

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
			Url     string `json:"url,omitempty"`
			BaseUrl string `json:"baseUrl,omitempty"`
			// Title string `json:"title,omitempty"`
		}
	)

	err := c.ShouldBindJSON(&req)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	if req.BaseUrl == "" {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	resp, err := http.Get(req.Url)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}
	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusBadRequest, gin.H{"status": http.StatusBadRequest})
		return
	}

	var (
		content struct {
			Status string `json:"status"`
			Data   struct {
				Title       string `json:"title"`
				Description string `json:"description"`
				Image       struct {
					Url string `json:"url"`
				} `json:"image"`
			} `json:"data"`
			Logo struct {
				Url string `json:"url"`
			} `json:"logo"`
		}
	)

	err = json.Unmarshal(body, &content)
	if err != nil {
		_ = c.Error(err)
		c.JSON(http.StatusAlreadyReported, gin.H{"status": http.StatusAlreadyReported, "err": "重复创建用户"})
		return
	}

	if content.Status != "success" {
		_ = c.Error(err)
		c.JSON(http.StatusAlreadyReported, gin.H{"status": http.StatusAlreadyReported, "err": "重复创建用户"})
		return
	}

	if content.Logo.Url == "" {
		content.Logo.Url = "https://cdn.nlark.com/yuque/0/2020/jpeg/anonymous/1594741657154-42e897b7-ed34-4dc7-835f-1525705d87d3.jpeg?x-oss-process=image%2Fresize%2Cm_fill%2Cw_112%2Ch_112%2Fformat%2Cpng"
	}

	err = mysql.InsertMark(mc.db, req.BaseUrl, content.Data.Title, content.Data.Description, content.Logo.Url, content.Data.Image.Url)
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
