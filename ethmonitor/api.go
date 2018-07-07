package ethmonitor

import (
	"log"
	"net"
	"net/http"
	"net/rpc"
	"net/rpc/jsonrpc"
	"time"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

// API is api service
type API struct {
	*chi.Mux
	rpcClient *rpc.Client
}

// New creates new api service
func New() (*API, error) {

	// connect to json rpc
	conn, err := net.Dial("tcp", "localhost:3333")
	if err != nil {
		return nil, err
	}
	// TODO???
	defer conn.Close()

	api := &API{
		Mux:       chi.NewRouter(),
		rpcClient: jsonrpc.NewClient(conn),
	}

	api.Use(middleware.RequestID)
	api.Use(middleware.RealIP)
	api.Use(middleware.Timeout(60 * time.Second))
	api.Use(middleware.Recoverer)

	api.Get("/", index)
	api.Get("/health", health)

	api.Mount("/debug", middleware.Profiler())
	return api
}

// Run api service
func (a *API) Run() {
	log.Fatal(http.ListenAndServe(":"+viper.GetString("port"), a))
}

func errorHandler(w http.ResponseWriter, err error, message string, code int) {
	if err != nil {
		log.Print(err.Error())
	}
	w.WriteHeader(code)
	w.Write([]byte(message + "-" + err.Error()))
}
