"""Entry points for the `gabbi_tools` service."""

from gabbi.handlers import base


class BodyResponseHandler(base.ResponseHandler):
    """Compare entire response body to string or file.

    Accepts <@filename to compare response to a local file.

    response_body:
        - entire response body must match this string

    response_body:
        - <@image.jpg
    """

    test_key_suffix = 'body'
    test_key_value = []

    def action(self, test, expected, value=None):
        """Perform exact match test of response body to string or file."""
        expected = test.replace_template(expected)
        msg = None
        if expected.startswith('<@'):
            filename = expected[2:]
            expected = test._load_data_file(filename)
            msg = (
                "Local file {} ({} bytes) doesn't match response body "
                "({} bytes)").format(filename, len(expected), len(test.output))
        test.assertEqual(expected, test.output, msg)
