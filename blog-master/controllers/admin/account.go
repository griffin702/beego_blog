package admin

import (
	"blog-master/models"
	"strconv"
	"strings"
	"github.com/astaxie/beego/validation"
	"fmt"
	"regexp"
	"os"
)

type AccountController struct {
	baseController
}

//登录
func (this *AccountController) Login() {
	if this.GetString("dosubmit") == "yes" {
		username := strings.TrimSpace(this.GetString("username"))
		password := strings.TrimSpace(this.GetString("password"))
		remember := this.GetString("remember")
		if username != "" && password != "" {
			var user models.User
			user.Username = username
			if user.Read("username") != nil || user.Password != models.Md5([]byte(password)) {
				this.Data["errmsg"] = "帐号或密码错误"
			} else if user.Active == 0 {
				this.Data["errmsg"] = "该帐号未激活"
			} else {
				user.Logincount += 1
				user.Lastip = this.getClientIp()
				user.Lastlogin = this.getTime()
				user.Update()
				authkey := models.Md5([]byte(this.getClientIp() + "|" + user.Password))
				if remember == "yes" {
					this.Ctx.SetCookie("auth", strconv.FormatInt(user.Id, 10)+"|"+authkey, 7*86400)
				} else {
					this.Ctx.SetCookie("auth", strconv.FormatInt(user.Id, 10)+"|"+authkey)
				}
				this.Redirect(this.Ctx.Request.Referer(), 302)
			}
		} else if username == "" {
			this.Data["errmsg"] = "请输入帐号"
		} else if password == "" {
			this.Data["errmsg"] = "请输入密码"
		}
	}
	this.TplName = "admin/account_login.html"
}

//注册
func (this *AccountController) Register() {
	input := make(map[string]string)
	errmsg := make(map[string]string)
	if this.Ctx.Request.Method == "POST" && this.GetString("dosubmit") == "yes" {
		username1 := strings.TrimSpace(this.GetString("username1"))
		password1 := strings.TrimSpace(this.GetString("password1"))
		password2 := strings.TrimSpace(this.GetString("password2"))
		email := strings.TrimSpace(this.GetString("email"))
		nickname := strings.TrimSpace(this.GetString("nickname"))
		input["username1"] = username1
		input["password1"] = password1
		input["password2"] = password2
		input["email"] = email
		input["nickname"] = nickname
		valid := validation.Validation{}
		if v := valid.Required(username1, "username"); !v.Ok {
			errmsg["username"] = "请输入用户名"
		} else if v := valid.MaxSize(username1, 15, "username"); !v.Ok {
			errmsg["username"] = "用户名长度不能大于15个字符"
		} else if !checkUsername(username1) {
			errmsg["username"] = "输入的用户名不符合要求(仅允许字母开头,并以字母、数字、-、_组成)"
		}
		var user models.User
		err := user.Query().Filter("username", username1).One(&user)
		if err == nil {
			errmsg["username"] = fmt.Sprintf("用户名:%s 已被注册", username1)
		}
		if v := valid.Required(nickname, "nickname"); !v.Ok {
			errmsg["nickname"] = "请输入昵称"
		} else if v := valid.MaxSize(nickname, 15, "nickname"); !v.Ok {
			errmsg["nickname"] = "昵称长度不能大于15个字符"
		}
		err = user.Query().Filter("nickname", nickname).One(&user)
		if err == nil {
			errmsg["nickname"] = fmt.Sprintf("昵称:%s 已被使用", nickname)
		}
		if v := valid.Required(password1, "password"); !v.Ok {
			errmsg["password"] = "请输入密码"
		} else if !checkPassword(password1) {
			errmsg["password1"] = "输入的密码不符合要求(仅允许字母、数字和部分符号组成)"
		}
		if v := valid.Required(password2, "password2"); !v.Ok {
			errmsg["password2"] = "请再次输入密码"
		} else if password1 != password2 {
			errmsg["password2"] = "两次输入的密码不一致"
		} else if !checkPassword(password2) {
			errmsg["password2"] = "输入的密码不符合要求(仅允许字母、数字和部分符号组成)"
		}
		if v := valid.Required(email, "email"); !v.Ok {
			errmsg["email"] = "请输入email地址"
		} else if v := valid.Email(email, "email"); !v.Ok {
			errmsg["email"] = "Email无效"
		}
		if len(errmsg) == 0 {
			var user models.User
			user.Username = username1
			user.Password = models.Md5([]byte(password1))
			user.Email = email
			user.Active = int8(1)
			user.Upcount = int64(3)
			user.Lastip = this.getClientIp()
			user.Avator = "/static/upload/default/user-default-60x60.png"
			user.Nickname = nickname
			if err := user.Insert(); err != nil {
				this.showmsg(err.Error())
			} else {
				this.showmsg("注册成功，请使用该账号登录")
			}
			this.Redirect(this.Ctx.Request.Referer(), 302)
		}
	}
	this.Data["input"] = input
	this.Data["errmsg"] = errmsg
	this.TplName = "admin/account_register.html"
}

//退出登录
func (this *AccountController) Logout() {
	this.Ctx.SetCookie("auth", "")
	this.Redirect(this.Ctx.Request.Referer(), 302)
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
			models.Cache.Delete("newcomments")
			if user.Upcount > 0 {
				user.Upcount--
			}
			if !this.Isdefaultsrc(lastavator) {
				os.Remove("." + lastavator)
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
			user.Update("nickname")
			updated = true
		}
		if avator != user.Avator && len(errmsg) == 0 {
			user.Avator = avator
			user.Update("avator", "upcount")
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
				user.Update("password")
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
