package models

import (
	"github.com/astaxie/beego/orm"
	"time"
	"math"
	"fmt"
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
	Obj_pk_type       int64     `orm:"index"`     //0-文章评论，1-友链评论
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
	err := reply_pk.Query().Filter("Id", key).RelatedSel("user").Limit(1).One(&reply_pk)
	if err != nil {
		return "",err
	}
	return reply_pk.User.Nickname, nil
}

func (m *Comments) Return_PkId(key int64) (int64, error) {
	var reply_pk Comments
	err := reply_pk.Query().Filter("Id", key).RelatedSel("user").Limit(1).One(&reply_pk)
	if err != nil {
		return 0,err
	}
	return reply_pk.User.Id, nil
}

func (m *Comments) Return_PkContent(key int64) (string, error) {
	var reply_pk Comments
	err := reply_pk.Query().Filter("Id", key).RelatedSel("user").Limit(1).One(&reply_pk)
	if err != nil {
		return "",err
	}
	return reply_pk.Comment, nil
}

func (m *Comments) Return_limit(key string) (string) {
	data := []rune(m.Comment)
	if len(data) > 25 {
		return string(data[:25])+"..."
	}
	return m.Comment
}

//title换行显示
func (m *Comments) Titleln() string {
	data := []rune(m.Comment)
	if len(data) > 20 {
		for num := int(math.Floor(float64(len(data))/20)); num > 0; num-- {
			copydata := make([]rune,0)
			copydata = append(copydata, data[:20*num]...)
			copydata = append(copydata, []rune("\n")...)
			data = append(copydata,data[20*num:]...)
		}
		return string(data)
	}
	return m.Comment
}

func (m *Comments) ShowSubTime() string {
	sub := int(time.Since(m.Submittime).Minutes())
	if sub <= 10 {
		return "刚刚"
	} else if sub > 10 && sub <= 60 {
		return "10分钟前"
	} else if sub > 60 && sub <= 1440 {
		return fmt.Sprintf("%d小时前", sub/60)
	} else if sub > 1440 && sub <= 43200 {
		return fmt.Sprintf("%d天前", sub/1440)
	} else if sub > 43200 && sub <= 525600 {
		return fmt.Sprintf("%d个月前", sub/43200)
	} else {
		return fmt.Sprintf("%d年前", sub/525600)
	}
}