package controllers

import (
	"github.com/astaxie/beego"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	c.Data["Website"] = "inana.top"
	c.Data["Email"] = "117976509@qq.com"
	c.TplName = "index.tpl"
}

func (c *MainController) HelloSitepoint() {
	c.Data["Website"] = "inana.top"
	c.Data["Email"] = "117976509@qq.com"
	c.Data["EmailName"] = "武鋆"
	c.Data["Id"] = c.Ctx.Input.Param(":id")
	c.TplName = "default/hello-sitepoint.tpl"
}

func (c *MainController) ArticleController() {
	c.Data["Website"] = "inana.top"
	c.Data["Email"] = "117976509@qq.com"
	c.Data["EmailName"] = "武鋆"
	c.TplName = "admin/article.tpl"
}