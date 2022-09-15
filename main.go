package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"index/suffixarray"
	"io/ioutil"
	"log"
	"math"
	"net/http"
	"os"
	"strconv"
	"strings"
)

func main() {
	searcher := Searcher{}
	err := searcher.Load("completeworks.txt")
	if err != nil {
		log.Fatal(err)
	}

	fs := http.FileServer(http.Dir("./shake_search_web/build/web"))
	http.Handle("/", fs)

	http.HandleFunc("/search", handleSearch(searcher))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3001"
	}

	fmt.Printf("Listening on port %s...", port)
	err = http.ListenAndServe(fmt.Sprintf(":%s", port), nil)
	if err != nil {
		log.Fatal(err)
	}
}
func enableCors(w *http.ResponseWriter) {
	(*w).Header().Set("Access-Control-Allow-Origin", "*")
}

type Searcher struct {
	CompleteWorks string
	SuffixArray   *suffixarray.Index
}

type Response struct {
	CurrentPage      int
	TotalPagesLength int
	TotalItemsLength int
	Items            []Work
}

type Work struct {
	Text  string
	Scene string
	Act   string
}

func handleSearch(searcher Searcher) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		enableCors(&w)
		query, ok := r.URL.Query()["q"]

		page := 0
		if len(r.URL.Query()["page"]) == 1 {
			page, _ = strconv.Atoi(r.URL.Query()["page"][0])
		}

		if !ok || len(query[0]) < 1 {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("missing search query in URL params"))
			return
		}
		results := searcher.Search(query[0])
		buf := &bytes.Buffer{}
		enc := json.NewEncoder(buf)

		const pageSize = 10
		var minLenght = page * pageSize
		var maxLength = minLenght + pageSize

		if minLenght > len(results) {
			minLenght = 0
		}
		if maxLength > len(results) {
			maxLength = len(results)
		}

		totalItemsLength := len(results)
		pageSizeDivision := float64(len(results)) / float64(pageSize)
		totalPagesLength := int(math.Ceil(float64(pageSizeDivision)))
		results = results[minLenght:maxLength]

		response := Response{
			CurrentPage:      page,
			TotalPagesLength: totalPagesLength,
			TotalItemsLength: totalItemsLength,
			Items:            results,
		}

		err := enc.Encode(response)

		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte("encoding failure"))
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(buf.Bytes())
	}
}

func (s *Searcher) Load(filename string) error {
	dat, err := ioutil.ReadFile(filename)
	if err != nil {
		return fmt.Errorf("Load: %w", err)
	}
	s.CompleteWorks = string(dat)
	s.SuffixArray = suffixarray.New(bytes.ToLower(dat))
	return nil
}

func (s *Searcher) Search(query string) []Work {
	idxs := s.SuffixArray.Lookup([]byte(strings.ToLower(query)), -1)

	results := []Work{}
	for _, idx := range idxs {
		initialCut := idx - 250
		if initialCut < 0 {
			initialCut = 0
		}

		endCut := idx + 250
		if endCut > len(s.CompleteWorks) {
			endCut = len(s.CompleteWorks) - 1
		}

		searchScene := s.CompleteWorks[0:idx]
		indexAct := strings.LastIndex(searchScene, "ACT")
		indexScene := strings.LastIndex(searchScene, "SCENE")

		actTitle := "Act not found"
		if indexAct != -1 {
			searchActEnd := s.CompleteWorks[indexAct : indexAct+200]
			indexEndActDot := strings.Index(searchActEnd, ".")
			indexEndActSlash := strings.Index(searchActEnd, "\n")

			indexEndAct := 0
			if indexEndActDot > indexEndActSlash {
				indexEndAct = indexEndActSlash
			} else {
				indexEndAct = indexEndActDot
			}

			if indexEndAct != -1 {
				actTitle = s.CompleteWorks[indexAct : indexAct+indexEndAct]
			}
		}

		sceneTitle := "Scene title not found"
		if indexScene != -1 {
			searchSceneEnd := s.CompleteWorks[indexScene : indexScene+200]
			indexEndSeachScene := strings.Index(searchSceneEnd, "\n")

			if indexEndSeachScene != -1 {
				sceneTitle = s.CompleteWorks[indexScene : indexScene+indexEndSeachScene]
			}
		}

		work := Work{
			Text:  s.CompleteWorks[initialCut:endCut],
			Scene: sceneTitle,
			Act:   actTitle,
		}

		results = append(results, work)
	}
	return results
}
