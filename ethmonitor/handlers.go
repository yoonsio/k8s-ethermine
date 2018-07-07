package ethmonitor

import "net/http"

func index(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("nothing to see here"))
}

func health(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("alive!"))
}

func (a *API) call(w http.ResponseWriter, r *http.Request) {
	a.rpcClient.Call("")
}

// {"id":0,"jsonrpc":"2.0","method":"miner_getstat1"}

// {"id":0,"jsonrpc":"2.0","method":"miner_restart"}

// '{"id":0,"jsonrpc":"2.0","method":"miner_ping"}'
