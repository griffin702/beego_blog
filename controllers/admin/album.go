package admin

import (
	"beego_blog/models"
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"time"
)

type AlbumController struct {
	baseController
}

//相册列表
func (this *AlbumController) List() {
	var page int64
	var pagesize int64 = 6
	var list []*models.Album
	var album models.Album

	if page, _ = this.GetInt64("page"); page < 1 {
		page = 1
	}
	offset := (page - 1) * pagesize

	query := album.Query()
	count, _ := query.Count()
	if count > 0 {
		query.OrderBy("-rank", "-posttime").Limit(pagesize, offset).All(&list)
	}

	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(page, count, pagesize, "/admin/album/list?page=%d").ToString()
	this.display()
}

//创建相册
func (this *AlbumController) Add() {
	if this.Ctx.Request.Method == "POST" {
		rank, _ := this.GetInt("rank")
		var album models.Album
		album.Name = strings.TrimSpace(this.GetString("albumname"))
		album.Cover = strings.TrimSpace(this.GetString("cover"))
		if album.Cover == "" {
			album.Cover = fmt.Sprintf("/static/upload/default/blog-default-%d.png", rand.Intn(9))
		}
		album.Rank = int8(rank)
		album.Posttime, _ = time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
		if err := album.Insert(); err != nil {
			this.showmsg(err.Error())
		}
		this.Redirect("/admin/album/list", 302)

	}
	this.display()
}

//删除相册
func (this *AlbumController) Delete() {
	id, _ := this.GetInt64("albumid")
	album := models.Album{Id: id}
	h, _ := strconv.Atoi(this.GetString("ishide"))
	album.Ishide = int8(h)
	if err := album.Update("ishide"); err != nil {
		this.showmsg(err.Error())
		return
	}
	this.Redirect("/admin/album/list", 302)
}

//修改
func (this *AlbumController) Edit() {
	id, _ := this.GetInt64("albumid")
	album := models.Album{Id: id}
	if album.Read() != nil {
		this.Abort("404")
	}
	if this.Ctx.Request.Method == "POST" {
		rank, _ := this.GetInt("rank")
		album.Cover = this.GetString("cover")
		if album.Cover == "" {
			album.Cover = fmt.Sprintf("/static/upload/default/blog-default-%d.png", rand.Intn(9))
		}
		album.Name = this.GetString("albumname")
		album.Rank = int8(rank)
		album.Update()
		this.Redirect("/admin/album/list", 302)
	}
	this.Data["album"] = album
	this.display()
}
