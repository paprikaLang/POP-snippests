package fake

type Receiver struct {
	Contents string
}

func (r *Receiver) Get(url string) string {
	return r.Contents
}

//值接收者 和 指针接受者
func (r *Receiver) Post(url string,
	form map[string]string) string {
	r.Contents = form["contents"]
	return "ok"
}
