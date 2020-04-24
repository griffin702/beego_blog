package models

import (
	"github.com/astaxie/beego/orm"
)

//权限模型
type Permission struct {
	Id   int
	Name string `orm:"unique;size(20);index"`
}

func (m *Permission) TableName() string {
	return TableName("permission")
}

func (m *Permission) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Permission) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Permission) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *Permission) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *Permission) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}
