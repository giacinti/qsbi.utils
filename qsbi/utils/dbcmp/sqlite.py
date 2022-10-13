from typing import List, Optional
from sqlalchemy import text
from sqlalchemy.sql.expression import TextClause
from sqlalchemy.engine import Engine, create_engine


def compare_schemas(conn, db1="db1", db2="db2") -> Optional[List[str]]:
    """compare two databases schemas

    Args:
        conn (Connection): connection to the current database, db1 and db2 are attached
        db1 (str, optional): name of the first database (reference). Defaults to "db1".
        db2 (str, optional): name of the second database (to be tested). Defaults to "db2".

    Returns:
        Optional[List[str]]: list of tables names
    """
    result: Optional[List[str]] = None
    in_ref_only: TextClause = text(f"SELECT tbl_name from {db1}.sqlite_master WHERE type='table' EXCEPT "
                                   f"SELECT tbl_name from {db2}.sqlite_master WHERE type='table'")
    in_test_only: TextClause = text(f"SELECT tbl_name from {db2}.sqlite_master WHERE type='table' EXCEPT "
                                    f"SELECT tbl_name from {db1}.sqlite_master WHERE type='table'")
    diff_from_ref: List = conn.execute(in_ref_only).fetchall()
    diff_to_ref: List = conn.execute(in_test_only).fetchall()
    if not diff_from_ref and not diff_to_ref:  # same tables everywhere
        result = [t[0] for t in conn.execute(text(f"SELECT tbl_name from {db1}.sqlite_master WHERE type='table'"))]
        for table in result:
            same_sql: TextClause = text(f"SELECT sql from {db1}.sqlite_master WHERE tbl_name='{table}' EXCEPT "
                                        f"SELECT sql from {db2}.sqlite_master WHERE tbl_name='{table}'")
            sql_diff: List = conn.execute(same_sql).fetchall()
            if sql_diff:
                print(f"error, {table} schemas differ: {sql_diff}")
                result = None
                break
    else:
        print(f"error, tables differ. ref vs test: {diff_from_ref}, test vs ref: {diff_to_ref}")
    return result


def compare_data(table: str, conn, db1="db1", db2="db2") -> bool:
    """compare tables content

    Args:
        table (str): table name (same name in both databases)
        conn (_type_): connection to the main database (db1 and db2 are attached)
        db1 (str, optional): reference database name. Defaults to "db1".
        db2 (str, optional): test database name. Defaults to "db2".

    Returns:
        bool: True if matched, False otherwise
    """
    same_data_ref: TextClause = text(f"SELECT * from {db1}.{table} EXCEPT SELECT * from {db2}.{table}")
    data_diff_ref: List = conn.execute(same_data_ref).fetchall()
    same_data_test: TextClause = text(f"SELECT * from {db2}.{table} EXCEPT SELECT * from {db1}.{table}")
    data_diff_test: List = conn.execute(same_data_test).fetchall()
    if data_diff_ref or data_diff_test:
        print(f"error data for table {table} differ: in ref={data_diff_ref} in test={data_diff_test}")
    return not data_diff_ref and not data_diff_test


def attach_database(conn, db_path: str, db_name: str) -> None:
    sql: TextClause = text(f"ATTACH DATABASE '{db_path}' as {db_name}")
    conn.execute(sql)


def compare_databases(ref_db_path: str, test_db_path: str) -> bool:
    """compares two databases
    first it compares schemas
    then data
    first database is the reference

    Args:
        ref_db_path (str): path to reference database
        test_db_path (str): path to test database

    Returns:
        bool: matches or not
    """
    result: bool = False
    engine: Engine = create_engine("sqlite:///:memory:", connect_args={"check_same_thread": False})
    with engine.connect() as conn:
        attach_database(conn, ref_db_path, "db1")
        attach_database(conn, test_db_path, "db2")
        tables_list: Optional[List[str]] = compare_schemas(conn, "db1", "db2")
        if tables_list:
            result = True
            for table in tables_list:
                if not compare_data(table, conn, "db1", "db2"):
                    result = False
                    break
    return result
