package main

import (
	"github.com/astaxie/beego"
	_ "blog-master/models"
	_ "blog-master/routers"
	"github.com/astaxie/beego/logs"
)

func initLogger() {
	var consoleconfig=`{"level":7}`
	logs.SetLogger(logs.AdapterConsole,consoleconfig)
	var fileconfig = `{"filename":"log/log.log","level":7}`
	logs.SetLogger(logs.AdapterFile,fileconfig)
	//var mailconfig = `{"username":"beegotest@gmail.com",
	//					"password":"xxxxxxxx",
	//					"host":"smtp.gmail.com:587",
	//					"sendTos":["xiemengjun@gmail.com"]}`
	//logs.SetLogger(logs.AdapterMail,mailconfig)
	logs.Async(1e3)
}

func main() {
	initLogger()
	beego.Run()
}
