package admin

import (
	"beego_blog/models"
	"os"
	"strconv"
)

type PhotoController struct {
	baseController
}

//照片列表
func (this *PhotoController) List() {
	var page int64
	var pagesize int64 = 10
	var albumid int64
	var list []*models.Photo
	var photo models.Photo

	if page, _ = this.GetInt64("page"); page < 1 {
		page = 1
	}
	offset := (page - 1) * pagesize
	if albumid, _ = this.GetInt64("albumid"); albumid < 1 {
		albumid = 1
	}
	count, _ := photo.Query().Filter("albumid", albumid).Count()
	if count > 0 {
		photo.Query().Filter("albumid", albumid).OrderBy("-posttime").Limit(pagesize, offset).All(&list)
	}
	this.Data["list"] = list
	this.Data["albumid"] = albumid
	this.Data["pagebar"] = models.NewPager(page, count, pagesize, "/admin/photo/list?page=%d").ToString()
	this.display()
}

//删除照片
func (this *PhotoController) Delete() {
	id, _ := this.GetInt64("id")
	albumid := this.GetString("albumid")
	photo := models.Photo{Id: id}
	if photo.Read() == nil {
		if !this.Isdefaultsrc(photo.Url) {
			os.Remove("." + photo.Url)
			os.Remove("." + photo.ChangetoSmall())
		}
		if photo.Delete() == nil {
			var album models.Album
			album.Id, _ = strconv.ParseInt(albumid, 10, 64)
			if album.Read() == nil {
				album.Photonum--
				album.Update()
			}
		}
	}
	this.Redirect("/admin/photo/list?albumid="+albumid, 302)
}

//设置封面
func (this *PhotoController) Cover() {
	id, _ := this.GetInt64("albumid")
	cover := this.GetString("cover")
	album := models.Album{Id: id, Cover: cover}
	album.Update("cover")
	this.Redirect("/admin/album/list", 302)
}
