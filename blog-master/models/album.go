package models

import (
	"github.com/astaxie/beego/orm"
	"time"
)

//相册表
type Album struct {
	Id       int64
	Name     string    `orm:"size(100)"`
	Cover    string    `orm:"size(70)"`
	Posttime time.Time `orm:"type(datetime);index"`
	Ishide   int8
	Rank     int8
	Photonum int64
}

func (m *Album) TableName() string {
	return TableName("album")
}

func (m *Album) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *Album) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Album) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Album) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *Album) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}
