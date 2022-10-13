import datetime
import os
import sqlite3
from pathlib import Path

import pytest

from qsbi.utils.gsb2qdb import gsb2qdb
from qsbi.utils.session import create_session

TEST_DIR: str = os.path.dirname(os.path.abspath(__file__))


@pytest.fixture(scope='session')
def example_gsb() -> str:
    return f"file:{TEST_DIR}/Example_1.0.gsb"


@pytest.fixture(scope='session')
def example_dump() -> str:
    return f"{TEST_DIR}/example.sql"


@pytest.fixture(scope='session', autouse=True)
def mock_alog_date(session_mocker) -> None:
    session_mocker.patch('qsbi.utils.gsb2qdb.get_audit_log_date',
                         return_value=datetime.datetime.fromtimestamp(0))


@pytest.fixture(scope='session')
def reference_db(tmp_path_factory, example_dump) -> Path:
    ref_db: Path = tmp_path_factory.mktemp('data') / 'example.db'
    with sqlite3.connect(ref_db) as conn:
        with open(example_dump) as file:
            conn.cursor().executescript(file.read())
    return ref_db


@pytest.fixture(scope='session')
def test_db(tmp_path_factory, example_gsb) -> Path:
    test_db: Path = tmp_path_factory.mktemp('data') / 'test.db'
    with create_session(f"sqlite:///{test_db}") as db:
        gsb2qdb(db, example_gsb, True)
    return test_db
