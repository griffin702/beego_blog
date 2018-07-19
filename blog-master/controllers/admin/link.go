package admin

import (
	"blog-master/models"
	"strings"
	"os"
)

type LinkController struct {
	baseController
}

//友链列表
func (this *LinkController) List() {
	var list []*models.Link
	var link models.Link
	link.Query().OrderBy("-rank").All(&list)
	this.Data["list"] = list
	this.display()
}

//添加友链
func (this *LinkController) Add() {
	if this.Ctx.Request.Method == "POST" {
		var link models.Link
		sitename := strings.TrimSpace(this.GetString("sitename"))
		url := strings.TrimSpace(this.GetString("url"))
		if len(url) < 9 {
			this.showmsg("请检查输入的网址")
		}
		err := strings.Index(url[:7], "http://")
		err2 := strings.Index(url[:8], "https://")
		err3 := strings.Index(url[:2], "//")
		if err == -1 && err2 == -1 && err3 == -1 {
			url = "//" + url
		}
		rank, _ := this.GetInt64("rank")
		siteavator := "/static/upload/default/user-default-60x60.png"
		if avator_input := strings.TrimSpace(this.GetString("cover")); avator_input != "" {
			siteavator = avator_input
		}
		sitedesc := strings.TrimSpace(this.GetString("sitedesc"))
		link.Sitename = sitename
		link.Url = url
		link.Rank = int8(rank)
		link.Siteavator = siteavator
		link.Sitedesc = sitedesc
		if err := link.Insert(); err != nil {
			this.showmsg(err.Error())
		}
		this.Redirect("/admin/link/list", 302)

	}
	this.display()
}

//编辑友链
func (this *LinkController) Edit() {
	id, _ := this.GetInt64("id")
	link := models.Link{Id: id}
	if err := link.Read(); err != nil {
		this.showmsg("友链不存在")
	}
	lastavator := link.Siteavator
	if this.Ctx.Request.Method == "POST" {
		sitename := strings.TrimSpace(this.GetString("sitename"))
		url := strings.TrimSpace(this.GetString("url"))
		rank, _ := this.GetInt64("rank")
		siteavator := strings.TrimSpace(this.GetString("cover"))
		if siteavator != lastavator && !this.Isdefaultsrc(lastavator) {
			os.Remove("."+lastavator)
		}
		sitedesc := strings.TrimSpace(this.GetString("sitedesc"))
		link.Sitename = sitename
		link.Url = url
		link.Rank = int8(rank)
		link.Siteavator = siteavator
		link.Sitedesc = sitedesc
		link.Update()
		this.Redirect("/admin/link/list", 302)
	}
	this.Data["link"] = link
	this.display()
}

//删除友链
func (this *LinkController) Delete() {
	id, _ := this.GetInt64("id")
	link := models.Link{Id: id}
	if link.Read() == nil {
		if !this.Isdefaultsrc(link.Siteavator) {
			os.Remove("." + link.Siteavator)
		}
		link.Delete()
	}
	this.Redirect("/admin/link/list", 302)
}
