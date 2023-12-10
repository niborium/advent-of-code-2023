package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type Point struct {
    x, y int
}

var (
    adj        = make(map[Point][]Point)
    start      = Point{0, 0}
    maxX, maxY int
    input      []string
    seen       = make(map[Point]bool)
    toProcess  = []Point{}
    currDist   = 0
    total      = 0
    ins        = make(map[Point]bool)
)

func main() {
    file, _ := os.Open(os.Args[1])
    defer file.Close()

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        input = append(input, scanner.Text())
    }

    for y, line := range input {
        maxY = y
        for x, c := range line {
            maxX = x
            if c == 'S' {
                start = Point{x, y}
            } else if c == '|' {
                adj[Point{x, y}] = []Point{{x, y + 1}, {x, y - 1}}
            } else if c == '-' {
                adj[Point{x, y}] = []Point{{x - 1, y}, {x + 1, y}}
            } else if c == 'L' {
                adj[Point{x, y}] = []Point{{x, y - 1}, {x + 1, y}}
            } else if c == 'J' {
                adj[Point{x, y}] = []Point{{x, y - 1}, {x - 1, y}}
            } else if c == '7' {
                adj[Point{x, y}] = []Point{{x, y + 1}, {x - 1, y}}
            } else if c == 'F' {
                adj[Point{x, y}] = []Point{{x, y + 1}, {x + 1, y}}
            }
        }
    }

    adj[start] = []Point{}
    for k, v := range adj {
        if pointInSlice(start, v) {
            adj[start] = append(adj[start], k)
        }
    }

    toProcess = append(toProcess, start)
    for len(toProcess) > 0 {
        curr := toProcess[0]
        toProcess = toProcess[1:]
        seen[curr] = true
        for _, new := range adj[curr] {
            if !seen[new] {
                toProcess = append(toProcess, new)
            }
        }
    }

    for currY := 0; currY <= maxY; currY++ {
        for currX := 0; currX <= maxX; currX++ {
            if !seen[Point{currX, currY}] {
                lefts := []int{}
                for x := 0; x < currX; x++ {
                    if seen[Point{x, currY}] {
                        lefts = append(lefts, x)
                    }
                }
                passesLeft := 0
                last := ""
                for _, x := range lefts {
                    if input[currY][x] == '|' {
                        passesLeft++
                    } else if input[currY][x] == 'J' {
                        if last == "F" {
                            passesLeft++
                        }
                    } else if input[currY][x] == '7' {
                        if last == "L" {
                            passesLeft++
                        }
                    }
                    if strings.Contains("LJF7", string(input[currY][x])) {
                        last = string(input[currY][x])
                    }
                }
                if passesLeft%2 == 1 {
                    total++
                    ins[Point{currX, currY}] = true
                }
            }
        }
    }

    for y := 0; y <= maxY; y++ {
        for x := 0; x <= maxX; x++ {
            if seen[Point{x, y}] {
                fmt.Print(string(input[y][x]))
            } else if ins[Point{x, y}] {
                fmt.Print("I")
            } else {
                fmt.Print("O")
            }
        }
        fmt.Println()
    }
    fmt.Println(total)
}

func pointInSlice(a Point, list []Point) bool {
    for _, b := range list {
        if b == a {
            return true
        }
    }
    return false
}

//go run part2.go input.txt - last line tiles