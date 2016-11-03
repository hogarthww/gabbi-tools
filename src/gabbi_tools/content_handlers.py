"""XML-related content handling."""

import json

from gabbi.handlers.jsonhandler import JSONHandler

import xmltodict
from xml.dom.minidom import parseString


class XMLHandler(JSONHandler):
    """A ContentHandler for XML

    * Structured test ``data`` is turned into XML when request
      content-type is XML.
    * Response bodies that are XML strings are made into Python
      data on the test ``response_data`` attribute when the response
      content-type is XML.
    * A ``response_xml_paths`` response handler is added.
    * JSONPaths in $RESPONSE substitutions are supported.
    """

    test_key_suffix = 'xml_paths'
    test_key_value = {}

    @staticmethod
    def accepts(content_type):
        content_type = content_type.split(';', 1)[0].strip()
        return (content_type.endswith('+xml') or
                content_type.startswith('application/xml'))

    @staticmethod
    def dumps(data, pretty=False):
        xml_string = xmltodict.unparse(data)
        if pretty:
            return parseString(xml_string).toprettyxml()
        else:
            return xml_string

    @staticmethod
    def loads(data):
        # round trip through json to replace OrderedDict with dict
        return json.loads(json.dumps(xmltodict.parse(data)))
