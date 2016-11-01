============
Contributing
============

The source code is located here:

    https://github.hogarthww.com/zonzaltd/gabbi-tools

If you have minor code quality changes, please just submit a PR! If you have
new features or bug fixes, please follow the instructions below.

Bugs
----

Please report bugs on our bug tracker: https://hogarthww.atlassian.net/

Please include:

* OS name and version.
* Details about your test setup/settings.
* Steps to reproduce the issue.

Documentation
-------------

`gabbi-tools` documentation is built via docstrings. You can build the
documentation with:

.. code-block:: bash

    make env
    make docs

It should build the docs and open them in your default browser.

Get Started!
------------

Getting started is pretty standard:

.. code-block:: bash

    # CLONE THE CODE REPOSITORY
    git clone https://github.hogarthww.com/zonzaltd/gabbi-tools
    cd gabbi-tools

    # CREATE A VIRTUALENV AND INSTALL DEV DEPENDENCIES
    make env

    # CREATE A BRANCH FOR YOUR NEW FEATURE
    git checkout -b feature/my-cool-feature
    # ... now you can make your changes locally.

    # RUN TESTS AND LINTING TO MAKE SURE THEY PASS
    make test-all

    # COMMIT YOUR CHANGES AND PUSH YOUR BRANCH TO GITHUB
    git add .
    git commit -m "Your detailed description of your changes."
    git push origin feature/my-cool-feature

    # SUBMIT A PULL REQUEST THROUGH THE GITHUB WEBSITE

Pull Request Guidelines
-----------------------

Your pull requests must contain adequate tests and documentation.

Also, please use the PR template located here: https://github.hogarthww.com/mikejarrett/pull-request-template

Tips
----

TDD
~~~

Doing TDD is pretty easy in this repository. At the moment the "fast" tests run
in under 1 second:

.. code-block:: bash

    make test-fast
    make test-fast TEST_PATH=./src/tests/test_api.py

You can use ``rerun`` to run the tests for every change:

.. code-block:: bash

    pip install rerun
    rerun "make test-fast"

Debian Package
~~~~~~~~~~~~~~

If you are working on the Debian package, you can test it out with an empty
ubuntu:14.04 docker container. Simply run:

.. code-block:: bash

    make dpkg
    make testbed
    ...
    dpkg -i /testbed/dist/<mypackage>.deb

Coding Standards
----------------

This is a distilled version of the coding standards originally drafted by Vlad
Mettler in https://wiki.hogarthww.prv/display/SSAS/Coding.

Things that will be enforced by this repos automation (Makefile etc.):

- Abide by PEP8 and PEP257
- Unit tests and test coverage
- Docstrings

Things that will NOT be enforced by this repos automation and need to be
enforced by humans (e.g. via code reviews):

- General principles:
  - `DRY <https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)>`_
  - `SOLID <https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)>`_
  - `TDD <https://en.wikipedia.org/wiki/Test-driven_development>`_
