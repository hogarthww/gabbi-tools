"""XML-related content handling."""

import json
from collections import defaultdict
from xml.dom.minidom import parseString

from gabbi.handlers.jsonhandler import JSONHandler

import xmltodict


class XMLHandler(JSONHandler):
    """A ContentHandler for XML

    * Structured test ``data`` is turned into XML when request
      content-type is XML.
    * Response bodies that are XML strings are made into Python
      data on the test ``response_data`` attribute when the response
      content-type is XML.
    * A ``response_xml_paths`` response handler is added.
    * JSONPaths in $RESPONSE substitutions are supported.

    Note: the order of sibling tags is not retained.
    """

    test_key_suffix = 'xml_paths'
    test_key_value = {}

    @staticmethod
    def accepts(content_type):
        """Detect XML content from the content type header."""
        content_type = content_type.split(';', 1)[0].strip()
        return (content_type.endswith('+xml') or
                content_type.startswith('application/xml') or
                content_type.startswith('text/xml'))

    @staticmethod
    def dumps(data, pretty=False):
        """Convert Python data structure into bytes."""
        xml_string = xmltodict.unparse(data)
        if pretty:
            return parseString(xml_string).toprettyxml()
        else:
            return xml_string

    @staticmethod
    def loads(data):
        """Parse bytes into Python data structure."""

        def dict_constructor(*args, **kwargs):
            """Ensure single child tags replicate sibling tag behaviour."""
            return defaultdict(list, *args, **kwargs)

        # See github.com/martinblech/xmltodict/issues/14#issuecomment-13039037
        data_dict = xmltodict.parse(data, dict_constructor=dict_constructor)
        # round trip through json to replace defaultdict with dict
        return json.loads(json.dumps(data_dict))
