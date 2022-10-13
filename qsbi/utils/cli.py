import click

from qsbi.utils.dbcmp.sqlite import compare_databases
from qsbi.utils.gsb2qdb import gsb2qdb
from qsbi.utils.qdbdump import qdb_dump
from qsbi.utils.session import create_session


@click.group()
def cli() -> None:
    pass


@click.command()
@click.argument('gsb_file')
@click.argument('db_url')
@click.option(
    '--drop', '-d', is_flag=True,
    help='drop existing model tables'
)
def create_db(gsb_file, db_url, drop) -> None:
    """convert gsb file to qsbi database

    \b
    Args:
        GSB_FILE (url): the source gsb file
        DB_URL (sqlalchemy db url): destination database

    \b
    Example:
        gsb2qdb /tmp/input.gsb sqlite:////tmp/output.db
        gsb2qdb file:///tmp/input.gsb sqlite:////tmp/output.qdb
        gsb2qdb https://raw.githubusercontent.com/grisbi/grisbi-examples/master/Example_1.0.gsb sqlite:////tmp/example.qdb
    """  # noqa: E501
    with create_session(db_url) as db:
        gsb2qdb(db, gsb_file, drop)


@click.command()
@click.argument('gsb_file')
def dump_db(gsb_file) -> None:
    """dump converted gsb file into sql db to stdout

    \b
    Args:
        GSB_FILE (url): the source gsb file
    """
    with create_session("sqlite:///:memory:") as db:
        for line in qdb_dump(db, gsb_file):
            print(line)


@click.command()
@click.argument('ref')
@click.argument('test')
def compare_db(ref: str, test: str) -> bool:
    """compare two (sqlite) databases

    \b
    Args:
        REF (str): reference database (for schema)
        TEST (str): test database

    Returns:
        bool: True if matches, False otherwise
    """
    return compare_databases(ref, test)


cli.add_command(create_db)
cli.add_command(dump_db)
cli.add_command(compare_db)
if __name__ == "__main__":
    cli()
