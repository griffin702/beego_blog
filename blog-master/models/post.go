package models

import (
	"bytes"
	"fmt"
	"github.com/astaxie/beego/orm"
	"strings"
	"time"
)

type Post struct {
	Id       int64
	User     *User       `orm:"rel(fk);index"`
	Title    string      `orm:"size(100);index"`
	Color    string      `orm:"size(7);index"`
	Urlname  string      `orm:"size(100);index"`
	Urltype  int8        `orm:"index"`
	Content  string      `orm:"type(text)"`
	Tags     string      `orm:"size(100);index"`
	Posttime time.Time   `orm:"type(datetime);index"`
	Views    int64       `orm:"index"`
	Status   int8        `orm:"index"`
	Updated  time.Time   `orm:"type(datetime);index"`
	Istop    int8        `orm:"index"`
	Cover    string      `orm:"size(70);default(/static/upload/defaultcover.png)"`
	Comments []*Comments `orm:"reverse(many)"`
}

func (m *Post) TableName() string {
	return TableName("post")
}

func (m *Post) Insert() error {
	if _, err := orm.NewOrm().Insert(m); err != nil {
		return err
	}
	return nil
}

func (m *Post) Read(fields ...string) error {
	if err := orm.NewOrm().Read(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Post) Update(fields ...string) error {
	if _, err := orm.NewOrm().Update(m, fields...); err != nil {
		return err
	}
	return nil
}

func (m *Post) Delete() error {
	if m.Tags != "" {
		o := orm.NewOrm()
		oldtags := strings.Split(strings.Trim(m.Tags, ","), ",")
		//标签统计-1
		o.QueryTable(&Tag{}).Filter("name__in", oldtags).Update(orm.Params{"count": orm.ColValue(orm.ColMinus, 1)})
		//删掉tag_post表的记录
		o.QueryTable(&TagPost{}).Filter("postid", m.Id).Delete()
	}
	if _, err := orm.NewOrm().Delete(m); err != nil {
		return err
	}
	return nil
}

func (m *Post) Query() orm.QuerySeter {
	return orm.NewOrm().QueryTable(m)
}

//带颜色的标题
func (m *Post) ColorTitle() string {
	if m.Color != "" {
		return fmt.Sprintf("<span style=\"color:%s\">%s</span>", m.Color, m.Title)
	} else {
		return m.Title
	}
}

//内容URL
func (m *Post) Link() string {
	if m.Urlname != "" {
		if m.Urltype == 1 {
			return fmt.Sprintf("/%s", Rawurlencode(m.Urlname))
		}
		return fmt.Sprintf("/article/%s", Rawurlencode(m.Urlname))
	}
	return fmt.Sprintf("/article/%d", m.Id)
}

//带链接的标签
func (m *Post) TagsLink() string {
	if m.Tags == "" {
		return ""
	}
	var buf bytes.Buffer
	arr := strings.Split(strings.Trim(m.Tags, ","), ",")
	for k, v := range arr {
		if k > 0 {
			buf.WriteString(", ")
		}
		tag := Tag{Name: v}
		buf.WriteString(tag.Link())
	}
	return buf.String()
}

//摘要
func (m *Post) Excerpt() string {
	//如果断定截取的断点可能会存在中文字符，则需要转为rune后再截取，否则可能会截成乱码
	data := []rune(m.Content)
	if i := strings.Index(m.Content, "_ueditor_page_break_tag_"); i != -1 {
		return m.Content[:i]
	}else if i = -1; len(data) > 62{
		return string(data[:62])+"..."
	}
	return m.Content
}

func (m *Post) Del_Excerpt() string {
	if i := strings.Index(m.Content, "_ueditor_page_break_tag_"); i != -1 {
		x := len("_ueditor_page_break_tag_")
		return m.Content[i+x:]
	}
	return m.Content
}

func (post *Post) GetPreAndNext() (pre, next *Post) {
	pre = new(Post)
	next = new(Post)
	err := new(Post).Query().Filter("id__lt", post.Id).Filter("status", 0).Filter("urltype", 0).Limit(1).One(pre)
	if err == orm.ErrNoRows {
		pre = nil
	}
	err = new(Post).Query().Filter("id__gt", post.Id).Filter("status", 0).Filter("urltype", 0).Limit(1).One(next)
	if err == orm.ErrNoRows {
		next = nil
	}
	return
}
