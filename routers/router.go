package routers

import (
	"beego_blog/controllers/admin"
	"beego_blog/controllers/api"
	"beego_blog/controllers/blog"
	"github.com/astaxie/beego"
)

func init() {
	//前台路由
	beego.Router("/", &blog.MainController{}, "*:Index")
	beego.Router("/404.html", &blog.MainController{}, "*:Go404")
	beego.Router("/index:page:int.html", &blog.MainController{}, "*:Index")

	beego.Router("/article/:id:int", &blog.MainController{}, "*:Show")      //ID访问
	beego.Router("/article/:urlname(.+)", &blog.MainController{}, "*:Show") //别名访问文章
	beego.Router("/article/:id:int/page/:page:int", &blog.MainController{}, "*:Show")

	beego.Router("/category.html", &blog.MainController{}, "*:CategoryList")
	beego.Router("/category:page:int.html", &blog.MainController{}, "*:CategoryList")
	beego.Router("/category/:cateid(.+?)", &blog.MainController{}, "*:Category")
	beego.Router("/category/:cateid(.+?)/page/:page:int", &blog.MainController{}, "*:Category")

	beego.Router("/life:page:int.html", &blog.MainController{}, "*:BlogList")
	beego.Router("/life.html", &blog.MainController{}, "*:BlogList")

	beego.Router("/mood.html", &blog.MainController{}, "*:Mood")
	beego.Router("/mood:page:int.html", &blog.MainController{}, "*:Mood")

	beego.Router("/about.html", &blog.MainController{}, "*:About")

	//友情链接
	beego.Router("/links.html", &blog.MainController{}, "*:Links")
	beego.Router("/links:page:int.html", &blog.MainController{}, "*:Links")
	//照片展示
	beego.Router("/photo.html", &blog.MainController{}, "*:Photo")
	beego.Router("/photo:albumid:int.html", &blog.MainController{}, "*:Photo")

	//相册展示
	beego.Router("/album.html", &blog.MainController{}, "*:Album")
	beego.Router("/album:page:int.html", &blog.MainController{}, "*:Album")

	//后台路由
	beego.Router("/admin", &admin.IndexController{}, "*:Index")
	beego.Router("/admin/login", &admin.AccountController{}, "post:Login")
	beego.Router("/admin/register", &admin.AccountController{}, "post:Register")
	beego.Router("/admin/logout", &admin.AccountController{}, "*:Logout")
	beego.Router("/admin/account/profile", &admin.AccountController{}, "*:Profile")
	//系统管理
	beego.Router("/admin/system/setting", &admin.SystemController{}, "*:Setting")

	//内容管理
	beego.Router("/admin/article/list", &admin.ArticleController{}, "*:List")
	beego.Router("/admin/article/add", &admin.ArticleController{}, "*:Add")
	beego.Router("/admin/article/edit", &admin.ArticleController{}, "*:Edit")
	beego.Router("/admin/article/save", &admin.ArticleController{}, "post:Save")
	beego.Router("/admin/article/delete", &admin.ArticleController{}, "*:Delete")
	beego.Router("/admin/article/batch", &admin.ArticleController{}, "*:Batch")
	beego.Router("/admin/tag", &admin.TagController{}, "*:Index")

	//说说管理
	beego.Router("/admin/mood/add", &admin.MoodController{}, "*:Add")
	beego.Router("/admin/mood/list", &admin.MoodController{}, "*:List")
	beego.Router("/admin/mood/delete", &admin.MoodController{}, "*:Delete")

	//相册管理
	beego.Router("/admin/album/add", &admin.AlbumController{}, "*:Add")
	beego.Router("/admin/album/list", &admin.AlbumController{}, "*:List")
	beego.Router("/admin/album/edit", &admin.AlbumController{}, "*:Edit")
	beego.Router("/admin/album/delete", &admin.AlbumController{}, "*:Delete")

	//照片管理
	beego.Router("/admin/photo/list", &admin.PhotoController{}, "*:List")
	beego.Router("/admin/photo/cover", &admin.PhotoController{}, "*:Cover")
	beego.Router("/admin/photo/delete", &admin.PhotoController{}, "*:Delete")

	//用户管理
	beego.Router("/admin/user/list", &admin.UserController{}, "*:List")
	beego.Router("/admin/user/add", &admin.UserController{}, "*:Add")
	beego.Router("/admin/user/edit", &admin.UserController{}, "*:Edit")
	beego.Router("/admin/user/delete", &admin.UserController{}, "*:Delete")

	//友链管理
	beego.Router("/admin/link/list", &admin.LinkController{}, "*:List")
	beego.Router("/admin/link/add", &admin.LinkController{}, "*:Add")
	beego.Router("/admin/link/edit", &admin.LinkController{}, "*:Edit")
	beego.Router("/admin/link/delete", &admin.LinkController{}, "*:Delete")

	//评论管理
	beego.Router("/admin/comments/list", &admin.CommentsController{}, "*:List")
	beego.Router("/admin/comments/add", &admin.CommentsController{}, "*:Add")
	beego.Router("/admin/comments/edit", &admin.CommentsController{}, "*:Edit")
	beego.Router("/admin/comments/delete", &admin.CommentsController{}, "*:Delete")

	//独立fileupload
	beego.Router("/admin/upload", &admin.FileuploadController{}, "*:Upload")
	beego.Router("/admin/uploadfile", &admin.FileuploadController{}, "*:UploadFile")

	//front api
	front := beego.NewNamespace("/v1",
		beego.NSNamespace("/front",
			beego.NSInclude(
				&api.FrontController{},
			),
		),
	)
	//login api
	login := beego.NewNamespace("/v1",
		beego.NSNamespace("/login",
			beego.NSInclude(
				&api.FrontController{},
			),
		),
	)
	beego.AddNamespace(front, login)
}
