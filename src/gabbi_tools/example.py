"""Entry points for the `gabbi_tools` service."""


def application(environ, start_response):
    """Serve the web application.

    Meets the PEP-3333 WSGI standard
    """
    response_body = 'gabbi-tools is ready for development!'
    status = '200 OK'
    response_headers = [
        ('Content-Type', 'text/plain'),
        ('Content-Length', str(len(response_body)))
    ]
    start_response(status, response_headers)
    return [response_body.encode('utf-8')]


def cli():
    """Development server."""
    from wsgiref.simple_server import make_server

    def get_args():
        import argparse
        import sys
        parser = argparse.ArgumentParser(description='Run the dev server')
        parser.add_argument('-H', '--host', default='localhost')
        parser.add_argument('-p', '--port', type=int, default='8080')
        return parser.parse_args(sys.argv[1:])

    args = get_args()

    httpd = make_server(args.host, args.port, application)
    httpd.serve_forever()
