"""Module for the `gabbi_tools` service."""

from .response_handlers import BodyResponseHandler
from .content_handlers import XMLHandler


def gabbi_response_handlers():
    """Define our list of handlers.

    This enables `gabbi-run --response-handler gabbi_tools`.
    """
    return [BodyResponseHandler, XMLHandler]
