package blog

import (
	"beego_blog/models"
	"strconv"
	"strings"
)

type MainController struct {
	baseController
}

//首页, 只显示前N条
func (this *MainController) Index() {
	var list []*models.Post
	query := new(models.Post).Query().Filter("status", 0).Filter("urltype", 0)
	count, _ := query.Count()
	if count > 0 {
		query.OrderBy("-istop", "-posttime").Limit(this.pagesize, (this.page-1)*this.pagesize).RelatedSel().All(&list)
	}
	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(int64(this.page), int64(count), int64(this.pagesize), "/index%d.html").ToString()
	this.setHeadMetas()
	this.display("index")
}

//blog分页显示
func (this *MainController) BlogList() {
	var list []*models.Post
	query := new(models.Post).Query().Filter("status", 0).Filter("urltype", 0)
	count, _ := query.Count()
	if count > 0 {
		query.OrderBy("-istop", "-posttime").Limit(this.pagesize, (this.page-1)*this.pagesize).RelatedSel().All(&list)
	}
	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(int64(this.page), int64(count), int64(this.pagesize), "/life%d.html").ToString()
	this.setHeadMetas("成长录")
	this.display("life")
}

//关于我
func (this *MainController) About() {
	this.setHeadMetas("关于我")
	this.right = ""
	this.display("about")
}

//留404页面
func (this *MainController) Go404() {
	this.setHeadMetas("Sorry 404页面没找到")
	this.display("404")
}

//说说
func (this *MainController) Mood() {
	var list []*models.Mood
	query := new(models.Mood).Query()
	count, _ := query.Count()
	if count > 0 {
		_, _ = query.OrderBy("-posttime").Limit(this.pagesize, (this.page-1)*this.pagesize).All(&list)
	}
	this.Data["list"] = list
	this.setHeadMetas("碎言碎语")
	this.right = ""
	this.Data["pagebar"] = models.NewPager(int64(this.page), int64(count), int64(this.pagesize), "/mood%d.html").ToString()
	this.display("mood")
}

//照片展示
func (this *MainController) Photo() {
	album := new(models.Album)
	albumid, err := strconv.ParseInt(this.Ctx.Input.Param(":albumid"), 10, 64)
	if err != nil {
		this.Redirect("/404.html", 302)
	}
	album.Id = albumid
	err2 := album.Read()
	if err2 != nil || album.Ishide != 0 {
		this.Redirect("/404.html", 302)
	}
	this.setHeadMetas("相册 " + album.Name + " 内的照片")
	var page int64
	var pagesize int64 = 18
	var list []*models.Photo
	var photo models.Photo
	if page, _ = this.GetInt64("page"); page < 1 {
		page = 1
	}
	offset := (page - 1) * pagesize
	count, _ := photo.Query().Filter("albumid", albumid).Count()
	if count > 0 {
		_, _ = photo.Query().Filter("albumid", albumid).OrderBy("-posttime").Limit(pagesize, offset).All(&list)
	}
	this.right = ""
	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(page, count, pagesize, "/photo%d.html?page=%d", albumid).ToString()
	this.display("photo")
}

//相册展示
func (this *MainController) Album() {
	pagesize, _ := strconv.Atoi(this.getOption("albumsize"))
	if pagesize < 1 {
		pagesize = 12
	}
	var list []*models.Album
	query := new(models.Album).Query().Filter("ishide", 0)
	count, _ := query.Count()
	if count > 0 {
		query.OrderBy("-rank", "-posttime").Limit(pagesize, (this.page-1)*pagesize).All(&list)
	}
	this.setHeadMetas("光影瞬间")
	this.right = ""
	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(int64(this.page), int64(count), int64(pagesize), "/album%d.html").ToString()
	this.display("album")
}

//文章显示
func (this *MainController) Show() {
	var (
		post = new(models.Post)
		err  error
	)
	urlname := this.Ctx.Input.Param(":urlname")
	if urlname != "" {
		post.Urlname = urlname
		err = post.Read("urlname")
	} else {
		id, _ := strconv.Atoi(this.Ctx.Input.Param(":id"))
		post.Id = int64(id)
		err = post.Read()
	}
	if err != nil || post.Status != 0 {
		this.Redirect("/404.html", 302)
	}
	post.Query().Filter("Id", post.Id).RelatedSel().One(post)
	post.Views++
	post.Update("Views")
	models.Cache.Delete("hotblog")
	desc := post.Excerpt()
	post.Content = post.Del_Excerpt()
	pre, next := post.GetPreAndNext()
	this.Data["post"] = post
	this.Data["pre"] = pre
	this.Data["next"] = next
	this.Data["smalltitle"] = "返回列表"
	if urlname == "about.html" {
		this.Data["smalltitle"] = "关于我"
	}
	var comment models.Comments
	var commentlist0 []*models.Comments
	var commentlist []*models.Comments
	var commentlength int64
	var commentuser int64
	type CommentlistMap struct {
		Commentlist0 *models.Comments
		Commentlist  []*models.Comments
	}
	var commentlistmap []CommentlistMap
	count, _ := comment.Query().Filter("obj_pk", post.Id).Filter("reply_pk", 0).Filter("is_removed", 0).Count()
	comment.Query().Filter("obj_pk", post.Id).Filter("reply_pk", 0).Filter("is_removed", 0).OrderBy("-submittime").Limit(this.pagesize, (this.page-1)*this.pagesize).RelatedSel().All(&commentlist0)
	for _, v := range commentlist0 {
		comment.Query().Filter("reply_fk", v.Id).Filter("is_removed", 0).OrderBy("submittime").RelatedSel().All(&commentlist)
		var item = CommentlistMap{}
		item.Commentlist0 = v
		item.Commentlist = commentlist
		commentlistmap = append(commentlistmap, item)
		commentlist = []*models.Comments{}
	}
	commentlength, _ = comment.Query().Filter("obj_pk", post.Id).Filter("is_removed", 0).Count()
	commentuser, _ = comment.Query().Filter("obj_pk", post.Id).Filter("is_removed", 0).GroupBy("User").Count()
	this.Data["commentlistmap"] = commentlistmap
	this.Data["commentlength"] = commentlength
	this.Data["commentuser"] = commentuser
	pager := models.NewPager(
		int64(this.page), int64(count),
		int64(this.pagesize), "/article/%d/page/%d#comments-head", post.Id)
	this.Data["pagebar"] = pager.ToString()
	this.Data["pagenum"] = this.page
	this.Data["totalpage"] = pager.Totalpage
	this.setHeadMetas(post.Title, strings.Trim(post.Tags, ","), desc)
	this.display("article")
}

//分类页
func (this *MainController) CategoryList() {
	var tags []*models.Tag
	var tag models.Tag
	tag.Query().All(&tags)
	this.Data["tags"] = tags
	this.setHeadMetas("归类归档")
	this.display("tags")
}

//分类查看
func (this *MainController) Category() {
	var list []*models.Post
	tagpost := new(models.TagPost)
	tag := new(models.Tag)
	cateid, _ := strconv.Atoi(this.Ctx.Input.Param(":cateid"))
	tag.Id = int64(cateid)

	if tag.Read("Id") != nil {
		this.Abort("404")
	}
	query := tagpost.Query().Filter("Tag", tag.Id).RelatedSel().Filter("poststatus", 0)
	count, _ := query.Count()
	if count > 0 {
		var tp []*models.TagPost
		var pids []int64 = make([]int64, 0)
		query.OrderBy("-posttime").Limit(this.pagesize, (this.page-1)*this.pagesize).All(&tp)
		for _, v := range tp {
			pids = append(pids, v.Postid)
		}
		new(models.Post).Query().Filter("id__in", pids).RelatedSel().All(&list)
	}
	this.Data["tag"] = tag
	this.Data["list"] = list
	this.Data["pagebar"] = models.NewPager(int64(this.page), int64(count), int64(this.pagesize), "/category/"+tag.Name+"/page/%d").ToString()
	this.setHeadMetas("归类归档 - " + tag.Name)
	this.display("category")
}

//分类查看
func (this *MainController) Links() {
	var comment models.Comments
	var commentlist0 []*models.Comments
	var commentlist []*models.Comments
	var commentlength int64
	var commentuser int64
	type CommentlistMap struct {
		Commentlist0 *models.Comments
		Commentlist  []*models.Comments
	}
	var commentlistmap []CommentlistMap
	count, _ := comment.Query().Filter("obj_pk_type", 1).Filter("reply_pk", 0).Filter("is_removed", 0).Count()
	comment.Query().Filter("obj_pk_type", 1).Filter("reply_pk", 0).Filter("is_removed", 0).OrderBy("-submittime").Limit(this.pagesize, (this.page-1)*this.pagesize).RelatedSel("user").All(&commentlist0)
	for _, v := range commentlist0 {
		comment.Query().Filter("reply_fk", v.Id).Filter("is_removed", 0).OrderBy("submittime").RelatedSel("user").All(&commentlist)
		var item = CommentlistMap{}
		item.Commentlist0 = v
		item.Commentlist = commentlist
		commentlistmap = append(commentlistmap, item)
		commentlist = []*models.Comments{}
	}
	commentlength, _ = comment.Query().Filter("obj_pk_type", 1).Filter("is_removed", 0).Count()
	commentuser, _ = comment.Query().Filter("obj_pk_type", 1).Filter("is_removed", 0).GroupBy("User").Count()
	this.Data["commentlistmap"] = commentlistmap
	this.Data["commentlength"] = commentlength
	this.Data["commentuser"] = commentuser
	pager := models.NewPager(
		int64(this.page), int64(count),
		int64(this.pagesize), "/links%d.html#comments-head")
	this.Data["pagebar"] = pager.ToString()
	this.Data["pagenum"] = this.page
	this.Data["totalpage"] = pager.Totalpage
	this.setHeadMetas("友情链接")
	this.display("links")
}
