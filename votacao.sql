drop table votacao;
CREATE TABLE votacao (
    id     INTEGER  PRIMARY KEY
                    UNIQUE
                    NOT NULL,
    numero CHAR (2) NOT NULL
);
