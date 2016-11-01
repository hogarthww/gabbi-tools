#!/bin/bash

cd src/tests/
gabbi-run --response-handler gabbi_tools.handlers:BodyResponseHandler -- example.yaml
