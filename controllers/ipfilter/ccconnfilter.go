package ipfilter

import (
	"fmt"
	"github.com/astaxie/beego/logs"
	"sync"
	"time"
)

const (
	maxConn        = 6   //同IP最大异常访问数
	checkTimeReset = 120 //重置计数器间隔
	checkTimeDiff  = 5   //异常时间差
)

//cc过滤
type CCConnFilter struct {
	currentConn map[string]int       //当前连接数
	abnConn     map[string]int       //异常连接数
	connTimelog map[string]time.Time //当前访问时间记录
	locker      sync.Mutex           //访问同步锁
}

//创建对象实例
// maxConnCount 同ip最大连接数
func NewCCConnFilter() *CCConnFilter {
	ccf := CCConnFilter{}
	ccf.currentConn = make(map[string]int)
	ccf.abnConn = make(map[string]int)
	ccf.connTimelog = make(map[string]time.Time)
	ccf.locker = sync.Mutex{}
	go func() {
		for {
			time.Sleep(time.Duration(time.Second.Nanoseconds() * checkTimeReset))
			//fmt.Println("清理访问计数器...")
			ccf.locker.Lock()
			ccf.currentConn = make(map[string]int)
			ccf.abnConn = make(map[string]int)
			ccf.connTimelog = make(map[string]time.Time)
			ccf.locker.Unlock()
		}
	}()
	return &ccf
}

func (filter *CCConnFilter) OnConnected(ip string) (bool, string) {
	filter.locker.Lock()
	defer filter.locker.Unlock()
	t := time.Now()
	if v, ok := filter.currentConn[ip]; !ok {
		filter.currentConn[ip] = 1
		filter.abnConn[ip] = 0
		filter.connTimelog[ip] = t
	} else {
		filter.currentConn[ip]++
		//先取上次更新过的时间
		lastconntime := filter.connTimelog[ip]
		//每10次访问更新1次时间
		if (v)%10 == 9 {
			filter.connTimelog[ip] = t
			//明确每10次访问的时间间隔时长低于10s视为异常访问
			if t.Sub(lastconntime) < time.Second*checkTimeDiff {
				filter.abnConn[ip]++
				if filter.abnConn[ip] <= maxConn {
					logs.Warning(fmt.Sprintf("IP:%s,访问成功,LastTime:%s,CurrentTime:%s,间隔:%s,访问过于频繁!\n",
						ip, lastconntime.Format("2006-01-02 15:04:05"),
						t.Format("2006-01-02 15:04:05"), t.Sub(lastconntime)))
					return true, "Warning:您的访问过于频繁!"
				}
			}
		}
		if filter.abnConn[ip] >= maxConn {
			logs.Warning(fmt.Sprintf("IP:%s,拒绝访问,返回500状态,异常访问次数:%d\n", ip, filter.abnConn[ip]))
			return false, "拒绝访问!"
		}
	}
	return true, ""
}

func (filter *CCConnFilter) GetabnConn(ip string) int {
	return filter.abnConn[ip]
}
