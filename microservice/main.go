package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/go-chi/chi"
)

type User struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Surname string `json:"surname"`
}

var users map[int]User

func main() {
	// Initialize the map of users
	users = make(map[int]User)

	// Create a go-chi router
	router := chi.NewRouter()

	// Mock CRUD operations to handle users
	router.Get("/users", ListUsers)
	router.Get("/users/{id}", GetUser)
	router.Post("/users", CreateUser)
	router.Put("/users/{id}", UpdateUser)
	router.Delete("/users/{id}", DeleteUser)

	// Retrieve the execution port parameterized by ENV
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Default port
	}

	// Start the HTTP server
	log.Printf("Server running on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, router))
}

// Mock CRUD operation to get the list of users
func ListUsers(w http.ResponseWriter, r *http.Request) {
	userList := []User{}
	for _, user := range users {
		userList = append(userList, user)
	}

	json.NewEncoder(w).Encode(userList)
}

// Mock CRUD operation to get a user by ID
func GetUser(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")

	id := parseID(userID)
	user, ok := users[id]
	if !ok {
		http.NotFound(w, r)
		return
	}

	json.NewEncoder(w).Encode(user)
}

// Mock CRUD operation to create a new user
func CreateUser(w http.ResponseWriter, r *http.Request) {
	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	users[user.ID] = user

	w.WriteHeader(http.StatusCreated)
}

// Mock CRUD operation to update a user
func UpdateUser(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")

	id := parseID(userID)
	if _, ok := users[id]; !ok {
		http.NotFound(w, r)
		return
	}

	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	users[id] = user

	w.WriteHeader(http.StatusNoContent)
}

// Mock CRUD operation to delete a user
func DeleteUser(w http.ResponseWriter, r *http.Request) {
	userID := chi.URLParam(r, "id")

	id := parseID(userID)
	if _, ok := users[id]; !ok {
		http.NotFound(w, r)
		return
	}

	delete(users, id)

	w.WriteHeader(http.StatusNoContent)
}

// Utility function to convert ID to integer
func parseID(id string) int {
	idNum, err := strconv.Atoi(id)
	if err != nil {
		return -1
	}
	return idNum
}
