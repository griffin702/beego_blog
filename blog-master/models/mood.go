package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//心情表
type Mood struct {
	Id       int64
	Content  string    `orm:"type(text)"`
	Cover    string    `orm:"size(70)"`
	Posttime time.Time `orm:"type(datetime);index"`
}

func (m *Mood) TableName() string {
	return TableName("mood")
}

func (m *Mood) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *Mood) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Mood) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Mood) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *Mood) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}
