import click
import logging
import xml.etree.ElementTree as ET
import urllib.parse
import urllib.request

from typing import Optional
from datetime import datetime
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

import qsbi.backend.sql.models as models

logging.basicConfig(level=logging.INFO)
logger: logging.Logger = logging.getLogger("gsb2qdb")


def add_if(db: Session,
           orm_class: models.Base,  # type: ignore
           attr,
           **kwargs
           ) -> Optional[models.Base]:  # type: ignore
    """ add object in db if not already in, filter with 'attr' """
    obj = db.query(orm_class).filter(getattr(orm_class, attr) == kwargs[attr]).first()  # type: ignore
    if not obj:
        obj = orm_class(**kwargs)
        db.add(obj)
        logger.info(
            f"Creating new {orm_class.__tablename__} {attr}={getattr(obj,attr)} ({kwargs})"
        )
    else:
        logger.warning(
            f"Skipping creating {orm_class.__tablename__} {attr}={getattr(obj,attr)} ({kwargs}), already exists."
        )
    return obj


def init_db(db: Session, drop: bool) -> None:
    """ create default objects in database """
    if drop:
        logger.warning("Dropping all tables")
        models.Base.metadata.drop_all(bind=db.get_bind())  # type: ignore
    models.Base.metadata.create_all(bind=db.get_bind())  # type: ignore

    # create default Account types
    add_if(db, models.AccountType, 'id', id=0, name="Compte bancaire")
    add_if(db, models.AccountType, 'id', id=1, name="Compte de caisse")
    add_if(db, models.AccountType, 'id', id=2, name="Compte de passif")
    add_if(db, models.AccountType, 'id', id=3, name="Compte d'actif")

    # create default Payment types
    add_if(db, models.PaymentType, 'id', id=0, name="Neutral")
    add_if(db, models.PaymentType, 'id', id=1, name="Debit")
    add_if(db, models.PaymentType, 'id', id=2, name="Credit")

    # create default Category types
    add_if(db, models.CategoryType, 'id', id=0, name="Credit")
    add_if(db, models.CategoryType, 'id', id=1, name="Debit")


def init_audit_log(db: Session) -> models.AuditLog:
    """ audit log for this update """
    user: Optional[models.User] = add_if(db, models.User, 'login',
                                         login="gsb2qdb",
                                         firstname="tool",
                                         lastname="gsb2qdb",
                                         notes="gsb2qdb tool")
    alog: models.AuditLog = models.AuditLog(user=user,
                                            date=datetime.utcnow(),
                                            notes="automatic import by gsb2qdb tool")
    db.add(alog)
    logger.info(
        f"Creating new {models.AuditLog.__tablename__} user={alog.user.login} date={alog.date} notes={alog.notes}"
    )
    return alog


def get_attr(node, attr) -> Optional[str]:
    """ get xml attribute, converting "(null)" into None """
    attr = node.attrib[attr]
    if attr == "(null)":
        attr = None
    return attr


def convert_date(dstr) -> Optional[datetime]:
    """ convert date in format %m/%d/%Y into real datetime """
    if dstr is not None:
        return datetime.strptime(dstr, "%m/%d/%Y")
    else:
        return None


def parse_gsb(file, db, alog) -> None:
    """ parse gsb file, create orm objects """
    tree: ET.ElementTree = ET.parse(file)
    root: ET.Element = tree.getroot()
    for child in root:
        if child.tag == "Currency":
            add_if(db, models.Currency, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   nickname=get_attr(child, 'Ico'),
                   code=get_attr(child, 'Co'))

        elif child.tag == "Currency_link":
            add_if(db, models.CurrencyLink, 'id',
                   id=get_attr(child, 'Nb'),
                   cur1_id=get_attr(child, 'Cu1'),
                   cur2_id=get_attr(child, 'Cu2'),
                   rate=get_attr(child, 'Ex'),
                   date=convert_date(get_attr(child, 'Modified_date')),
                   log=alog)

        elif child.tag == "Bank":
            add_if(db, models.Bank, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   code=get_attr(child, 'Co'),
                   bic=get_attr(child, 'BIC'),
                   address=get_attr(child, 'Adr'),
                   tel=get_attr(child, 'Tel'),
                   mail=get_attr(child, 'Mail'),
                   web=get_attr(child, 'Web'),
                   contact_name=get_attr(child, 'Nac'),
                   contact_fax=get_attr(child, 'Faxc'),
                   contact_tel=get_attr(child, 'Telc'),
                   contact_mail=get_attr(child, 'Mailc'),
                   notes=get_attr(child, 'Rem'))

        elif child.tag == "Account":
            o_date: datetime = datetime.fromtimestamp(0)
            c_date: Optional[datetime] = None
            if get_attr(child, 'Closed_account') == "1":
                c_date = datetime.utcnow()
            add_if(db, models.Account, 'id',
                   id=get_attr(child, 'Number'),
                   name=get_attr(child, 'Name'),
                   bank_id=get_attr(child, 'Bank'),
                   bank_branch=get_attr(child, 'Bank_branch_code'),
                   bank_account=get_attr(child, 'Bank_account_number'),
                   bank_account_key=get_attr(child, 'Key'),
                   bank_IBAN=get_attr(child, 'Bank_account_IBAN'),
                   currency_id=get_attr(child, 'Currency'),
                   open_date=o_date,
                   close_date=c_date,
                   type_id=get_attr(child, 'Kind'),
                   initial_balance=get_attr(child, 'Initial_balance'),
                   mini_balance_wanted=get_attr(child, 'Minimum_wanted_balance'),
                   mini_balance_auth=get_attr(child, 'Minimum_authorised_balance'),
                   holder_name=get_attr(child, 'Owner'),
                   holder_address=get_attr(child, 'Owner_address'))

        elif child.tag == "Payment":
            cur: Optional[str] = None
            if get_attr(child, 'Automatic_number') == "1":
                cur = get_attr(child, 'Current_number')
            add_if(db, models.Payment, 'id',
                   id=get_attr(child, 'Number'),
                   name=get_attr(child, 'Name'),
                   type_id=get_attr(child, 'Sign'),
                   current=cur,
                   account_id=get_attr(child, 'Account'))

        elif child.tag == "Transaction":
            add_if(db, models.Transact, 'id',
                   id=get_attr(child, 'Nb'),
                   account_id=get_attr(child, 'Ac'),
                   transaction_date=convert_date(get_attr(child, 'Dt')),
                   value_date=convert_date(get_attr(child, 'Dv')),
                   party_id=get_attr(child, 'Pa'),
                   category_id=get_attr(child, 'Ca'),
                   sub_category_id=get_attr(child, 'Sca'),
                   notes=get_attr(child, 'No'),
                   amount=get_attr(child, 'Am'),
                   currency_id=get_attr(child, 'Cu'),
                   exchange_rate=get_attr(child, 'Exr'),
                   exchange_fees=get_attr(child, 'Exf'),
                   payment_id=get_attr(child, 'Pn'),
                   master_id=get_attr(child, 'Mo'),
                   reconcile_id=get_attr(child, 'Re'),
                   log=alog)

        elif child.tag == "Scheduled":
            add_if(db, models.Scheduled, 'id',
                   id=get_attr(child, 'Nb'),
                   account_id=get_attr(child, 'Ac'),
                   start_date=convert_date(get_attr(child, 'Dt')),
                   limit_date=convert_date(get_attr(child, 'Dtl')),
                   frequency=get_attr(child, 'Pe'),
                   automatic=get_attr(child, 'Au'),
                   party_id=get_attr(child, 'Pa'),
                   category_id=get_attr(child, 'Ca'),
                   sub_category_id=get_attr(child, 'Sca'),
                   notes=get_attr(child, 'No'),
                   amount=get_attr(child, 'Am'),
                   currency_id=get_attr(child, 'Cu'),
                   payment_id=get_attr(child, 'Pn'),
                   master_id=get_attr(child, 'Mo'),
                   log=alog)

        elif child.tag == "Party":
            add_if(db, models.Party, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   desc=get_attr(child, 'Txt'))

        elif child.tag == "Category":
            add_if(db, models.Category, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   type_id=get_attr(child, 'Kd'))

        elif child.tag == "Sub_category":
            add_if(db, models.SubCategory, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   category_id=get_attr(child, 'Nbc'))

        elif child.tag == "Reconcile":
            add_if(db, models.Reconcile, 'id',
                   id=get_attr(child, 'Nb'),
                   name=get_attr(child, 'Na'),
                   account_id=get_attr(child, 'Acc'),
                   start_date=convert_date(get_attr(child, 'Idate')),
                   end_date=convert_date(get_attr(child, 'Fdate')),
                   start_balance=get_attr(child, 'Ibal'),
                   end_balance=get_attr(child, 'Fbal'),
                   log=alog)


def create_session(dburl: str) -> Session:
    engine = create_engine(dburl, connect_args={"check_same_thread": False})

    session: Session = sessionmaker(autocommit=False, autoflush=False, bind=engine)()
    return session


def gsb2qdb(gsb_file, db_url, drop) -> None:
    logger.info(f"opening {gsb_file}")
    url: urllib.parse.ParseResult = urllib.parse.urlparse(gsb_file)
    if not url.scheme:
        url = url._replace(scheme='file')
    file = urllib.request.urlopen(url.geturl())

    db: Session = create_session(db_url)
    init_db(db, drop)
    alog: models.AuditLog = init_audit_log(db)
    parse_gsb(file, db, alog)
    db.commit()
    db.close()


@click.command()
@click.argument('gsb_file')
@click.argument('db_url')
@click.option(
    '--drop', '-d', is_flag=True,
    help='drop existing model tables'
)
def main(gsb_file, db_url, drop) -> None:
    """convert gsb file to qsbi database

    \b
    Args:
        gsb_file (url): the source gsb file
        db_url (sqlalchemy db url): destination database

    \b
    Example:
        gsb2qdb /tmp/input.gsb sqlite:////tmp/output.db
        gsb2qdb file:///tmp/input.gsb sqlite:////tmp/output.qdb
        gsb2qdb https://raw.githubusercontent.com/grisbi/grisbi-examples/master/Example_1.0.gsb sqlite:////tmp/example.qdb
    """  # noqa: E501
    gsb2qdb(gsb_file, db_url, drop)


##############################################################################
#
if __name__ == "__main__":
    main()
