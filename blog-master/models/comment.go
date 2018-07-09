package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//评论模型
type Comments struct {
	Id                int64
	Obj_pk            int64
	Reply_pk          int64
	Reply_fk          int64
	User              *User     `orm:"rel(fk)"`
	Comment           string    `orm:"type(text)"`
	Submittime        time.Time `orm:"auto_now_add;type(datetime)"`
	Ipaddress         string    `orm:"null"`
	Is_public         int8      //0-发布，1-不发布
	Is_removed        int8      //0-正常，1-删除
}

func (m *Comments) TableName() string {
	return TableName("comments")
}

func (m *Comments) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	Cache.Delete("comments")
	return nil
}

func (m *Comments) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	if err := m.Query().Filter("User", m.User).RelatedSel().One(m); err != nil {
		return err
	}
	return nil
}

func (m *Comments) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	Cache.Delete("comments")
	return nil
}

//删除
func (m *Comments) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	Cache.Delete("comments")
	return nil
}

//表查询
func (m *Comments) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}

func (m *Comments) Is_LastReply(list []*Comments, key int) bool {
	i := len(list) - 1
	if i == key {
		return true
	}
	return false
}

func (m *Comments) Return_PkName(key int64) (string, error) {
	reply_pk := Comments{Id: key}
	if err := reply_pk.Read(); err != nil {
		return "",err
	}
	return reply_pk.User.Username, nil
}

func (m *Comments) Return_PkContent(key int64) (string, error) {
	reply_pk := Comments{Id: key}
	if err := reply_pk.Read(); err != nil {
		return "",err
	}
	return reply_pk.Comment, nil
}