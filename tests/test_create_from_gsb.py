from qsbi.utils.dbcmp.sqlite import compare_databases


def test_create_from_gsb(reference_db, test_db) -> None:
    assert compare_databases(reference_db, test_db)
