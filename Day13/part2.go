package main

import (
	"fmt"
	"os"
	"strings"
)

func offByOneCompare(firstString, secondString []string) bool {
	if len(firstString) == 0 || len(secondString) == 0 {
		return false
	}
	differences := 0
	for i := 0; i < len(firstString); i++ {
		left := firstString[i]
		right := secondString[i]
		if left != right {
			differences++
		}
	}
	return differences == 1
}

func main() {
	data, _ := os.ReadFile("input.txt")
	text := string(data)

	blocks := strings.Split(text, "\r\n\r\n")
	var result int

	for _, block := range blocks {
		lines := strings.Split(block, "\r\n")

		horizontalMirror := false
		horizontalFound := false
		hDuplicateIndex := -1
		lastIndex := -1

		for {
			hDuplicateIndex = -1
			for index := lastIndex + 1; index < len(lines)-1; index++ {
				if lines[index] == lines[index+1] || offByOneCompare(strings.Split(lines[index], ""), strings.Split(lines[index+1], "")) {
					hDuplicateIndex = index
					break
				}
			}
			lastIndex = hDuplicateIndex
			if hDuplicateIndex == -1 {
				break
			}

			distanceToEdge := min(len(lines)-2-hDuplicateIndex, hDuplicateIndex)

			smudge := false
			for j := hDuplicateIndex - distanceToEdge; j <= hDuplicateIndex; j++ {
				element1 := lines[j]
				element2 := lines[2*hDuplicateIndex+1-j]
				if element1 == element2 {
					horizontalMirror = true
				} else {
					if !smudge && offByOneCompare(strings.Split(element1, ""), strings.Split(element2, "")) {
						smudge = true
						horizontalMirror = true
					} else {
						horizontalMirror = false
						break
					}
				}
			}
			if horizontalMirror && smudge {
				horizontalFound = true
				break
			}
		}

		if horizontalFound {
			result += (hDuplicateIndex + 1) * 100
		} else {
			vDuplicateIndex := -1
			verticalMirror := false
			lastIndex = -1

			for {
				vDuplicateIndex = -1
				for j := lastIndex + 1; j < len(lines[0]); j++ {
					charsLeft := make([]string, len(lines))
					charsRight := make([]string, len(lines))
					for i := range lines {
						charsLeft[i] = string(lines[i][j])
						charsRight[i] = string(lines[i][j+1])
					}

					if equal(charsLeft, charsRight) || offByOneCompare(charsLeft, charsRight) {
						vDuplicateIndex = j
						break
					}
				}
				lastIndex = vDuplicateIndex
				if vDuplicateIndex == -1 {
					break
				}

				distanceToEdge := min(len(lines[0])-2-vDuplicateIndex, vDuplicateIndex)

				smudge := false
				for j := vDuplicateIndex - distanceToEdge; j <= vDuplicateIndex; j++ {
					element1 := make([]string, len(lines))
					element2 := make([]string, len(lines))
					for i := range lines {
						element1[i] = string(lines[i][j])
						element2[i] = string(lines[i][2*vDuplicateIndex+1-j])
					}

					if equal(element1, element2) {
						verticalMirror = true
					} else {
						if !smudge && offByOneCompare(element1, element2) {
							smudge = true
							verticalMirror = true
						} else {
							verticalMirror = false
							break
						}
					}
				}
				if verticalMirror && smudge {
					break
				}
			}
			result += vDuplicateIndex + 1
		}
	}
	fmt.Println(result)
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func equal(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i, v := range a {
		if v != b[i] {
			return false
		}
	}
	return true
}
