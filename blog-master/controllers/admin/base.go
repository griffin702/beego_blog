package admin

import (
	"github.com/astaxie/beego"
	"blog-master/models"
	"strconv"
	"strings"
	"time"
	"blog-master/controllers/ipfilter"
)

//初始化过滤器实例
func init() {
	ipfilter.ConnFilterCtx()["cc"] = ipfilter.NewCCConnFilter()
}

const (
	BIG_PIC_PATH   = "./static/upload/bigpic/"
	SMALL_PIC_PATH = "./static/upload/smallpic/"
	FILE_PATH      = "./static/upload/attachment/"
)

var pathArr = []string{"", BIG_PIC_PATH, SMALL_PIC_PATH, FILE_PATH}

type baseController struct {
	beego.Controller
	userid            int64
	username          string
	moduleName        string
	controllerName    string
	actionName        string
	permissionlist    map[string]int
	clientip          string
	allowconn         bool
	allowconnmsg      string
}

func (this *baseController) Prepare() {
	this.clientip = this.getClientIp()
	this.allowconn = true
	this.allowconn, this.allowconnmsg = ipfilter.ConnFilterCtx().OnConnected(this.clientip)
	//fmt.Println(ipfilter.ConnFilterCtx()["cc"])
	if !this.allowconn {
		//超过3次异常访问，返回500
		this.Abort("500")
	}
	controllerName, actionName := this.GetControllerAndAction()
	this.moduleName = "admin"
	this.controllerName = strings.ToLower(controllerName[0 : len(controllerName)-10])
	this.actionName = strings.ToLower(actionName)
	this.auth()
	this.checkPermission()
}

//登录状态验证
func (this *baseController) auth() {
	//允许任何人默认拥有访问account，comments的权限
	this.permissionlist = map[string]int{"account": 0,"comments":0}
	//提取当前cookie
	arr := strings.Split(this.Ctx.GetCookie("auth"), "|")
	//cookie判断是否已经正常登录
	if len(arr) == 2 {
		idstr, password := arr[0], arr[1]
		userid, _ := strconv.ParseInt(idstr, 10, 0)
		if userid > 0 {
			var user models.User
			var permission models.Permission
			user.Id = userid
			if user.Read() == nil && password == models.Md5([]byte(this.getClientIp()+"|"+user.Password)) {
				this.userid = user.Id
				this.username = user.Username
				for _, id := range strings.Split(user.Permission, "|") {
					err := permission.Query().Filter("id", id).One(&permission)
					if err == nil {
						this.permissionlist[permission.Name] = permission.Id
					}
				}
				if _, ok := this.permissionlist["fileupload"]; !ok && user.Upcount > 0 {
					this.permissionlist["fileupload"] = 0
				}
				this.permissionlist["index"] = 0
				if this.actionName == "login" {
					this.Redirect("/admin", 302)
				}
			}
		}
	}
	if this.userid == 0 && this.actionName != "login" && this.actionName != "register" {
		this.Redirect("/", 302)
	}
}

//渲染模版
func (this *baseController) display(tpl ...string) {
	var tplname string
	if len(tpl) == 1 {
		tplname = this.moduleName + "/" + tpl[0] + ".html"
	} else {
		tplname = this.moduleName + "/" + this.controllerName + "_" + this.actionName + ".html"
	}
	this.Data["version"] = beego.AppConfig.String("AppVer")
	this.Data["adminid"] = this.userid
	this.Data["adminname"] = this.username
	this.Data["userpermission"] = this.permissionlist
	this.Layout = this.moduleName + "/layout.html"
	this.TplName = tplname
}

//显示错误提示
func (this *baseController) showmsg(msg ...string) {
	if len(msg) == 1 {
		msg = append(msg, this.Ctx.Request.Referer())
	}
	this.Data["adminid"] = this.userid
	this.Data["adminname"] = this.username
	this.Data["msg"] = msg[0]
	this.Data["redirect"] = msg[1]
	this.Layout = this.moduleName + "/layout.html"
	this.TplName = this.moduleName + "/" + "showmsg.html"
	this.Render()
	this.StopRun()
}

//是否post提交
func (this *baseController) isPost() bool {
	return this.Ctx.Request.Method == "POST"
}

//获取用户IP地址
func (this *baseController) getClientIp() string {
	s := this.Ctx.Request.Header.Get("X-Real-IP")
	if s == "" {
		s = strings.Split(this.Ctx.Request.RemoteAddr, ":")[0]
	}
	return s
}

//权限验证
func (this *baseController) checkPermission() {
	if this.userid != 1 {
		if _, ok := this.permissionlist[this.controllerName]; !ok {
			this.showmsg("抱歉，只有超级管理员才能进行该操作！")
		}
	}
}

func (this *baseController) getTime() time.Time {
	options := models.GetOptions()
	timezone := float64(0)
	if v, ok := options["timezone"]; ok {
		timezone, _ = strconv.ParseFloat(v, 64)
	}
	add := timezone * float64(time.Hour)
	return time.Now().UTC().Add(time.Duration(add))
}

func (this *baseController) Isdefaultsrc(value string) bool {
	var defaultdir = "/static/upload/default/"
	if value != "" {
		if index := strings.Index(value, defaultdir); index != -1 {
			return true
		}
	}
	return false
}
