package main

import (
	_ "beego_blog/controllers/ipfilter"
	_ "beego_blog/models"
	_ "beego_blog/routers"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
	"github.com/astaxie/beego/logs"
	"strconv"
	"strings"
)

func initLogger() {
	var consoleconfig = `{"level":7}`
	logs.SetLogger(logs.AdapterConsole, consoleconfig)
	var fileconfig = `{"filename":"log/log.log","level":7}`
	logs.SetLogger(logs.AdapterFile, fileconfig)
	//var mailconfig = `{"username":"beegotest@gmail.com",
	//					"password":"xxxxxxxx",
	//					"host":"smtp.gmail.com:587",
	//					"sendTos":["xiemengjun@gmail.com"]}`
	//logs.SetLogger(logs.AdapterMail,mailconfig)
	logs.Async(1e3)
}

//添加自定义模板函数
func hasPermission(permissionlist map[string]int, value int) (out bool) {
	for _, id := range permissionlist {
		if value == id {
			return true
		}
	}
	return false
}

func hasPermissionstr(permissionlist string, value int) (out bool) {
	for _, id := range strings.Split(permissionlist, "|") {
		if id == strconv.Itoa(value) {
			return true
		}
	}
	return false
}

func swaggerNoCache(ctx *context.Context) {
	ctx.Output.Header("Cache-Control", "no-cache, no-store, must-revalidate")
	ctx.Output.Header("Pragma", "no-cache")
	ctx.Output.Header("Expires", "0")
}

func main() {
	initLogger()
	beego.AddFuncMap("haspermission", hasPermission)
	beego.AddFuncMap("haspermissionstr", hasPermissionstr)
	if beego.BConfig.RunMode == "dev" {
		beego.BConfig.WebConfig.DirectoryIndex = true
		beego.BConfig.WebConfig.StaticDir["/swagger"] = "swagger"
		beego.InsertFilter("/swagger/swagger.json", beego.BeforeStatic, swaggerNoCache)
	}
	beego.Run()
}
