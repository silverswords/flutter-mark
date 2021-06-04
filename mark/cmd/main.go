package main

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"

	mark "github.com/silverswords/mark/pkg/mark/controller"
	tag "github.com/silverswords/mark/pkg/tag/controller"
)

const (
	markRouterGroup = "/api/v1/mark"
	tagRouterGroup  = "/api/v1/tag"
)

func main() {
	gin.ForceConsoleColor()
	gin.SetMode(gin.DebugMode)

	router := gin.Default()
	router.Use(Cors())
	db, err := sql.Open("mysql", "root:123456@tcp(192.168.0.35:3306)/project?charset=utf8mb4&parseTime=true&loc=Local")
	if err != nil {
		panic(err)
	}

	markController := mark.New(db)
	tagController := tag.New(db)

	markController.RegistRouter(router.Group(markRouterGroup))
	tagController.RegistRouter(router.Group(tagRouterGroup))

	log.Fatal(router.Run("0.0.0.0:10001"))
}

func Cors() gin.HandlerFunc {
	return func(c *gin.Context) {
		method := c.Request.Method

		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE, UPDATE")
		c.Header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept, Authorization")
		c.Header("Access-Control-Expose-Headers", "Content-Length, Access-Control-Allow-Origin, Access-Control-Allow-Headers, Cache-Control, Content-Language, Content-Type")
		c.Header("Access-Control-Allow-Credentials", "true")

		if method == "OPTIONS" {
			c.AbortWithStatus(http.StatusNoContent)
		}

		c.Next()
	}
}
