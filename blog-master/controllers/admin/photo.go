package admin

import (
	"blog-master/models"
	"strconv"
	"os"
)

type PhotoController struct {
	baseController
}

//照片列表
func (this *PhotoController) List() {
	var albumid int64
	var list []*models.Photo
	var photo models.Photo

	if albumid, _ = this.GetInt64("albumid"); albumid < 1 {
		albumid = 1
	}
	photo.Query().Filter("albumid", albumid).OrderBy("-posttime").All(&list)
	this.Data["list"] = list
	this.Data["albumid"] = albumid
	this.display()
}

//删除照片
func (this *PhotoController) Delete() {
	id, _ := this.GetInt64("id")
	albumid := this.GetString("albumid")
	photo := models.Photo{Id: id}
	if photo.Read() == nil {
		if !this.Isdefaultsrc(photo.Url) {
			os.Remove("."+photo.Url)
			os.Remove("."+photo.ChangetoSmall())
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
