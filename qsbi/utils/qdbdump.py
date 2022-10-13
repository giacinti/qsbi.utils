from typing import List
from qsbi.utils.gsb2qdb import gsb2qdb


def qdb_dump(db, gsb_file) -> List[str]:
    gsb2qdb(db, gsb_file, True)
    conn = db.get_bind().raw_connection()
    dump = [line for line in conn.iterdump()]
    return dump
