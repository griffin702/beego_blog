package routers

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context/param"
)

func init() {

	beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"] = append(beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"],
		beego.ControllerComments{
			Method:           "GetCaptcha",
			Router:           `/captcha`,
			AllowHTTPMethods: []string{"get"},
			MethodParams:     param.Make(),
			Filters:          nil,
			Params:           nil})

	beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"] = append(beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"],
		beego.ControllerComments{
			Method:           "PostCaptchaCheck",
			Router:           `/captcha/check`,
			AllowHTTPMethods: []string{"post"},
			MethodParams:     param.Make(),
			Filters:          nil,
			Params:           nil})

	beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"] = append(beego.GlobalControllerRouter["beego_blog/controllers/api:FrontController"],
		beego.ControllerComments{
			Method:           "GetTest",
			Router:           `/test/:id`,
			AllowHTTPMethods: []string{"get"},
			MethodParams:     param.Make(),
			Filters:          nil,
			Params:           nil})

}
