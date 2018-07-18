package admin

import (
	"fmt"
	"blog-master/models"
	"os"
	"strings"
	"time"
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
		v.Small = strings.Replace(v.Url, "bigpic", "smallpic", 1)
	}
	this.Data["list"] = list
	this.Data["albumid"] = albumid
	this.display()
}

//插入照片
func (this *PhotoController) Insert(albumid int64, desc, url string) {
	var photo models.Photo
	photo.Albumid = albumid
	photo.Des = desc
	photo.Posttime, _ = time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
	photo.Url = url
	if err := photo.Insert(); err != nil {
		this.showmsg(err.Error())
	}
}

//删除照片
func (this *PhotoController) Delete() {
	id, _ := this.GetInt64("id")
	albumid := this.GetString("albumid")
	photo := models.Photo{Id: id}
	if photo.Read() == nil {
		photo.Delete()
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

//上传照片)
func (this *PhotoController) UploadPhoto() {
	file, header, err := this.GetFile("upfile")
	ext := strings.ToLower(header.Filename[strings.LastIndex(header.Filename, "."):])
	out := make(map[string]string)
	out["url"] = ""
	out["fileType"] = ext
	out["original"] = header.Filename
	out["state"] = "SUCCESS"
	filename := ""
	if err != nil {
		out["state"] = err.Error()
	} else {
		t := time.Now().UnixNano()
		day := time.Now().Format("20060102")

		//小图
		savepath := pathArr[2] + day
		if err = os.MkdirAll(savepath, os.ModePerm); err != nil {
			out["state"] = err.Error()
		}
		filename = fmt.Sprintf("%s/%d%s", savepath, t, ext)
		err = createSmallPic(file, filename, 220, 150, ext)
		if err != nil {
			out["state"] = err.Error()
		}

		//大图
		savepath = pathArr[1] + day
		if err = os.MkdirAll(savepath, os.ModePerm); err != nil {
			out["state"] = err.Error()
		}
		filename = fmt.Sprintf("%s/%d%s", savepath, t, ext)
		if err = this.SaveToFile("upfile", filename); err != nil {
			out["state"] = err.Error()
		}
		out["url"] = filename[1:]

	}
	albumid, _ := this.GetInt64("albumid")
	this.Insert(albumid, header.Filename, out["url"])
	this.Data["json"] = out
	this.ServeJSON()
}
