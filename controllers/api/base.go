package api

import "github.com/astaxie/beego"

type baseController struct {
	beego.Controller
}

type RetJson struct {
	Status bool        `json:"status"`
	Msg    interface{} `json:"msg"`
	Data   interface{} `json:"data"`
}

func RetResource(status bool, data interface{}, msg string) (apijson *RetJson) {
	apijson = &RetJson{Status: status, Data: data, Msg: msg}
	return
}
