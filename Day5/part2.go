package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Range struct {
    Start, Length int
}

type MappingEntry struct {
    DestStart, SourceStart, Length int
}

func applyMapping(seed int, mappings []MappingEntry) int {
    for _, m := range mappings {
        if seed >= m.SourceStart && seed < m.SourceStart+m.Length {
            return m.DestStart + (seed - m.SourceStart)
        }
    }
    return seed
}

func processSeeds(seedRanges []Range, mappings map[string][]MappingEntry) int {
    lowestLocation := int(^uint(0) >> 1)

    for _, seedRange := range seedRanges {
        for seed := seedRange.Start; seed < seedRange.Start+seedRange.Length; seed++ {
            location := seed
            for _, mapType := range []string{"seed-to-soil", "soil-to-fertilizer", "fertilizer-to-water", "water-to-light", "light-to-temperature", "temperature-to-humidity", "humidity-to-location"} {
                location = applyMapping(location, mappings[mapType])
            }
            if location < lowestLocation {
                lowestLocation = location
            }
        }
    }

    return lowestLocation
}

func main() {
    file, err := os.Open("input.txt")
    if err != nil {
        fmt.Println("Error opening file:", err)
        return
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    mappings := make(map[string][]MappingEntry)
    var seedRanges []Range
    var currentMapType string

    for scanner.Scan() {
        line := scanner.Text()
        if strings.Contains(line, " map:") {
            currentMapType = strings.Split(line, " map:")[0]
            mappings[currentMapType] = []MappingEntry{}
        } else if strings.Contains(line, "seeds:") {
            parts := strings.Fields(strings.TrimPrefix(line, "seeds:"))
            for i := 0; i < len(parts); i += 2 {
                start, _ := strconv.Atoi(parts[i])
                length, _ := strconv.Atoi(parts[i+1])
                seedRanges = append(seedRanges, Range{Start: start, Length: length})
            }
        } else if currentMapType != "" {
            parts := strings.Fields(line)
            if len(parts) == 3 {
                destStart, _ := strconv.Atoi(parts[0])
                sourceStart, _ := strconv.Atoi(parts[1])
                length, _ := strconv.Atoi(parts[2])
                mappings[currentMapType] = append(mappings[currentMapType], MappingEntry{DestStart: destStart, SourceStart: sourceStart, Length: length})
            }
        }
    }

    result := processSeeds(seedRanges, mappings)
    fmt.Println("Lowest location number:", result)
}
