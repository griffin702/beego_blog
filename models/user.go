package models

import (
	"fmt"
	"github.com/astaxie/beego/orm"
	"time"
)

//用户表模型
type User struct {
	Id         int64
	Username   string    `orm:"unique;size(15);index"`
	Password   string    `orm:"size(32)"`
	Nickname   string    `orm:"size(15);index"`
	Email      string    `orm:"size(50);index"`
	Lastlogin  time.Time `orm:"auto_now_add;type(datetime);index"`
	Logincount int64     `orm:"index"`
	Lastip     string    `orm:"size(32);index"`
	Authkey    string    `orm:"size(10)"`
	Active     int8
	Permission string `orm:"size(100);index"`
	Avator     string `orm:"size(150);default(/static/upload/default/user-default-60x60.png)"`
	Upcount    int64
	Post       []*Post     `orm:"reverse(many)"`
	Comments   []*Comments `orm:"reverse(many)"`
}

//用户json模型
type UserJson struct {
	Id         int64
	Username   string    `json:"username"`
	Username1  string    `json:"username1"`
	Password   string    `json:"password"`
	Password1  string    `json:"password1"`
	Password2  string    `json:"password2"`
	Nickname   string    `json:"nickname"`
	Email      string    `json:"email"`
	Lastlogin  time.Time `json:"lastlogin"`
	Logincount int64     `json:"logincount"`
	Lastip     string    `json:"lastip"`
	Authkey    string    `json:"authkey"`
	Active     int8      `json:"active"`
	Permission string    `json:"permission"`
	Avator     string    `json:"avator"`
	Upcount    int64     `json:"upcount"`
	Captcha    string    `json:"captcha"`
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
	var cacheName string
	if m.Id > 0 {
		cacheName = fmt.Sprintf("userid_%d", m.Id)
	} else {
		if m.Username != "" {
			cacheName = fmt.Sprintf("username_%s", m.Username)
		} else if m.Nickname != "" {
			cacheName = fmt.Sprintf("nickname_%s", m.Nickname)
		}
	}
	if !Cache.IsExist(cacheName) {
		if err := orm.NewOrm().Read(m, fields...); err != nil {
			return err
		}
		_ = Cache.Put(cacheName, m)
	}
	*m = *Cache.Get(cacheName).(*User)
	return nil
}

func (m *User) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	_ = Cache.Delete(fmt.Sprintf("userid_%d", m.Id))
	_ = Cache.Delete(fmt.Sprintf("username_%s", m.Username))
	_ = Cache.Delete(fmt.Sprintf("nickname_%s", m.Nickname))
	_ = Cache.Delete(fmt.Sprintf("userPermissionList_%d", m.Id))
	return nil
}

func (m *User) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	_ = Cache.Delete(fmt.Sprintf("userid_%d", m.Id))
	_ = Cache.Delete(fmt.Sprintf("username_%s", m.Username))
	_ = Cache.Delete(fmt.Sprintf("nickname_%s", m.Nickname))
	_ = Cache.Delete(fmt.Sprintf("userPermissionList_%d", m.Id))
	return nil
}

func (m *User) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}
