package models

import (
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	//"github.com/beego/admin/src/models"
)
type Article struct {
	Id int
	Name string
	Context string
}
func init() {
	orm.RegisterModel(new(Article))
	//orm.RegisterDataBase("default", "mysql", "root:123456/.,mnb@/beego?charset=utf8", 30)
	//orm.RunSyncdb("default", false, true)
	//models.Syncdb()
}
