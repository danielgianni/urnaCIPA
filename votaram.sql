drop table votaram;
CREATE TABLE votaram (
    id     INTEGER  PRIMARY KEY
                    UNIQUE
                    NOT NULL,
    matricula TEXT NOT NULL 
	                   UNIQUE
);