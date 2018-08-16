package models

import (
	"crypto/md5"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	"net/url"
	"strings"
	"net/http"
	"io/ioutil"
	"time"
	"regexp"
)

func init() {
	go func() {
		for {
			time.Sleep(time.Duration(time.Second.Nanoseconds() * 10800))
			Cache.Delete("weather")
		}
	}()
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

//获取天气
func GetWeather() (string) {
	if !Cache.IsExist("weather") {
		resp, err := http.Get("http://tianqiapi.com/api.php?style=td&skin=pitaya")
		defer resp.Body.Close()
		if err == nil {
			weatherbody, _ := ioutil.ReadAll(resp.Body)
			re := regexp.MustCompile("<body>(?s:(.*?))</body>")
			result := re.FindAllString(string(weatherbody), -1)
			if i := strings.Index(result[0], "pitaya/."); i == -1 && len(result) > 0 {
				//返回内容正确才插入缓存
				rep := "http://tianqiapi.com/static/skin/pitaya"
				ret := strings.Replace(result[0], "./static/skin/pitaya", rep, -1)
				Cache.Put("weather", ret)
			} else {//默认必须插入空值到缓存，否则会一直重复获取影响访问速度，该任务交给计时器处理
				Cache.Put("weather", "")
			}
		} else {
			Cache.Put("weather", "")
		}
	}
	v := Cache.Get("weather")
	if v.(string) == "" {
		//当缓存的天气为空时,触发1次创建计时器,每10秒获取一次天气,直到获取正确为止
		Cache.Put("weather", "正在获取天气")//为了只创建1次，必须修改空值
		go func() {
			for {
				time.Sleep(time.Duration(time.Second.Nanoseconds() * 10))
				resp, err := http.Get("http://tianqiapi.com/api.php?style=td&skin=pitaya")
				if err == nil {
					weatherbody, _ := ioutil.ReadAll(resp.Body)
					re := regexp.MustCompile("<body>(?s:(.*?))</body>")
					result := re.FindAllString(string(weatherbody), -1)
					if i := strings.Index(result[0], "pitaya/."); i == -1 && len(result) > 0 {
						rep := "http://tianqiapi.com/static/skin/pitaya"
						ret := strings.Replace(result[0], "./static/skin/pitaya", rep, -1)
						Cache.Put("weather", ret)
						resp.Body.Close()
						break
					}
				}
			}
		}()
	}
	return v.(string)
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
