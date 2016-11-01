"""Module for the `gabbi_tools` service."""

from .handlers import BodyResponseHandler


def gabbi_response_handlers():
    """Define our list of handlers."""
    return [BodyResponseHandler]
