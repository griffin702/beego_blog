package admin

import (
	"beego_blog/models"
	"fmt"
	"github.com/astaxie/beego/validation"
	"os"
	"strings"
)

type UserController struct {
	baseController
}

//用户列表
func (this *UserController) List() {
	var page int64
	var pagesize int64 = 10
	var list []*models.User
	var user models.User

	if page, _ = this.GetInt64("page"); page < 1 {
		page = 1
	}
	offset := (page - 1) * pagesize

	count, _ := user.Query().Count()
	if count > 0 {
		user.Query().OrderBy("-id").Limit(pagesize, offset).All(&list)
	}

	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(page, count, pagesize, "/admin/user/list?page=%d").ToString()
	this.display()
}

//添加用户
func (this *UserController) Add() {
	input := make(map[string]string)
	errmsg := make(map[string]string)
	if this.Ctx.Request.Method == "POST" {
		username := strings.TrimSpace(this.GetString("username"))
		password := strings.TrimSpace(this.GetString("password"))
		password2 := strings.TrimSpace(this.GetString("password2"))
		email := strings.TrimSpace(this.GetString("email"))
		avator := strings.TrimSpace(this.GetString("avator"))
		nickname := strings.TrimSpace(this.GetString("nickname"))
		if avator == "" {
			avator = "/static/upload/default/user-default-60x60.png"
		}
		permissionlist := strings.TrimSpace(
			this.GetString("permission1") + "|" +
				this.GetString("permission2") + "|" +
				this.GetString("permission3") + "|" +
				this.GetString("permission4") + "|" +
				this.GetString("permission5") + "|" +
				this.GetString("permission6") + "|" +
				this.GetString("permission7") + "|" +
				this.GetString("permission8"))
		active, _ := this.GetInt64("active")
		input["username"] = username
		input["password"] = password
		input["password2"] = password2
		input["permissionlist"] = permissionlist
		input["email"] = email
		input["avator"] = avator
		valid := validation.Validation{}
		if v := valid.Required(username, "username"); !v.Ok {
			errmsg["username"] = "请输入用户名"
		} else if v := valid.MaxSize(username, 15, "username"); !v.Ok {
			errmsg["username"] = "用户名长度不能大于15个字符"
		}
		user := models.User{Username: username}
		if err := user.Read(); err == nil {
			errmsg["username"] = fmt.Sprintf("用户名:%s 已被注册", username)
		}
		if v := valid.Required(nickname, "nickname"); !v.Ok {
			errmsg["nickname"] = "请输入昵称"
		} else if v := valid.MaxSize(nickname, 15, "nickname"); !v.Ok {
			errmsg["nickname"] = "昵称长度不能大于15个字符"
		}
		user1 := models.User{Nickname: nickname}
		if err := user1.Read("nickname"); err == nil {
			errmsg["nickname"] = fmt.Sprintf("昵称:%s 已被使用", nickname)
		}
		if v := valid.Required(password, "password"); !v.Ok {
			errmsg["password"] = "请输入密码"
		}
		if v := valid.Required(password2, "password2"); !v.Ok {
			errmsg["password2"] = "请再次输入密码"
		} else if password != password2 {
			errmsg["password2"] = "两次输入的密码不一致"
		}
		if v := valid.Required(email, "email"); !v.Ok {
			errmsg["email"] = "请输入email地址"
		} else if v := valid.Email(email, "email"); !v.Ok {
			errmsg["email"] = "Email无效"
		}
		if active > 0 {
			active = 1
		} else {
			active = 0
		}
		if len(errmsg) == 0 {
			var user models.User
			user.Username = username
			user.Password = models.Md5([]byte(password))
			user.Permission = permissionlist
			user.Email = email
			user.Avator = avator
			user.Active = int8(active)
			user.Upcount = int64(3)
			user.Nickname = nickname
			if err := user.Insert(); err != nil {
				this.showmsg(err.Error())
			}
			this.Redirect("/admin/user/list", 302)
		}
	}
	this.Data["input"] = input
	this.Data["errmsg"] = errmsg
	this.display()
}

//编辑用户
func (this *UserController) Edit() {
	id, _ := this.GetInt64("id")
	user := models.User{Id: id}
	if err := user.Read(); err != nil {
		this.showmsg("用户不存在")
	}
	lastavator := user.Avator
	errmsg := make(map[string]string)
	if this.Ctx.Request.Method == "POST" {
		password := strings.TrimSpace(this.GetString("password"))
		password2 := strings.TrimSpace(this.GetString("password2"))
		email := strings.TrimSpace(this.GetString("email"))
		avator := strings.TrimSpace(this.GetString("avator"))
		nickname := strings.TrimSpace(this.GetString("nickname"))
		if avator == "" {
			avator = "/static/upload/default/user-default-60x60.png"
		}
		if avator != lastavator {
			models.Cache.Delete("newcomments")
			if !this.Isdefaultsrc(lastavator) {
				os.Remove("." + lastavator)
			}
		}
		permissionlist := strings.TrimSpace(
			this.GetString("permission1") + "|" +
				this.GetString("permission2") + "|" +
				this.GetString("permission3") + "|" +
				this.GetString("permission4") + "|" +
				this.GetString("permission5") + "|" +
				this.GetString("permission6") + "|" +
				this.GetString("permission7") + "|" +
				this.GetString("permission8"))
		active, _ := this.GetInt64("active")
		valid := validation.Validation{}
		if v := valid.Required(nickname, "nickname"); !v.Ok {
			errmsg["nickname"] = "请输入昵称"
		} else if v := valid.MaxSize(nickname, 15, "nickname"); !v.Ok {
			errmsg["nickname"] = "昵称长度不能大于15个字符"
		}
		user1 := models.User{Nickname: nickname}
		err := user1.Read("nickname")
		if err == nil && user1.Id != id {
			errmsg["nickname"] = fmt.Sprintf("昵称:%s 已被使用", nickname)
		}
		if password != "" {
			if v := valid.Required(password2, "password2"); !v.Ok {
				errmsg["password2"] = "请再次输入密码"
			} else if password != password2 {
				errmsg["password2"] = "两次输入的密码不一致"
			} else {
				user.Password = models.Md5([]byte(password))
			}
		}
		if v := valid.Required(email, "email"); !v.Ok {
			errmsg["email"] = "请输入email地址"
		} else if v := valid.Email(email, "email"); !v.Ok {
			errmsg["email"] = "Email无效"
		} else {
			user.Email = email
		}

		if active > 0 {
			user.Active = 1
		} else {
			user.Active = 0
		}

		if len(errmsg) == 0 {
			if user.Id != 1 {
				user.Permission = permissionlist
			}
			user.Avator = avator
			user.Nickname = nickname
			_ = user.Update()
			this.Redirect("/admin/user/list", 302)
		}
	}
	this.Data["errmsg"] = errmsg
	this.Data["user"] = user
	this.display()
}

//删除用户
func (this *UserController) Delete() {
	id, _ := this.GetInt64("id")
	if id == 1 {
		this.showmsg("不能删除ID为1的用户")
	}
	user := models.User{Id: id}
	if user.Read() == nil {
		if !this.Isdefaultsrc(user.Avator) {
			os.Remove("." + user.Avator)
		}
		user.Delete()
	}

	this.Redirect("/admin/user/list", 302)
}
