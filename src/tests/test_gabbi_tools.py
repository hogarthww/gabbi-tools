# -*- coding: utf-8 -*-
"""Tests for gabbi_tools."""
import pytest

import gabbi_tools


@pytest.fixture
def my_fixture():
    """Sample fixture."""
    return 1


def test_hard_work(my_fixture):
    """Sample test."""
    assert my_fixture != 2
    assert gabbi_tools
