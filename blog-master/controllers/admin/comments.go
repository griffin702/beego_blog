package admin

import (
	"blog-master/models"
	"strings"
	"strconv"
	"blog-master/controllers/ipfilter"
)

type CommentsController struct {
	baseController
}

//评论列表
func (this *CommentsController) List() {
	var list []*models.Comments
	var comment models.Comments
	comment.Query().OrderBy("-submittime").All(&list)
	this.Data["list"] = list
	this.display()
}

//添加评论
func (this *CommentsController) Add() {
	x := ipfilter.ConnFilterCtx().GetabnConn(this.clientip)
	if x > 0 {
		this.Abort("500")
	} else {
		if this.Ctx.Request.Method == "POST" {
			var comment models.Comments
			blogid, _ := strconv.Atoi(strings.TrimSpace(this.GetString("object_pk")))
			replypk := strings.TrimSpace(this.GetString("reply_pk"))
			replyfk, _ := strconv.Atoi(strings.TrimSpace(this.GetString("reply_fk")))
			comment_content := strings.TrimSpace(this.GetString("comment_content"))
			security_hash := strings.TrimSpace(this.GetString("security_hash"))
			timestamp := strings.TrimSpace(this.GetString("timestamp"))
			if comment_content != "" && security_hash != "" {
				checkstr := models.Md5([]byte(replypk + timestamp + "@YO!r52w!D2*I%Ov"))
				//println(security_hash,checkstr)
				if checkstr == security_hash {
					comment.Comment = comment_content
					var user models.User
					user.Query().Filter("id", this.userid).Limit(1).One(&user)
					comment.User = &models.User{Id: this.userid}
					comment.Obj_pk = &models.Post{Id: int64(blogid)}
					replypk_to_int, _ := strconv.Atoi(replypk)
					comment.Reply_pk = int64(replypk_to_int)
					comment.Reply_fk = int64(replyfk)
					comment.Ipaddress = this.getClientIp()
					if err := comment.Insert(); err != nil {
						this.showmsg(err.Error())
					}
				}
			}
			this.Redirect(this.Ctx.Request.Referer(), 302)
		}
	}
}

//编辑评论
func (this *CommentsController) Edit() {
	id, _ := this.GetInt64("id")
	link := models.Link{Id: id}
	if err := link.Read(); err != nil {
		this.showmsg("友链不存在")
	}

	if this.Ctx.Request.Method == "POST" {
		sitename := strings.TrimSpace(this.GetString("sitename"))
		url := strings.TrimSpace(this.GetString("url"))
		rank, _ := this.GetInt64("rank")
		siteavator := strings.TrimSpace(this.GetString("siteavator"))
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

//删除评论
func (this *CommentsController) Delete() {
	id, _ := this.GetInt64("id")
	link := models.Link{Id: id}
	if link.Read() == nil {
		link.Delete()
	}
	this.Redirect("/admin/link/list", 302)
}