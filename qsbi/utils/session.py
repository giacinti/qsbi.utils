from sqlalchemy.engine import Engine, create_engine
from sqlalchemy.orm import Session, sessionmaker


def create_session(dburl: str) -> Session:
    engine: Engine = create_engine(dburl, connect_args={"check_same_thread": False})
    return sessionmaker(autocommit=False,
                        autoflush=False,
                        bind=engine)()
