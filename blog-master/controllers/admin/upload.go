package admin

import (
	"fmt"
	"github.com/ulricqin/goutils/filetool"
	"regexp"
	"time"
	"strconv"
	"github.com/nfnt/resize"
	"os"
	"image/jpeg"
	"io"
	"image/png"
	"image"
	"image/gif"
)

type FileuploadController struct {
	baseController
}

type Sizer interface {
	Size() int64
}

const (
	LOCAL_FILE_DIR    = "static/upload"
	MIN_FILE_SIZE     = 1       // bytes
	MAX_FILE_SIZE     = 5000000 // bytes
	IMAGE_TYPES       = "(jpg|gif|p?jpeg|(x-)?png)"
)

var (
	typemap = map[int]string{1:"bigpic",2:"smallpic",3:"bigsmallpic"}
	acceptFileTypes = regexp.MustCompile(IMAGE_TYPES)
)

type FileInfo struct {
	Url          string `json:"url,omitempty"`
	Name         string `json:"name"`
	Type         string `json:"type"`
	Size         int64  `json:"size"`
	Error        string `json:"error,omitempty"`
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

func (this *FileuploadController) Upload() {
	f, h, err := this.GetFile("filedata")
	if f != nil {
		defer  f.Close()
	}
	utype := this.GetString("type")
		if utype == "" {
			utype = "1"
		}
	Out := map[string]string{"err":"","msg":""}
	if err != nil {
		Out["err"] = "no file"
	} else {
		ext := filetool.Ext(h.Filename)
		fi := &FileInfo{
			Name: h.Filename,
			Type: ext,
		}
		if !fi.ValidateType() {
			Out["err"] = "invalid file type"
		}
		if sizeInterface, ok := f.(Sizer); ok {
			fi.Size = sizeInterface.Size()
		}
		if !fi.ValidateSize() {
			Out["err"] = fi.Error
		}
		if Out["err"] == "" {
			index, _ := strconv.Atoi(utype)
			fileSaveName := fmt.Sprintf("%s/%s/%s", LOCAL_FILE_DIR, typemap[index], time.Now().Format("20060102"))
			imgPath := fmt.Sprintf("%s/%d%s", fileSaveName, time.Now().UnixNano(), ext)
			filetool.InsureDir(fileSaveName)
			if index == 1 {//上传类型1：只保存大图
				err = this.SaveToFile("filedata", imgPath)
				if err != nil {
				Out["err"] = err.Error()
				} else {
				Out["msg"] = "/" + imgPath
				}
			} else if index == 2 {//上传类型2：只保存小图
				w, _ := strconv.Atoi(this.GetString("w"))
				h, _ := strconv.Atoi(this.GetString("h"))
				err = createSmallPic(f, imgPath, w, h, ext)
				if err != nil {
					Out["err"] = err.Error()
				} else {
					Out["msg"] = "/" + imgPath
				}
			} else if index == 3 {//上传类型3：同时保存大图小图
				err = this.SaveToFile("filedata", imgPath)
				if err != nil {
					Out["err"] = err.Error()
				} else {
					Out["msg"] = "/" + imgPath
				}
				imgPathsmall := fmt.Sprintf("%s/%d_small%s", fileSaveName, time.Now().UnixNano(), ext)
				w, _ := strconv.Atoi(this.GetString("w"))
				h, _ := strconv.Atoi(this.GetString("h"))
				err = createSmallPic(f, imgPathsmall, w, h, ext)
				if err != nil {
					Out["err"] = err.Error()
				}
			}
		}
	}
	this.Data["json"] = Out
	this.ServeJSON()
}

func createSmallPic(file io.Reader, fileSmall string, w, h int, ext string) error {
	// decode jpeg into image.Image
	var img image.Image
	var err error
	switch ext {
	case ".jpeg":
		img, err = jpeg.Decode(file)
	case ".jpg":
		img, err = jpeg.Decode(file)
	case ".png":
		img, err = png.Decode(file)
	case ".gif":
		img, err = gif.Decode(file)
	}
	if err != nil {
		return err
	}
	b := img.Bounds()
	if w > b.Dx() {
		w = b.Dx()
	}
	if h > b.Dy() {
		h = b.Dy()
	}
	// resize to width 1000 using Lanczos resampling
	// and preserve aspect ratio
	m := resize.Resize(uint(w), uint(h), img, resize.Lanczos3)

	out, err := os.Create(fileSmall)
	if err != nil {
		return err
	}
	defer out.Close()

	switch ext {
	case ".jpeg":
		return jpeg.Encode(out, m, nil)
	case ".jpg":
		return jpeg.Encode(out, m, nil)
	case ".png":
		return png.Encode(out, m)
	case ".gif":
		return gif.Encode(out, m, nil)
	}
	return err
}
