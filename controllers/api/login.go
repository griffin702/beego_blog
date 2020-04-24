package api

import (
	"beego_blog/models"
	"bytes"
	"encoding/json"
	"github.com/astaxie/beego/logs"
	"github.com/vcqr/captcha"
	"image/png"
)

type LoginController struct {
	baseController
}

// @Title GetCaptcha
// @Description 获取登录验证码图片
// @Success 200 image/png
// @router /captcha [get]
func (c *FrontController) GetCaptcha() {
	cp := captcha.NewCaptcha(120, 40, 4)
	cp.SetFontPath("conf/") //指定字体目录
	cp.SetFontName("free")  //指定字体名字
	cp.SetMode(1)           //1：设置为简单的数学算术运算公式； 其他为普通字符串
	code, img := cp.OutPut()
	//备注：code 可以根据情况存储到session，并在使用时取出验证
	c.SetSession("Captcha", code)
	buf := new(bytes.Buffer)
	if err := png.Encode(buf, img); err != nil {
		logs.Warning(err.Error())
		c.Data["json"] = RetResource(false, nil, "生成验证码图片错误")
		c.ServeJSON()
		return
	}
	c.Ctx.Output.ContentType("image/png")
	_ = c.Ctx.Output.Body(buf.Bytes())
}

// @Title PostCaptchaCheck
// @Description 验证码Check
// @Success 200 status bool, data interface{}, msg string
// @router /captcha/check [post]
func (c *FrontController) PostCaptchaCheck() {
	aul := new(models.UserJson)
	data := c.Ctx.Input.RequestBody
	err := json.Unmarshal(data, &aul)
	if err != nil {
		logs.Warning(err.Error())
		c.Data["json"] = RetResource(false, nil, "参数错误")
		c.ServeJSON()
		return
	}
	code := c.GetSession("Captcha")
	if code == nil {
		logs.Warning("Session中没有获取到验证码")
		c.Data["json"] = RetResource(false, nil, "请求异常")
		c.ServeJSON()
		return
	}
	if code != aul.Captcha {
		c.Data["json"] = RetResource(false, nil, "验证码不正确")
		c.ServeJSON()
		return
	}
	c.Data["json"] = RetResource(true, nil, "验证码正确")
	c.ServeJSON()
}
