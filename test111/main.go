package main

import (
	_ "test111/routers"
	_ "test111/models"
	"github.com/astaxie/beego"
)

func main() {
	beego.Run()
}

