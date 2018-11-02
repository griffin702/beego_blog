package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//用户表模型
type User struct {
	Id         int64
	Username   string        `json:"username" orm:"unique;size(15);index"`
	Password   string        `orm:"size(32)"`
	Nickname   string        `json:"nickname" orm:"size(15);index"`
	Email      string        `json:"email" orm:"size(50);index"`
	Lastlogin  time.Time     `json:"lastlogin" orm:"auto_now_add;type(datetime);index"`
	Logincount int64         `orm:"index"`
	Lastip     string        `json:"lastip" orm:"size(32);index"`
	Authkey    string        `orm:"size(10)"`
	Active     int8
	Permission string        `orm:"size(100);index"`
	Avator     string        `json:"avator" orm:"size(150);default(/static/upload/default/user-default-60x60.png)"`
	Upcount    int64
	Post       []*Post       `orm:"reverse(many)"`
	Comments   []*Comments   `orm:"reverse(many)"`
}

func (m *User) TableName() string {
	return TableName("user")
}

func (m *User) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *User) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *User) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *User) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *User) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}
