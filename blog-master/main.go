package main

import (
	"github.com/astaxie/beego"
	_ "blog-master/models"
	_ "blog-master/routers"
)

func main() {
	beego.Run()
}
