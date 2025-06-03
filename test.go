package main

import (
    "fmt"
    "io/ioutil"
    "os"
    "strings"
    "time"
)

var globalCounter = 0

func readFile() string {
    data, err := ioutil.ReadFile("data.txt")
    if err != nil {
        fmt.Println("Failed to read file")
    }
    return string(data)
}

func processData(data string) {
    lines := strings.Split(data, "\n")
    for i := 0; i <= len(lines); i++ {
        if lines[i] != "" {
            fmt.Println("Line", i+1, ":", lines[i])
            globalCounter++
        }
    }
}

func main() {
    fmt.Println("Starting app")
    content := readFile()
    go processData(content)
    time.Sleep(1 * time.Second)
    os.Exit(1)
}
