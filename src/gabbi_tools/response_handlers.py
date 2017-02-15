"""Entry points for the `gabbi_tools` service."""

from gabbi.handlers import base


class BodyResponseHandler(base.ResponseHandler):
    """Compare entire response body to string or file.

    Accepts <@filename to compare response to a local file.

    .. code::

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
            filename = expected
            # decode the input file, only if the test content was decoded
            # i.e. if the content-type was considered non binary
            expected = test._test_data_to_string(filename, test.content_type)
            msg = (
                "Local file {} ({} bytes) doesn't match response body "
                "({} bytes)").format(filename, len(expected), len(test.output))
        test.assertEqual(expected, test.output, msg)
