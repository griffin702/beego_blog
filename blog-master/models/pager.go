package models

import (
	"bytes"
	"fmt"
	"math"
)

type Pager struct {
	Page        int64
	Totalnum    int64
	Totalpage   int64
	Pagesize    int64
	urlpath     string
	postId      int64
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

	offset = 5
	linknum = 10

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

	buf.WriteString("<div class=\"page\">")
	if this.Page > 1 {
		buf.WriteString(fmt.Sprintf("<a href=\"%s\">&laquo;</a>", this.url(this.Page-1)))
	} else {
		buf.WriteString("<b>&laquo;</b>")
	}

	if this.Page > linknum {
		buf.WriteString(fmt.Sprintf("<a href=\"%s\">1</a>", this.url(1)))
	}

	for i := from; i <= to; i++ {
		if i == this.Page {
			buf.WriteString(fmt.Sprintf("<b>%d</b>", i))
		} else {
			buf.WriteString(fmt.Sprintf("<a href=\"%s\">%d</a>", this.url(i), i))
		}
	}

	if totalpage > to {
		buf.WriteString(fmt.Sprintf("<a href=\"%s\">%d</a>", this.url(totalpage), totalpage))
	}

	if this.Page < totalpage {
		buf.WriteString(fmt.Sprintf("<a href=\"%s\">&raquo;</a>", this.url(this.Page+1)))
	} else {
		buf.WriteString(fmt.Sprintf("<b>&raquo;</b>"))
	}
	buf.WriteString("</div>")

	return buf.String()
}
