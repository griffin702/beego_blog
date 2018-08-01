package admin

import (
	"blog-master/models"
	"strings"
	"strconv"
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
	for _, v := range list {
		arr1 := strings.Split(v.Url, "/")
		filename := arr1[len(arr1)-1]
		arr2 := strings.Split(filename, ".")
		ext := "." + arr2[len(arr2)-1]
		v.Small = strings.Replace(v.Url, ext, "_small"+ext, 1)
	}
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
