package admin

import (
	"beego_blog/controllers/ipfilter"
	"beego_blog/models"
	"strconv"
	"strings"
)

type CommentsController struct {
	baseController
}

//评论列表
func (this *CommentsController) List() {
	if this.userid != 1 {
		this.showmsg("未授权访问")
	}
	var list []*models.Comments
	var comment models.Comments
	var (
		page     int64
		pagesize int64 = 10
		offset   int64
	)
	if page, _ = this.GetInt64("page"); page < 1 {
		page = 1
	}
	offset = (page - 1) * pagesize
	count, _ := comment.Query().Count()
	if count > 0 {
		_, _ = comment.Query().OrderBy("-submittime").Limit(pagesize, offset).All(&list)
	}
	this.Data["pagebar"] = models.NewPager(page, count, pagesize, "/admin/comments/list?page=%d").ToString()
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
			object_pk_type, _ := strconv.Atoi(strings.TrimSpace(this.GetString("object_pk_type")))
			replypk := strings.TrimSpace(this.GetString("reply_pk"))
			replyfk, _ := strconv.Atoi(strings.TrimSpace(this.GetString("reply_fk")))
			comment_content := strings.TrimSpace(this.GetString("comment_content"))
			security_hash := strings.TrimSpace(this.GetString("security_hash"))
			timestamp := strings.TrimSpace(this.GetString("timestamp"))
			Out := map[string]string{"err": "false", "msg": "请求参数不合法"}
			if comment_content != "" && security_hash != "" {
				strcount := len([]rune(comment_content))
				if strcount < 169 {
					checkstr := models.Md5([]byte(replypk + timestamp + "@YO!r52w!D2*I%Ov"))
					//println(security_hash,checkstr)
					if checkstr == security_hash {
						comment.Comment = comment_content
						var user models.User
						_ = user.Query().Filter("id", this.userid).Limit(1).One(&user)
						comment.User = &models.User{Id: this.userid}
						comment.Obj_pk = &models.Post{Id: int64(blogid)}
						comment.Obj_pk_type = int64(object_pk_type)
						replypk_to_int, _ := strconv.Atoi(replypk)
						comment.Reply_pk = int64(replypk_to_int)
						comment.Reply_fk = int64(replyfk)
						comment.Ipaddress = this.getClientIp()
						comment.Submittime = this.getTime()
						_ = models.Cache.Delete("newcomments")
						if err := comment.Insert(); err != nil {
							//this.showmsg(err.Error())
							Out["err"] = "false"
							Out["msg"] = err.Error()
						} else {
							Out["err"] = "ture"
							Out["msg"] = "感谢你的评论"
						}
					} else {
						Out["err"] = "false"
						Out["msg"] = "签名不合法,请您高抬贵手"
					}
				} else {
					Out["err"] = "false"
					Out["msg"] = "评论内容过长,最多168字符"
				}
			}
			//this.Redirect(this.Ctx.Request.Referer(), 302)
			this.Data["json"] = Out
			this.ServeJSON()
		} else {
			this.Abort("404")
		}
	}
}

//编辑评论
func (this *CommentsController) Edit() {
	if this.userid != 1 {
		this.showmsg("未授权操作")
	}
	id, _ := this.GetInt64("id")
	comment := models.Comments{Id: id}
	if comment.Read() != nil {
		this.showmsg("未查询到该评论")
	}
	if this.Ctx.Request.Method == "POST" {
		content := strings.TrimSpace(this.GetString("content"))
		is_removed, _ := this.GetInt8("is_removed")
		comment.Comment = content
		comment.Is_removed = is_removed
		_ = comment.Update("comment", "is_removed")
		_ = models.Cache.Delete("newcomments")
		this.Redirect("/admin/comments/list", 302)
	}
	this.Data["comment"] = comment
	this.display()
}

//删除评论
func (this *CommentsController) Delete() {
	if this.userid != 1 {
		this.showmsg("未授权操作")
	}
	id, _ := this.GetInt64("id")
	comment := models.Comments{Id: id}
	if comment.Read() != nil {
		this.showmsg("未查询到该评论")
	}
	comment.Is_removed = 1
	_ = comment.Update("is_removed")
	_ = models.Cache.Delete("newcomments")
	this.Redirect("/admin/comments/list", 302)
}
