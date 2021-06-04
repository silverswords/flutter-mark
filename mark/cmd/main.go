package main

import (
	"database/sql"
	"log"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"

	mark "github.com/silverswords/mark/pkg/mark/controller"
)

const (
	markRouterGroup = "/api/v1/mark"
)

func main() {
	gin.ForceConsoleColor()
	gin.SetMode(gin.DebugMode)

	router := gin.Default()

	db, err := sql.Open("mysql", "root:123456@tcp(0.0.0.0:3306)/project?charset=utf8mb4&parseTime=true&loc=Local")
	if err != nil {
		panic(err)
	}

	markController := mark.New(db)
	markController.RegistRouter(router.Group(markRouterGroup))

	log.Fatal(router.Run("0.0.0.0:10001"))
}
