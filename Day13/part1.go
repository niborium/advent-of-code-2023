package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	data, _ := os.ReadFile("input.txt")
	text := string(data)

	blocks := strings.Split(text, "\r\n\r\n")
	result := 0

	for _, block := range blocks {
		lines := strings.Split(block, "\r\n")

		horizontalMirror := false
		hDuplicateIndex := -1
		lastIndex := -1

		for {
			hDuplicateIndex = -1
			for i := lastIndex + 1; i < len(lines)-1; i++ {
				if lines[i] == lines[i+1] {
					hDuplicateIndex = i
					lastIndex = hDuplicateIndex
					break
				}
			}

			if hDuplicateIndex == -1 {
				break
			}

			distanceToEdge := min(len(lines)-2-hDuplicateIndex, hDuplicateIndex)

			for j := hDuplicateIndex - distanceToEdge; j <= hDuplicateIndex; j++ {
				element1 := lines[j]
				element2 := lines[2*hDuplicateIndex+1-j]

				if element1 == element2 {
					horizontalMirror = true
				} else {
					horizontalMirror = false
					break
				}
			}

			if horizontalMirror {
				break
			}
		}

		if horizontalMirror {
			result += (hDuplicateIndex + 1) * 100
		} else {
			vDuplicateIndex := -1
			verticalMirror := false
			lastIndex = -1

			for {
				vDuplicateIndex = -1
				for j := lastIndex + 1; j < len(lines[0])-1; j++ {
					charsLeft := make([]rune, len(lines))
					charsRight := make([]rune, len(lines))

					for i, line := range lines {
						charsLeft[i] = rune(line[j])
						charsRight[i] = rune(line[j+1])
					}

					if equal(charsLeft, charsRight) {
						vDuplicateIndex = j
						lastIndex = vDuplicateIndex
						break
					}
				}

				if vDuplicateIndex == -1 {
					break
				}

				distanceToEdge := min(len(lines[0])-2-vDuplicateIndex, vDuplicateIndex)

				for j := vDuplicateIndex - distanceToEdge; j <= vDuplicateIndex; j++ {
					element1 := make([]rune, len(lines))
					element2 := make([]rune, len(lines))

					for i, line := range lines {
						element1[i] = rune(line[j])
						element2[i] = rune(line[2*vDuplicateIndex+1-j])
					}

					if equal(element1, element2) {
						verticalMirror = true
					} else {
						verticalMirror = false
						break
					}
				}

				if verticalMirror {
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

func equal(a, b []rune) bool {
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
