package models

import (
	"bytes"
	"fmt"
	"math"
)

type Pager struct {
	Page      int64
	Totalnum  int64
	Totalpage int64
	Pagesize  int64
	urlpath   string
	postId    int64
}

func NewPager(page, totalnum, pagesize int64, urlpath string, arg ...int64) *Pager {
	p := new(Pager)
	p.Page = page
	p.Totalnum = totalnum
	p.Pagesize = pagesize
	p.urlpath = urlpath
	if len(arg) > 0 {
		p.postId = arg[0]
	}
	return p
}

func (this *Pager) url(page int64) string {
	ret := fmt.Sprintf(this.urlpath, page)
	if this.postId > 0 {
		ret = fmt.Sprintf(this.urlpath, this.postId, page)
	}
	return ret
}

func (this *Pager) ToString() string {
	if this.Totalnum <= this.Pagesize {
		return ""
	}
	var buf bytes.Buffer
	var from, to, linknum, offset, totalpage int64
	var omit string
	offset = 2
	linknum = 4
	if this.Page < 3 {
		linknum = 5
	}
	totalpage = int64(math.Ceil(float64(this.Totalnum) / float64(this.Pagesize)))
	this.Totalpage = totalpage
	if totalpage < linknum {
		from = 1
		to = totalpage
	} else {
		from = this.Page - offset
		to = from + linknum
		if from < 1 {
			from = 1
			to = from + linknum - 1
		} else if to > totalpage {
			to = totalpage
			from = totalpage - linknum + 1
		}
	}
	buf.WriteString("<ul class=\"pagination\">")
	if this.Page > 1 {
		buf.WriteString(fmt.Sprintf("<li><a href=\"%s\">上一页</a></li>", this.url(this.Page-1)))
	} else {
		buf.WriteString("<li class=\"disabled\"><a>上一页</a></li>")
	}
	if this.Page >= linknum {
		if this.Page-linknum > 0 && totalpage != 5 {
			omit = "..."
		}
		if totalpage != 4 {
			buf.WriteString(fmt.Sprintf("<li><a href=\"%s\">1%s</a></li>", this.url(1), omit))
		}
	}
	for i := from; i <= to; i++ {
		if i == this.Page {
			buf.WriteString(fmt.Sprintf("<li class=\"active\"><a>%d</a></li>", i))
		} else {
			buf.WriteString(fmt.Sprintf("<li><a href=\"%s\">%d</a></li>", this.url(i), i))
		}
	}
	if totalpage > to {
		if totalpage-to > 1 {
			omit = "..."
		}
		buf.WriteString(fmt.Sprintf("<li><a href=\"%s\">%s%d</a></li>", this.url(totalpage), omit, totalpage))
	}
	if this.Page < totalpage {
		buf.WriteString(fmt.Sprintf("<li><a href=\"%s\">下一页</a></li>", this.url(this.Page+1)))
	} else {
		buf.WriteString(fmt.Sprintf("<li class=\"disabled\"><a>下一页</a></li>"))
	}
	buf.WriteString("</ul>")
	return buf.String()
}
