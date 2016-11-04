gabbi-tools
===============================

Helpers for working with the Gabbi API testing framework.

Documentation: https://github.hogarthww.com/pages/zonzaltd/gabbi-tools

.. contents:: Table of Contents

Installation
------------

Installation is simple:

.. code:: bash

    $ pip install gabbi-tools


Usage
-----

To pick out individual handlers:

.. code:: bash

    $ gabbi-run --response-handler gabbi_tools:XMLHandler -- *.yaml
    $ gabbi-run --response-handler gabbi_tools:BodyResponseHandler -- *.yaml

We provide a convenience command that applies all handlers in this package:

.. code:: bash

    $ gabbi-tools-run -- *.yaml


Tests
-----

.. code:: bash

    $ tox
