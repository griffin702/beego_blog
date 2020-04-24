package admin

import (
	"beego_blog/models"
	"bytes"
	"errors"
	"fmt"
	"github.com/nfnt/resize"
	"github.com/ulricqin/goutils/filetool"
	"image"
	"image/gif"
	"image/jpeg"
	"image/png"
	"io"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
	"time"
)

type FileuploadController struct {
	baseController
}

type Sizer interface {
	Size() int64
}

const (
	LOCAL_FILE_DIR   = "static/upload"
	MIN_FILE_SIZE    = 1        // bytes
	MAX_FILE_SIZE    = 10000000 // bytes
	MAX_WIDTH_HEIGHT = 1280
	IMAGE_TYPES      = "(jpg|gif|p?jpeg|(x-)?png)"
)

var (
	typemap         = map[int]string{1: "bigpic", 2: "smallpic", 3: "bigsmallpic", 4: "media/mp4", 5: "media/mp3"}
	acceptFileTypes = regexp.MustCompile(IMAGE_TYPES)
)

type FileInfo struct {
	Url   string `json:"url,omitempty"`
	Name  string `json:"name"`
	Type  string `json:"type"`
	Size  int64  `json:"size"`
	Error string `json:"error,omitempty"`
}

func (fi *FileInfo) ValidateType() (valid bool) {
	if acceptFileTypes.MatchString(fi.Type) {
		return true
	}
	fi.Error = "Filetype not allowed"
	return false
}

func (fi *FileInfo) ValidateSize() (valid bool) {
	if fi.Size < MIN_FILE_SIZE {
		fi.Error = "File is too small"
	} else if fi.Size > MAX_FILE_SIZE {
		fi.Error = "File is too big"
	} else {
		return true
	}
	return false
}

//插入照片
func (this *FileuploadController) Insert(albumid int64, desc, url string) {
	var photo models.Photo
	photo.Albumid = albumid
	photo.Des = desc
	photo.Posttime, _ = time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
	photo.Url = url
	if err := photo.Insert(); err != nil {
		this.showmsg(err.Error())
	} else {
		var album models.Album
		album.Id = albumid
		if album.Read() == nil {
			album.Photonum++
			album.Update()
		}
	}
}

func (this *FileuploadController) Upload() {
	Out := map[string]interface{}{"success": "", "message": "", "url": ""}
	f, h, err := this.GetFile("editormd-image-file")
	if err != nil {
		Out["success"] = 0
		Out["message"] = err
	}
	dialog_id := this.GetString("guid")
	if f != nil {
		defer f.Close()
	}
	rwidth, rheight, fm, err := RetRealWHEXT(f)
	f, h, err = this.GetFile("editormd-image-file")
	utype := this.GetString("type")
	if utype == "" {
		utype = "1"
	}
	if err != nil {
		Out["success"] = 0
		Out["message"] = err
	} else {
		fi := &FileInfo{
			Name: h.Filename,
			Type: fm,
		}
		if !fi.ValidateType() {
			Out["success"] = 0
			Out["message"] = "invalid file type"
		}
		if sizeInterface, ok := f.(Sizer); ok {
			fi.Size = sizeInterface.Size()
		}
		if !fi.ValidateSize() {
			Out["success"] = 0
			Out["message"] = fi.Error
		}
		if Out["message"] == "" {
			index, _ := strconv.Atoi(utype)
			timenow := time.Now().UnixNano()
			fileSaveName := fmt.Sprintf("%s/%s/%s", LOCAL_FILE_DIR, typemap[index], time.Now().Format("20060102"))
			imgPath := fmt.Sprintf("%s/%d.%s", fileSaveName, timenow, fm)
			_ = filetool.InsureDir(fileSaveName)
			if index == 1 { //上传类型1：文章上传的图片，默认显示像素最大为
				//err = this.SaveToFile("editormd-image-file", imgPath)
				err = createSmallPic_scale(f, imgPath, 0, 0, 88)
				if err != nil {
					Out["success"] = 0
					Out["message"] = err.Error()
				}
				sw, sh := RetMaxWH(rwidth, rheight, 720)
				small := ChangetoSmall(imgPath)
				f, _, _ = this.GetFile("editormd-image-file")
				err = createSmallPic_scale(f, small, sw, sh, 88)
				if err != nil {
					Out["success"] = 0
					Out["message"] = err.Error()
				} else {
					Out["success"] = 1
					Out["message"] = "上传成功"
					Out["url"] = "/" + small
					Out["dialog_id"] = dialog_id
				}
			} else if index == 2 { //上传类型2：头像、封面等上传，只保存小图
				w, _ := strconv.Atoi(this.GetString("w"))
				h, _ := strconv.Atoi(this.GetString("h"))
				err = createSmallPic_scale(f, imgPath, w, h, 88)
				if err != nil {
					Out["success"] = 0
					Out["message"] = err.Error()
				} else {
					//保存成功，则删除旧资源
					lastsrc := this.GetString("lastsrc")
					if lastsrc != "" && !this.Isdefaultsrc(lastsrc) {
						_ = os.Remove("." + lastsrc)
					}
					Out["success"] = 1
					Out["message"] = "上传成功"
					Out["url"] = "/" + imgPath
					Out["dialog_id"] = dialog_id
				}
			} else if index == 3 { //上传类型3：照片上传，同时保存大图小图
				lastsrc := this.GetString("lastsrc")
				//err = this.SaveToFile("editormd-image-file", imgPath)
				err = createSmallPic_scale(f, imgPath, 0, 0, 88)
				if err != nil {
					Out["success"] = 0
					Out["message"] = err.Error()
				} else {
					Out["success"] = 1
					Out["message"] = "上传成功"
					Out["url"] = "/" + imgPath
					Out["dialog_id"] = dialog_id
				}
				albumid, _ := this.GetInt64("albumid")
				f, _, _ = this.GetFile("editormd-image-file")
				if albumid == 0 {
					sw, sh := RetMaxWH(rwidth, rheight, 200)
					err = createSmallPic_scale(f, ChangetoSmall(imgPath), sw, sh, 88)
				} else {
					err = createSmallPic_clip(f, ChangetoSmall(imgPath), rwidth, rheight, 88)
				}
				if err != nil {
					Out["success"] = 0
					Out["message"] = err.Error()
				} else {
					//保存成功，则删除旧资源
					if lastsrc != "" && !this.Isdefaultsrc(lastsrc) {
						_ = os.Remove("." + lastsrc)
						_ = os.Remove("." + ChangetoSmall(lastsrc))
					}
				}
				if albumid > 0 {
					this.Insert(albumid, fi.Name, Out["url"].(string))
				}
			}
		}
	}
	this.Data["json"] = Out
	this.ServeJSON()
}

func (this *FileuploadController) UploadFile() {
	Out := map[string]interface{}{"success": "", "message": "", "url": ""}
	utype := this.GetString("type")
	if utype == "" {
		Out["success"] = 0
		Out["message"] = "非法请求"
	}
	_, h, err := this.GetFile("filemedia")
	if err != nil {
		Out["success"] = 0
		Out["message"] = err
		this.Data["json"] = Out
		this.ServeJSON()
		return
	}
	ext := strings.Split(h.Filename, ".")[1]
	index, _ := strconv.Atoi(utype)
	if index == 4 && ext != "mp4" {
		Out["success"] = 0
		Out["message"] = "仅允许上传格式：MP4"
	}
	if index == 5 && ext != "mp3" {
		Out["success"] = 0
		Out["message"] = "仅允许上传格式：MP3"
	}
	if Out["message"] == "" {
		timenow := time.Now().UnixNano()
		fileSaveName := fmt.Sprintf("%s/%s/%s", LOCAL_FILE_DIR, typemap[index], time.Now().Format("20060102"))
		mediaPath := fmt.Sprintf("%s/%d.%s", fileSaveName, timenow, ext)
		mediajpgPath := fmt.Sprintf("%s/%d.jpg", fileSaveName, timenow)
		_ = filetool.InsureDir(fileSaveName)
		err = this.SaveToFile("filemedia", mediaPath)
		if err != nil {
			Out["success"] = 0
			Out["message"] = err.Error()
		} else {
			Out["success"] = 1
			Out["message"] = "上传成功"
			Out["url"] = "/" + mediaPath
			if index == 4 {
				if err := GetFrame(mediaPath, mediajpgPath); err != nil {
					fmt.Println(err)
				}
				Out["jpgurl"] = "/" + mediajpgPath
			}
		}
	}
	this.Data["json"] = Out
	this.ServeJSON()
}

/*
* 图片裁剪
* 入参:1、file，2、输出路径，3、原图width，4、原图height，5、精度
* 规则:照片生成缩略图尺寸为190*135，先进行缩小，再进行平均裁剪
*
* 返回:error
 */
func createSmallPic_clip(in io.Reader, fileSmall string, w, h, quality int) error {
	x0 := 0
	x1 := 190
	y0 := 0
	y1 := 135
	sh := h * 190 / w
	sw := w * 135 / h
	origin, fm, err := image.Decode(in)
	if err != nil {
		return err
	}
	if sh > 135 {
		origin = resize.Resize(uint(190), uint(sh), origin, resize.Lanczos3)
		y0 = (sh - 135) / 4
		y1 = y0 + 135
	} else {
		origin = resize.Resize(uint(sw), uint(135), origin, resize.Lanczos3)
		x0 = (sw - 190) / 2
		x1 = x0 + 190
	}
	out, err := os.Create(fileSmall)
	if err != nil {
		return err
	}
	switch fm {
	case "jpeg":
		img := origin.(*image.YCbCr)
		subImg := img.SubImage(image.Rect(x0, y0, x1, y1)).(*image.YCbCr)
		return jpeg.Encode(out, subImg, &jpeg.Options{quality})
	case "png":
		switch origin.(type) {
		case *image.NRGBA:
			img := origin.(*image.NRGBA)
			subImg := img.SubImage(image.Rect(x0, y0, x1, y1)).(*image.NRGBA)
			return png.Encode(out, subImg)
		case *image.RGBA:
			img := origin.(*image.RGBA)
			subImg := img.SubImage(image.Rect(x0, y0, x1, y1)).(*image.RGBA)
			return png.Encode(out, subImg)
		}
	case "gif":
		img := origin.(*image.Paletted)
		subImg := img.SubImage(image.Rect(x0, y0, x1, y1)).(*image.Paletted)
		return gif.Encode(out, subImg, &gif.Options{})
	default:
		return errors.New("ERROR FORMAT")
	}
	return nil
}

/*
* 缩略图生成
* 入参:1、file，2、输出路径，3、输出width，4、输出height，5、精度
* 规则: width,height是想要生成的尺寸
*
* 返回:error
 */
func createSmallPic_scale(in io.Reader, fileSmall string, width, height, quality int) error {
	origin, fm, err := image.Decode(in)
	if err != nil {
		return err
	}
	if width == 0 || height == 0 {
		width = origin.Bounds().Max.X
		height = origin.Bounds().Max.Y
		//限制保存原图的长宽最大允许像素
		maxnum := MAX_WIDTH_HEIGHT
		if width < height && height > maxnum {
			width = width * maxnum / height
			height = maxnum
		} else if width >= height && width > maxnum {
			height = height * maxnum / width
			width = maxnum
		}
	}
	if quality == 0 {
		quality = 100
	}
	canvas := resize.Resize(uint(width), uint(height), origin, resize.Lanczos3)
	out, err := os.Create(fileSmall)
	if err != nil {
		return err
	}
	switch fm {
	case "jpeg":
		return jpeg.Encode(out, canvas, &jpeg.Options{quality})
	case "png":
		return png.Encode(out, canvas)
	case "gif":
		return gif.Encode(out, canvas, &gif.Options{})
	default:
		return errors.New("ERROR FORMAT")
	}
}

func ChangetoSmall(src string) string {
	arr1 := strings.Split(src, "/")
	filename := arr1[len(arr1)-1]
	arr2 := strings.Split(filename, ".")
	ext := "." + arr2[len(arr2)-1]
	small := strings.Replace(src, ext, "_small"+ext, 1)
	return small
}

func RetMaxWH(w, h, max int) (int, int) {
	var sw, sh int
	if w < h && h > max {
		sh = max
		sw = w * max / h
	} else if w >= h && w > max {
		sw = max
		sh = h * max / w
	} else {
		sw = w
		sh = h
	}
	return sw, sh
}

func RetRealWHEXT(in io.Reader) (int, int, string, error) {
	origin, fm, err := image.Decode(in)
	if err != nil {
		return 0, 0, "", err
	}
	w := origin.Bounds().Max.X
	h := origin.Bounds().Max.Y
	return w, h, fm, err
}

func GetFrame(filename string, mediajpgPath string) *bytes.Buffer {
	cmd := exec.Command("ffmpeg", "-i", filename, "-y", "-f", "image2", "-t", "0.001", mediajpgPath)
	buf := new(bytes.Buffer)
	cmd.Stdout = buf
	if err := cmd.Run(); err != nil {
		fmt.Println(err)
	}
	return buf
}
