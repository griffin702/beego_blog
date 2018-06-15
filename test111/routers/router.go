package routers

import (
	"test111/controllers"
	"github.com/astaxie/beego"
	"github.com/beego/admin"
)

func init() {
	admin.Run()
    beego.Router("/", &controllers.MainController{})
	beego.Router("/hello-world/:id(\\d+)", &controllers.MainController{}, "get:HelloSitepoint")
	beego.Router("/article/index", &controllers.MainController{}, "*:ArticleController")
}
