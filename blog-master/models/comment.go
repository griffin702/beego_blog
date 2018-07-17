package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//评论模型
type Comments struct {
	Id                int64
	Obj_pk            *Post     `orm:"rel(fk);index"`
	Reply_pk          int64     `orm:"index"`
	Reply_fk          int64     `orm:"index"`
	User              *User     `orm:"rel(fk);index"`
	Comment           string    `orm:"type(text)"`
	Submittime        time.Time `orm:"auto_now_add;type(datetime);index"`
	Ipaddress         string    `orm:"null"`
	Is_removed        int8      `orm:"index"`     //0-正常，1-删除
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

func (m *Comments) Return_PkName(key int64) (string, error) {
	var reply_pk Comments
	err := reply_pk.Query().Filter("Id", key).RelatedSel().Limit(1).One(&reply_pk)
	if err != nil {
		return "",err
	}
	return reply_pk.User.Username, nil
}

func (m *Comments) Return_PkContent(key int64) (string, error) {
	var reply_pk Comments
	err := reply_pk.Query().Filter("Id", key).RelatedSel().Limit(1).One(&reply_pk)
	if err != nil {
		return "",err
	}
	return reply_pk.Comment, nil
}

func (m *Comments) Return_8(key string) (string) {
	data := []rune(m.Comment)
	if len(data) > 8 {
		return string(data[:8])+"..."
	}
	return m.Comment
}

