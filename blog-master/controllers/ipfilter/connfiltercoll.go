/*
过滤器集合类
管理一组过滤器，提供统一的外部调用接口
*/

package ipfilter


type ConnFilterColl map[string]ConnFilter

func (filters ConnFilterColl) OnConnected(ip string) (bool, string) {
	for _, f := range filters {
		ret, msg := f.OnConnected(ip)
		if !ret {
			return ret, msg
		} else if ret && msg != "" {
			return ret, msg
		}
	}
	return true, ""
}

func (filters ConnFilterColl) GetabnConn(ip string) (int) {
	for _, f := range filters {
		ret := f.GetabnConn(ip)
		return ret
	}
	return 0
}

var filterCtx ConnFilterColl

//初始化过滤器上下文
func init() {
	filterCtx = make(map[string]ConnFilter)
}

func ConnFilterCtx() ConnFilterColl {
	return filterCtx
}