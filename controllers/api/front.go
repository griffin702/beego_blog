package api

type FrontController struct {
	baseController
}

// @Title GetTest
// @Description get test1
// @Success 200 string
// @router /test/:id [get]
func (c *FrontController) GetTest() {
	c.Data["json"] = "sdsdsd"
	c.ServeJSON()
}
