#!/usr/bin/python3
import http.server
import socketserver
import logging
import sys
import signal
from http import HTTPStatus


port = 8080
message = b'Hello World!\n'
logging.basicConfig(
  stream = sys.stdout, 
  level = logging.INFO
)


def signal_handler(signum, frame):
  sys.exit(0)


class Handler(http.server.SimpleHTTPRequestHandler):
  def do_GET(self):
    self.send_response(HTTPStatus.OK)
    self.end_headers()
    self.wfile.write(message)
 
if __name__ == "__main__":
  signal.signal(signal.SIGTERM, signal_handler)
  signal.signal(signal.SIGINT, signal_handler)
  try:
    httpd = socketserver.TCPServer(('', port), Handler)
    logging.info("Serving on port %s", port)
    httpd.serve_forever()
  except SystemExit:
    httpd.shutdown()
    httpd.server_close()

