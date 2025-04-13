package main

import (
	"encoding/json"
	"log"
	"net/http"
)

// HealthCheckResponse defines the structure of the health check response
type HealthCheckResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
}

func healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	response := HealthCheckResponse{
		Status:  "healthy",
		Message: "The application is running smoothly.",
	}

	// Set response header content type
	w.Header().Set("Content-Type", "application/json")

	// Return a successful status code
	w.WriteHeader(http.StatusOK)

	// Encode the response to JSON format
	json.NewEncoder(w).Encode(response)
}

func main() {
	// Set up routing
	http.HandleFunc("/health", healthCheckHandler)

	log.Println("Starting server on :8080")
	// Start the HTTP server
	port := ":8080"
	http.ListenAndServe(port, nil)
}
