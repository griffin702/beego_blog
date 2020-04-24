package ipfilter

//连接过滤器接口定义
type ConnFilter interface {
	//客户端连接建立
	//返回false则关闭连接，同时返回需要关闭连接的原因
	OnConnected(ip string) (bool, string)
	GetabnConn(ip string) int
}
