package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

type HealthMessage struct {
	OK            bool   `json:"ok"`
	ContainerType string `json:"container_type"`
}

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	containerType := os.Getenv("CONTAINER_TYPE")
	w.Header().Set("Content-Type", "application/json") // Set the content type to JSON

	if containerType == "" {
		w.WriteHeader(http.StatusInternalServerError)
		message := HealthMessage{
			OK:            false,
			ContainerType: "not set",
		}
		messageBytes, err := json.Marshal(&message)
		if err != nil {
			log.Fatal("Could not marshal healthMessage")
		}
		w.Write(messageBytes) // Return the error message

		return
	}
	w.WriteHeader(http.StatusOK)
	message := HealthMessage{
		OK:            true, // Set to true when everything is okay
		ContainerType: containerType,
	}
	messageBytes, err := json.Marshal(&message)
	if err != nil {
		log.Fatal("Could not marshal healthMessage")
	}
	w.Write(messageBytes) // Return the success message

	return
}

func main() {
	http.HandleFunc("/health", healthCheckHandler) // Set up the health check route

	fmt.Println("Starting server on :8080")
	err := http.ListenAndServe(":8080", nil) // Start the HTTP server on port 8080
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}
