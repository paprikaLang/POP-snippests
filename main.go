package main

import (
	"fmt"
	"interface-duck/fake"
	"interface-duck/real"
)

type Receiver interface {
	Get(url string) string
}

type Poster interface {
	Post(url string, form map[string]string) string
}

const url = "http://www.github.com"

func download(r Receiver) string {
	return r.Get(url)
}
func post(poster Poster) {
	poster.Post(url,
		map[string]string{
			"name":   "ccmouse",
			"course": "golang",
		})
}

type ReceiverPoster interface {
	Receiver
	Poster
}

func session(s ReceiverPoster) string {
	s.Post(url, map[string]string{
		"contents": "another fake github.com",
	})
	return s.Get(url)
}

func main() {
	var r Receiver

	// s := &fake.Receiver{"this is a fake github"}
	// r = s
	// fmt.Println(session(s))

	r = real.Receiver{"paprikaLang"}
	fmt.Println(download(r))

	inspect(r)
}

func inspect(r Receiver) {
	fmt.Printf("%T %v\n", r, r)
	switch v := r.(type) {
	case *fake.Receiver:
		fmt.Println("Contents:", v.Contents)
	case real.Receiver:
		fmt.Println("UserAgent:", v.UserAgent)
	}
}
