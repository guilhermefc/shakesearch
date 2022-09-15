package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"index/suffixarray"
	"io/ioutil"
	"log"
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
	Items            []string
}

func handleSearch(searcher Searcher) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		enableCors(&w)
		query, ok := r.URL.Query()["q"]

		page := 1
		if len(r.URL.Query()["page"]) == 1 {
			var _ error
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

		var maxLength = 20 * page
		var minLenght = maxLength - 20
		totalItemsLength := len(results)
		totalPagesLength := len(results) / 20

		if len(results) > maxLength {
			results = results[minLenght:maxLength]
		}

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

func (s *Searcher) Search(query string) []string {
	idxs := s.SuffixArray.Lookup([]byte(strings.ToLower(query)), -1)
	results := []string{}
	for _, idx := range idxs {
		initialCut := idx - 250
		if initialCut < 0 {
			initialCut = 0
		}

		endCut := idx + 250
		if endCut > len(s.CompleteWorks) {
			endCut = len(s.CompleteWorks) - 1
		}

		results = append(results, s.CompleteWorks[initialCut:endCut])
	}
	return results
}
