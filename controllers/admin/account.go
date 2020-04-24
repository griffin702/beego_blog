package admin

import (
	"beego_blog/models"
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/validation"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type AccountController struct {
	baseController
}

//登录
func (this *AccountController) Login() {
	aul := new(models.UserJson)
	data := this.Ctx.Input.RequestBody
	if err := json.Unmarshal(data, &aul); err != nil {
		logs.Warning(err.Error())
		this.Data["json"] = RetResource(false, nil, "参数错误")
		this.ServeJSON()
		return
	}
	code := this.GetSession("Captcha")
	if code == nil {
		logs.Warning("Session中没有获取到验证码")
		this.Data["json"] = RetResource(false, nil, "请求异常")
		this.ServeJSON()
		return
	}
	if code != aul.Captcha {
		logs.Warning(fmt.Sprintf("sessCaptcha:%s,inputCaptcha:%s", code, aul.Captcha))
		this.Data["json"] = RetResource(false, nil, "验证码不正确")
		this.ServeJSON()
		return
	}
	if aul.Username == "" {
		this.Data["json"] = RetResource(false, nil, "请输入帐号")
		this.ServeJSON()
		return
	}
	if aul.Password == "" {
		this.Data["json"] = RetResource(false, nil, "请输入密码")
		this.ServeJSON()
		return
	}
	var user models.User
	user.Username = aul.Username
	if user.Read("username") != nil || user.Password != models.Md5([]byte(aul.Password)) {
		this.Data["json"] = RetResource(false, nil, "帐号或密码错误")
		this.ServeJSON()
		return
	}
	if user.Active == 0 {
		this.Data["json"] = RetResource(false, nil, "该帐号未激活")
		this.ServeJSON()
		return
	}
	user.Logincount += 1
	user.Lastip = this.getClientIp()
	user.Lastlogin = this.getTime()
	_ = user.Update()
	authkey := models.Md5([]byte(this.getClientIp() + "|" + user.Password))
	this.Ctx.SetCookie("auth", strconv.FormatInt(user.Id, 10)+"|"+authkey, 86400)
	this.SetSession("userId", user.Id)
	this.SetSession("userName", user.Username)
	logs.Info(fmt.Sprintf("userid:%d,username:%s,登录成功", user.Id, user.Username))
	this.Data["json"] = RetResource(true, nil, "登录成功")
	this.ServeJSON()
}

//注册
func (this *AccountController) Register() {
	aul := new(models.UserJson)
	data := this.Ctx.Input.RequestBody
	if err := json.Unmarshal(data, &aul); err != nil {
		logs.Warning(err.Error())
		this.Data["json"] = RetResource(false, nil, "参数错误")
		this.ServeJSON()
		return
	}
	code := this.GetSession("Captcha")
	if code == nil {
		logs.Warning("Session中没有获取到验证码")
		this.Data["json"] = RetResource(false, nil, "请求异常")
		this.ServeJSON()
		return
	}
	if code != aul.Captcha {
		logs.Warning(fmt.Sprintf("sessCaptcha:%s,inputCaptcha:%s", code, aul.Captcha))
		this.Data["json"] = RetResource(false, nil, "验证码不正确")
		this.ServeJSON()
		return
	}
	valid := validation.Validation{}
	if v := valid.Required(aul.Username1, "username"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "请输入用户名")
		this.ServeJSON()
		return
	}
	if v := valid.MaxSize(aul.Username1, 30, "username"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "用户名长度不能大于15个字符")
		this.ServeJSON()
		return
	}
	if !checkUsername(aul.Username1) {
		this.Data["json"] = RetResource(false, nil, "输入的用户名不符合要求(仅允许字母开头,并以字母、数字、-、_组成)")
		this.ServeJSON()
		return
	}
	if v := valid.Required(aul.Nickname, "nickname"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "请输入昵称")
		this.ServeJSON()
		return
	}
	if v := valid.MaxSize(aul.Nickname, 30, "nickname"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "昵称长度不能大于15个字符")
		this.ServeJSON()
		return
	}
	if v := valid.Required(aul.Password1, "password"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "请输入密码")
		this.ServeJSON()
		return
	}
	if !checkPassword(aul.Password1) {
		this.Data["json"] = RetResource(false, nil, "输入的密码不符合要求(仅允许字母、数字和部分符号组成)")
		this.ServeJSON()
		return
	}
	if v := valid.Required(aul.Password2, "password2"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "请再次输入密码")
		this.ServeJSON()
		return
	}
	if aul.Password1 != aul.Password2 {
		this.Data["json"] = RetResource(false, nil, "两次输入的密码不一致")
		this.ServeJSON()
		return
	}
	if !checkPassword(aul.Password2) {
		this.Data["json"] = RetResource(false, nil, "输入的密码不符合要求(仅允许字母、数字和部分符号组成)")
		this.ServeJSON()
		return
	}
	if v := valid.Required(aul.Email, "email"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "请输入email地址")
		this.ServeJSON()
		return
	}
	if v := valid.Email(aul.Email, "email"); !v.Ok {
		this.Data["json"] = RetResource(false, nil, "Email无效")
		this.ServeJSON()
		return
	}
	var user models.User
	err := user.Query().Filter("username", aul.Username1).One(&user)
	if err == nil {
		logs.Warning(fmt.Sprintf("用户名:%s 已被注册", aul.Username1))
		this.Data["json"] = RetResource(false, nil, fmt.Sprintf("用户名:%s 已被注册", aul.Username1))
		this.ServeJSON()
		return
	}
	err = user.Query().Filter("nickname", aul.Nickname).One(&user)
	if err == nil {
		logs.Warning(fmt.Sprintf("昵称:%s 已被使用", aul.Nickname))
		this.Data["json"] = RetResource(false, nil, fmt.Sprintf("昵称:%s 已被使用", aul.Nickname))
		this.ServeJSON()
		return
	}
	user.Username = aul.Username1
	user.Password = models.Md5([]byte(aul.Password1))
	user.Email = aul.Email
	user.Active = int8(1)
	user.Upcount = int64(3)
	user.Lastip = this.getClientIp()
	user.Avator = "/static/upload/default/user-default-60x60.png"
	user.Nickname = aul.Nickname
	if err := user.Insert(); err != nil {
		logs.Warning(err.Error())
		this.Data["json"] = RetResource(false, nil, err.Error())
		this.ServeJSON()
		return
	}
	authkey := models.Md5([]byte(this.getClientIp() + "|" + user.Password))
	this.Ctx.SetCookie("auth", strconv.FormatInt(user.Id, 10)+"|"+authkey, 86400)
	this.SetSession("userId", user.Id)
	this.SetSession("userName", user.Username)
	logs.Info(fmt.Sprintf("userid:%d,username:%s,注册成功", user.Id, user.Username))
	this.Data["json"] = RetResource(true, nil, "注册成功")
	this.ServeJSON()
}

//退出登录
func (this *AccountController) Logout() {
	this.DestroySession()
	this.userid = 0
	this.username = ""
	this.Ctx.SetCookie("auth", "")
	this.showmsg("期待与您下一次遇见...")
}

//资料修改
func (this *AccountController) Profile() {
	user := models.User{Id: this.userid}
	if err := user.Read(); err != nil {
		this.showmsg(err.Error())
	}
	lastavator := user.Avator
	if this.Ctx.Request.Method == "POST" {
		errmsg := make(map[string]string)
		password := strings.TrimSpace(this.GetString("password"))
		newpassword := strings.TrimSpace(this.GetString("newpassword"))
		newpassword2 := strings.TrimSpace(this.GetString("newpassword2"))
		avator := strings.TrimSpace(this.GetString("avator"))
		nickname := strings.TrimSpace(this.GetString("nickname"))
		if avator == "" {
			avator = "/static/upload/default/user-default-60x60.png"
		}
		if avator != lastavator {
			_ = models.Cache.Delete("newcomments")
			if user.Upcount > 0 {
				user.Upcount--
			}
			if !this.Isdefaultsrc(lastavator) {
				_ = os.Remove("." + lastavator)
			}
		}
		updated := false
		valid := validation.Validation{}
		if v := valid.Required(nickname, "nickname"); !v.Ok {
			errmsg["nickname"] = "请输入昵称"
		} else if v := valid.MaxSize(nickname, 15, "nickname"); !v.Ok {
			errmsg["nickname"] = "昵称长度不能大于15个字符"
		}
		var user1 models.User
		err := user1.Query().Filter("nickname", nickname).One(&user1)
		if err == nil && user1.Id != user.Id {
			errmsg["nickname"] = fmt.Sprintf("昵称:%s 已被使用", nickname)
		}
		if nickname != user.Nickname && len(errmsg) == 0 {
			user.Nickname = nickname
			_ = user.Update("nickname")
			updated = true
		}
		if avator != user.Avator && len(errmsg) == 0 {
			user.Avator = avator
			_ = user.Update("avator", "upcount")
			updated = true
		}
		if newpassword != "" {
			if password == "" || models.Md5([]byte(password)) != user.Password {
				errmsg["password"] = "当前密码错误"
			} else if len(newpassword) < 6 {
				errmsg["newpassword"] = "密码长度不能少于6个字符"
			} else if newpassword != newpassword2 {
				errmsg["newpassword2"] = "两次输入的密码不一致"
			}
			if len(errmsg) == 0 {
				user.Password = models.Md5([]byte(newpassword))
				_ = user.Update("password")
				updated = true
			}
		}
		this.Data["updated"] = updated
		this.Data["errmsg"] = errmsg
	}
	this.Data["user"] = user
	this.display()
}

func checkUsername(username string) (b bool) {
	if ok, _ := regexp.MatchString("^[a-zA-Z]([a-zA-Z0-9-_]{4,14})+$", username); !ok {
		return false
	}
	return true
}

func checkPassword(password string) (b bool) {
	if ok, _ := regexp.MatchString("^[a-zA-Z0-9[:punct:]]{4,19}$", password); !ok {
		return false
	}
	return true
}

func MakePermissionList(user models.User) (permissionList map[string]int) {
	cacheName := fmt.Sprintf("userPermissionList_%d", user.Id)
	if !models.Cache.IsExist(cacheName) {
		//允许任何人默认拥有访问account，comments的权限
		permissionList = map[string]int{"account": 0, "comments": 0}
		var permission models.Permission
		for _, id := range strings.Split(user.Permission, "|") {
			err := permission.Query().Filter("id", id).One(&permission)
			if err == nil {
				permissionList[permission.Name] = permission.Id
			}
		}
		if _, ok := permissionList["fileupload"]; !ok && user.Upcount > 0 {
			permissionList["fileupload"] = 0
		}
		permissionList["index"] = 0
		_ = models.Cache.Put(cacheName, permissionList)
	}
	permissionList = models.Cache.Get(cacheName).(map[string]int)
	return
}
