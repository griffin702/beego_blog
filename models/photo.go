package models

import (
	"github.com/astaxie/beego/orm"
	"strings"
	"time"
)

//相册表
type Photo struct {
	Id       int64
	Albumid  int64     `orm:"index"`
	Des      string    `orm:"size(100);index"`
	Posttime time.Time `orm:"type(datetime);index"`
	Url      string    `orm:"size(70)"`
	Small    string    `orm:"-"`
}

func (m *Photo) TableName() string {
	return TableName("photo")
}

func (m *Photo) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *Photo) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Photo) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Photo) Delete() error {
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *Photo) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}

func (m *Photo) ChangetoSmall() string {
	arr1 := strings.Split(m.Url, "/")
	filename := arr1[len(arr1)-1]
	arr2 := strings.Split(filename, ".")
	ext := "." + arr2[len(arr2)-1]
	m.Small = strings.Replace(m.Url, ext, "_small"+ext, 1)
	return m.Small
}
