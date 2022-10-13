import filecmp
from pathlib import Path

from qsbi.utils.qdbdump import qdb_dump
from qsbi.utils.session import create_session


def test_dump(tmp_path, example_gsb, example_dump) -> None:
    test_dump: Path = tmp_path / 'test.sql'
    with create_session("sqlite:///:memory:") as db:
        dump = qdb_dump(db, example_gsb)
        with open(test_dump, "w") as file:
            for line in dump:
                print(line, file=file)
    assert filecmp.cmp(example_dump, test_dump, False)
