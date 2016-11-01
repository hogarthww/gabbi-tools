gabbi-tools
===============================

Helpers for working with the Gabbi API testing framework.

Documentation: https://github.hogarthww.com/pages/zonzaltd/gabbi-tools

.. contents:: Table of Contents

Installation and Usage
----------------------

Installation is simple:

.. code:: bash

    $ # Install via pip
    $ pip install gabbi-tools
    $ # Install via apt-get
    $ apt-get install gabbi-tools

Usage is simple too:

.. code:: bash

    $ gabbi-tools cli-option

For advanced usage and configuration tips, see the manpages:

.. code:: bash

    $ man gabbi-tools


Build a Debian package
----------------------

You can build a Debian package of this service if you have Docker installed:

.. code:: bash

    $ make dpkg

Run in a Docker container
-------------------------

You can easily run this service in a Docker container

.. code:: bash

    $ # This will build and run your container
    $ make run-in-docker
    $
    $ # This will run the last container you built
    $ make run-in-docker-fast
    $ make run-in-docker-fast PORT=1234

TODO
----

.. todos-cd988ecc-225e-4bd6-befa-97b1590152dd

::

    -------------------------------------------------------------------
    GENERATED ON:
    -------------------------------------------------------------------
    NUMBER OF FIXMES: 0
    -------------------------------------------------------------------
    NUMBER OF TODOS: 0
    -------------------------------------------------------------------
