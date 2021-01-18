package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"os"
	"os/exec"
	"time"
)

func env(key, defaultValue string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return defaultValue
}

func main() {
	client, err := newClient("unix", "/tmp/kitty")
	fmt.Println(client, err)

	p := Profile{
		Title:    os.Args[1],
		Commands: os.Args[2:],
	}

	fmt.Println(p)

	if !client.kittyRunning() {
		fmt.Println(client.Start(p))
		return
	}

	var windows []Instance
	client.send(Command{
		Cmd:     "ls",
		Version: []int{0, 19, 3},
	}, &windows)

	fmt.Println(windows)

	for _, w := range windows {
		if tab, ok := w.FindTabByTitle(p.Title); ok {
			fmt.Println(tab)
			client.FocusWindow(tab.ActiveWindowHistory[0])
			return
		}
	}

	client.LaunchWindow(p)
}

type Launch struct {
	Args        []string `json:"args,omitempty"`
	WindowTitle string   `json:"window_title"`
	Cwd         string   `json:"cwd"`
	Type        string   `json:"type"`
}

func (client *Client) kittyRunning() bool {
	switch client.network {
	case "unix":
		_, err := os.Stat(client.addr)
		return !os.IsNotExist(err)
	default:
		return false
	}
}

type Profile struct {
	Title    string
	Commands []string
	Window   string
}

func (client *Client) Start(p Profile) error {
	args := []string{
		"-1",
		"--title", p.Title,
		"-d", "~",
		"--listen-on", fmt.Sprintf("%s:%s", client.network, client.addr),
		"--start-as", "fullscreen",
	}
	args = append(args, p.Commands...)

	output, err := exec.Command(
		"/Applications/kitty.app/Contents/MacOS/kitty",
		args...,
	).CombinedOutput()
	if err != nil {
		fmt.Println(string(output))
		return err
	}

	return nil
}

func (client *Client) LaunchWindow(p Profile) error {
	return client.send(Command{
		Cmd: "launch",
		Payload: Launch{
			Args:        p.Commands,
			Cwd:         "~",
			WindowTitle: p.Title,
			Type:        "os-window",
		},
	}, nil)
}

type Client struct {
	network string
	addr    string
}

func newClient(network, addr string) (*Client, error) {
	return &Client{network: network, addr: addr}, nil
}

const ESC byte = 0x1b

func expect(r *bufio.Reader, content []byte) error {
	buf := make([]byte, len(content))
	r.Read(buf)
	if bytes.Equal(buf, content) {
		return fmt.Errorf("unexpected")
	}
	return nil
}

func (client *Client) read(conn net.Conn) ([]byte, error) {
	r := bufio.NewReader(conn)

	expect(r, []byte{ESC})
	expect(r, []byte("P@kitty-cmd"))

	payload, err := r.ReadBytes(ESC)
	if err != nil {
		return nil, err
	}

	var res struct {
		OK   bool   `json:"ok"`
		Data string `json:"data"`
	}

	if err := json.Unmarshal(payload[:len(payload)-1], &res); err != nil {
		return nil, err
	}

	return []byte(res.Data), nil
}

type Map map[string]interface{}

func (client *Client) FocusWindow(id int) error {
	return client.send(Command{
		Cmd: "focus-window",
		Payload: Map{
			"match": fmt.Sprintf("id:%d", id),
		},
	}, nil)
}

func (client *Client) send(cmd Command, response interface{}) error {
	// <ESC>P@kitty-cmd<JSON object><ESC>\

	conn, err := net.Dial(client.network, client.addr)
	if err != nil {
		return err
	}

	cmd.Version = []int{0, 19, 3}

	req := bytes.NewBuffer(nil)
	req.WriteByte(ESC)
	req.WriteString("P@kitty-cmd")
	c, err := json.Marshal(cmd)
	fmt.Println(string(c))
	req.Write(c)
	req.WriteByte(ESC)
	req.WriteByte('\\')

	fmt.Println(req.Len())
	fmt.Println(req.Bytes())

	if _, err := io.Copy(conn, req); err != nil {
		return err
	}

	fmt.Println("!")

	if cmd.NoResponse {
		return nil
	}

	if response == nil {
		return nil
	}

	conn.SetReadDeadline(time.Now().Add(time.Second))

	resp, err := client.read(conn)
	if err != nil {
		return err
	}

	return json.Unmarshal(resp, &response)
}

type Command struct {
	Cmd        string      `json:"cmd"`
	NoResponse bool        `json:"no_response,omitempty"`
	Version    []int       `json:"version"`
	Payload    interface{} `json:"payload,omitempty"`
}

type Instance struct {
	ID        int   `json:"id"`
	IsFocused bool  `json:"is_focused"`
	Tabs      []Tab `json:"tabs"`
}

func (w Instance) FindTabByTitle(title string) (Tab, bool) {
	for _, tab := range w.Tabs {
		if tab.Title == title {
			return tab, true
		}
	}
	return Tab{}, false
}

type Tab struct {
	ID                  int    `json:"id"`
	Title               string `json:"title"`
	ActiveWindowHistory []int  `json:"active_window_history"`
}
