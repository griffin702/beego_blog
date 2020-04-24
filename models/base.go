package models

import (
	"crypto/md5"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	"net/url"
	"strings"
)

func init() {
	dbhost := beego.AppConfig.String("dbhost")
	dbport := beego.AppConfig.String("dbport")
	dbuser := beego.AppConfig.String("dbuser")
	dbpassword := beego.AppConfig.String("dbpassword")
	dbname := beego.AppConfig.String("dbname")
	if dbport == "" {
		dbport = "3306"
	}
	//&loc=Asia%2FShanghai（已单独做了时区自动处理）
	dburl := dbuser + ":" + dbpassword + "@tcp(" + dbhost + ":" + dbport + ")/" + dbname + "?charset=utf8"
	orm.RegisterDataBase("default", "mysql", dburl)
	orm.RegisterModel(
		new(User), new(Post), new(Tag), new(Option), new(TagPost),
		new(Mood), new(Photo), new(Album), new(Link), new(Permission),
		new(Comments))
	if beego.AppConfig.String("runmode") == "dev" {
		orm.Debug = true
	}
	//orm.RunSyncdb("default", false, true)
}

func Md5(buf []byte) string {
	hash := md5.New()
	hash.Write(buf)
	return fmt.Sprintf("%x", hash.Sum(nil))
}

func Rawurlencode(str string) string {
	return strings.Replace(url.QueryEscape(str), "+", "%20", -1)
}

func GetOptions() map[string]string {
	if !Cache.IsExist("options") {
		var result []*Option
		o := orm.NewOrm()
		o.QueryTable(&Option{}).All(&result)
		options := make(map[string]string)
		for _, v := range result {
			if v.Name == "myworkdesc" {
				v.Value = strings.Replace(v.Value, "\r\n", "<br/>", -1)
			}
			options[v.Name] = v.Value
		}
		Cache.Put("options", options)
	}
	v := Cache.Get("options")
	return v.(map[string]string)
}

func GetLatestBlog() []*Post {
	if !Cache.IsExist("latestblog") {
		var result []*Post
		query := new(Post).Query().Filter("status", 0).Filter("urltype", 0)
		count, _ := query.Count()
		if count > 0 {
			query.OrderBy("-posttime").Limit(8).All(&result)
		}
		Cache.Put("latestblog", result)
	}
	v := Cache.Get("latestblog")
	return v.([]*Post)
}

func GetHotBlog() []*Post {
	if !Cache.IsExist("hotblog") {
		var result []*Post
		new(Post).Query().Filter("status", 0).Filter("urltype", 0).OrderBy("-views").Limit(5).All(&result)
		Cache.Put("hotblog", result)
	}
	v := Cache.Get("hotblog")
	return v.([]*Post)
}

func GetLinks() []*Link {
	if !Cache.IsExist("links") {
		var result []*Link
		new(Link).Query().OrderBy("-rank").All(&result)
		Cache.Put("links", result)
	}
	v := Cache.Get("links")
	return v.([]*Link)
}

func GetNewComments() []*Comments {
	if !Cache.IsExist("newcomments") {
		var result []*Comments
		new(Comments).Query().Filter("is_removed", 0).Limit(5).OrderBy("-submittime").RelatedSel("user").All(&result)
		Cache.Put("newcomments", result)
	}
	v := Cache.Get("newcomments")
	return v.([]*Comments)
}

//返回带前缀的表名
func TableName(str string) string {
	return fmt.Sprintf("%s%s", beego.AppConfig.String("dbprefix"), str)
}
