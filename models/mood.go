package models

import (
	"github.com/astaxie/beego/orm"
	"regexp"
	"strings"
	"time"
)

//心情表
type Mood struct {
	Id       int64
	Content  string    `orm:"type(text)"`
	Cover    string    `orm:"size(70);default(/static/upload/default/blog-default-0.png)"`
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

func (m *Mood) ChangetoSmall() string {
	arr1 := strings.Split(m.Cover, "/")
	filename := arr1[len(arr1)-1]
	arr2 := strings.Split(filename, ".")
	ext := "." + arr2[len(arr2)-1]
	small := strings.Replace(m.Cover, ext, "_small"+ext, 1)
	return small
}

func (m *Mood) GetDesc() string {
	//将HTML标签全转换成小写
	re, _ := regexp.Compile("\\<[\\S\\s]+?\\>")
	rep := re.ReplaceAllStringFunc(m.Content, strings.ToLower)
	//去除所有尖括号内的HTML代码
	re, _ = regexp.Compile("\\<[\\S\\s]+?\\>")
	rep = re.ReplaceAllString(rep, "")
	return rep
}
