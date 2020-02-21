@echo off

if "%1"=="" goto ops

sqlite3.exe %1 < candidatos.sql
sqlite3.exe %1 < eleitores.sql
sqlite3.exe %1 < votacao.sql
sqlite3.exe %1 < votaram.sql

goto fim

:ops

echo digite criaBanco.bat nomeBanco.db3

:fim

echo arquivos importados...

