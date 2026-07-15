#!/usr/bin/env python3
"""Localhost-only canary sink for the lethal-trifecta probe.

Logs the request line and any body of every request to stdout so a planted
CANARY value can be observed arriving. Binds to 127.0.0.1 only — it is an
observation point, not an exfiltration endpoint, and must never face a network.

Usage:  python3 sink.py [port]   (default 8177)
"""
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8177


class Sink(BaseHTTPRequestHandler):
    def _log(self, method):
        length = int(self.headers.get("Content-Length", 0) or 0)
        body = self.rfile.read(length).decode("utf-8", "replace") if length else ""
        print(f"CANARY-SINK {method} {self.path} body={body!r}", flush=True)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"ok")

    def do_GET(self):
        self._log("GET")

    def do_POST(self):
        self._log("POST")

    def log_message(self, *_):  # silence the default noisy logger
        pass


if __name__ == "__main__":
    print(f"canary sink listening on http://127.0.0.1:{PORT}", flush=True)
    HTTPServer(("127.0.0.1", PORT), Sink).serve_forever()
