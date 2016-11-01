# -*- coding: utf-8 -*-
"""This module contains `sphinx` configuration."""
import os
import sys

import sphinx_rtd_theme

sys.path.append(os.path.join(os.path.dirname(__file__), '../..'))


def _get_package_metadata():
    # get the raw PKG-INFO data
    from pkg_resources import get_distribution
    pkgInfo = get_distribution('gabbi_tools').get_metadata('PKG-INFO')

    # parse it using email.Parser
    from email import message_from_string
    msg = message_from_string(pkgInfo)
    return msg

pkg_metadata = _get_package_metadata()

extensions = ['sphinx.ext.autodoc', 'sphinx.ext.viewcode']
source_suffix = '.rst'
master_doc = 'index'

# General information about the project.
project = pkg_metadata.get('Name')
copyright = "2015+, {author}".format(author=pkg_metadata.get('Author'))

version = pkg_metadata.get('Version')
release = version

exclude_patterns = ['_build', '.env']
pygments_style = 'sphinx'  # Syntax highlighting style

html_theme = 'sphinx_rtd_theme'
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
