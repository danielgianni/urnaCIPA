![](cipa.png)

# Funcionalidades do urnaCIPA

- Isolamento: não depende de internet e rede para funcionar.
- Portabilidade: pode ser executado diretamente em um pendrive.
- Flexibilidade: não precisa de instalação, funciona diretamente clicando no executável.
- Simplicidade: utiliza apenas 3 telas.
- Compatível com Windows a partir do Windows 7 32 bits.
- Utiliza softwares 100% gratuitos;
- Possui licença MIT (gratuita e sem restrições modificação ou comercialização).;
- Permite importar base de dados de ELEITORES e CANDIDATOS através de arquivos CSV (separados por vírgulas).
- Relatório de totalização de votos automaticamente para impressão após encerramento da eleição.
- Arquivo texto de configuração simplificado: Ano da Eleição, Nome da Empresa, Senha de Início de votação e Senha de Término da Votação.
- Banco de Dados SQLite sem necessidade de instalação de gerenciadores de banco de dados ou configurações complexas.

### Requisitos

- Windows 7 32 bits ou superior (não foi testado no Windows XP).
- 32mb de memória ram.
- 4mb de espaço em disco.
- Processador compatível com Windows 7 32 bits.

### Explicação do conceito

**Problema a ser solucionado**

Desenvolver um sistema que permita eleitores votar em candidatos na Eleição da CIPA de uma empresa qualquer e que forneça de forma automática ao término da votação ge emitir um relatório totalizador da contagem de votos de forma decrescente.

**Abordagem escolhida**

- Utilizar um banco de dados que dispense configurações complexas mas que permita utilizar comandos SQL.
- Permitir a importação de relação de candidatos e eleitores em formato de arquivo texto (CSV - separado por vírgulas) para o banco de dados, evitando manipulação dessas informações durante a votação.
- Gerar automaticamente um relatório totalizador com a contagem de votos de cada candidato em ordem decrescente após finalização da eleição.
- Pesquisar dados dos eleitores pelo CPF.
- Pesquisar dados dos candidatos pelo número de 2 digitos de cada candidato.
- Utilizar no máximo de 3 telas:
  - Uma tela para digitação de um código de início e término das votações.
  - Uma tela com estatística da votação em tempo real e com pesquisa dos dados do eleitor por CPF com botão para autorizar o eleitor votar.
  - Uma tela onde o eleitor digita o número de dois dígitos do candidato, visualiza os dados do candidato e confirma o voto clicando em um botão.
- Permitir fácil configuração e utilização.

**Pontos a serem alcançados**

- Eliminar uso de sons e imagens para otimizar o desempenho do sistema consumindo assim o mínimo de recursos de hardware possível.
- Manter as instruções na tela o mais simples possível considerando legibilidade e clareza das informações.

**Pontos a serem respeitados**

- Um eleitor possui um CPF único com 11 dígitos numéricos.
- Um candidato possui um Número Único com 2 dígitos numéricos.
- Senha de início e término da votação deve ser numérica com 4 digitos.
- Um eleitor pode votar um única vez e deverá ser excluído do banco de dados.
  - Na versão inicial 1.0 optou-se por registrar em uma tabela no banco de dados o número de matrícula de cada eleitor que votou para fins de auditoria interna no banco de dados se necessário, antes da exclusão do eleitor da tabela de eleitores após o mesmo já ter votado em um candidato. *Não foi implementada interface de consulta dessa tabela.*
- Um cadidato pode não ser votado ou votado por um ou mais eleitores.
- Haverá uma tabela no banco de dados para registrar cada voto individualmente.
- Não poderá ser liberada votação para um CPF que não tenha sido importado para o banco de dados ou que já tenha votado.
- Não poderá ser considerado voto para o número de um candidato que não tiver sido importado para o banco de dados.

## Tecnologias utilizadas

- Linguagem de Script Windows Autoit [Site da Linguagem](https://www.autoitscript.com/site/ "Site da Linguagem")
- Banco de Dados SQLite 3 [Site do Banco de Dados](https://www.sqlite.org/index.html )
- Arquivo de configuração padrão Windows (INI) [Definição](https://pt.wikipedia.org/wiki/INI_(formato_de_arquivo)
- Arquivos CSV (separados por vírgula) [Definição](https://pt.wikipedia.org/wiki/Comma-separated_values)
- Editor Visual de Telas GUI para Autoit KODA [Site da IDE](http://koda.darkhost.ru/page.php?id=index)


Estrutura dos Dados dos Arquivos Texto
-------------

#### Arquivo Texto de Eleitores

> **eleitores.csv**

    Nome,Codigo,CPF,Cargo,Departamento
    ACACIA ALVES,666666,123.051.218/01,Auxiliar Técnico,Empresa de Teste Matriz
    ACALANDRA CORREIA,777777,939.211.748/12,Caixa,Empresa de Teste Matriz
    ADRIANA ALVES,888888,111.198.108/22,Gerente,Empresa de Teste Filial
    
*Formato UTF-8 sem BOM*

#### Arquivo Texto de Candidatos

> **candidatos.csv**

    Numero,Matricula,Nome,Funcao,Unidade
    01,111111,José Pedro,Porteiro,Empresa de Teste Matriz
    02,222222,Gisele Souza,Auxiliar Administrativo,Empresa de Teste Filial
    03,333333,Patrícia Maria,Gerente,Empresa de Teste Matriz
    
*Formato UTF-8 sem BOM*

#### Arquivo Texto de Configuração

> **configuracao.ini**

    [Urna]
    Banco de Dados da Urna        = cipa2020.db3
    Senha para Iniciar Eleicao    = 9898
    Senha para Terminar Eleicao   = 2121
    Nome da Empresa               = Empresa de Teste
    Ano da CIPA                   = 2020
    
*Formato ANSI*

#### Arquivos internos de apoio

> **eleitores.sql**

    drop table eleitores;
    .separator ","
    .import eleitores.csv eleitores
    
*Formato UTF-8 sem BOM*

> **candidatos.sql**

    drop table candidatos;
    .separator ","
    .import candidatos.csv candidatos
    
*Formato UTF-8 sem BOM*

> **votacao.sql**

    drop table votacao;
    CREATE TABLE votacao (
        id     INTEGER  PRIMARY KEY
                        UNIQUE
                        NOT NULL,
        numero CHAR (2) NOT NULL
    );
    
*Formato UTF-8 sem BOM*

> **votaram.sql**

    drop table votaram;
    CREATE TABLE votaram (
        id     INTEGER  PRIMARY KEY
                        UNIQUE
                        NOT NULL,
        matricula TEXT NOT NULL
                        UNIQUE
    );
    
*Formato UTF-8 sem BOM*


> **criaBanco.bat**


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


*Formato UTF-8 sem BOM*

**Para criar o banco de dados na pasta urnaCIPA abra um prompt de comando do MS-DOS ou um prompt do powershell e digite** *criaBanco.bat cipa2020.db3*


> **tela1.kxf tela2.kxf tela3.kxf**

Esses arquivos são os arquivos utilizados pelo KODA para carregar cada tela para edição visual da interface gráfica.


Estrutura do Banco de Dados
-------------

> **cipa2020.db3**

tabela **`candidatos`**

Coluna | Tipo|Explicação <sup>Não faz parte do banco de dados</sup>
--------|-------|------
Numero|TEXT|número do candidato que o eleitor irá digitar para votar com 2 dígitos
Matricula|TEXT|número de matrícula do candidato no departamento pessoal
Nome|TEXT|nome completo do candidato
Funcao|TEXT|Cargo ou função do candidato na empresa
Unidade|TEXT|Setor ou unidade da empresa

tabela **`eleitores`**

Coluna | Tipo|Explicação <sup>Não faz parte do banco de dados</sup>
--------|-------|------
Nome|TEXT|nome completo do eleitor
Codigo|TEXT|número de matrícula do eleitor no departamento pessoal
CPF|TEXT|CPF do eleitor pode ser no formato 999.999.999/99
Cargo|TEXT|Cargo ou função do eleitor na empresa
Departamento|TEXT|Departamento ou unidade do eleitor

tabela **`eleitores`**

Coluna | Tipo|Explicação <sup>Não faz parte do banco de dados</sup>
--------|-------|------
id|INTEGER|autoincremento da tabela
 |PRIMARY KEY|chave primária
 |UNIQUE|único
 |NOT NULL|não nulo
numero|CHAR(2)|número do candidato votado com 2 dígitos
 |NOT NULL|não nulo

tabela **`votaram`**

Coluna | Tipo|Explicação <sup>Não faz parte do banco de dados</sup>
--------|-------|------
id|INTEGER| autoincremento
|PRIMARY KEY|chave primária
|UNIQUE|único
|NOT NULL|não nulo
matricula|TEXT|número de matrícula no departamento pessoal do eleitor que já votos
|NOT NULL|não nulo
|UNIQUE|único

### Nota de esclarecimento sobre problema na modelagem do banco de dados

> A modelagem do banco de dados utilizando esse formato, facilitou a programação da lógica da votação e contagem de votos, porém gera um problema de segurança da anonimização do votos uma vez que é possível com cruzamento de dados internos no banco de dados se exportados, verificar qual o eleitor votou em cada candidato.

> Uma solução para essa questão é a mudança da lógica da inserção do votos, ao invés de ter o voto depositado individualmente na tabela *votacao*, deveria haver na tabela *candidatos*, um campo _votos_, onde a cada voto seria feita a pesquisa SQL pelo número do candidato, lido o valor do campo _votos_, somado 1 voto e atualizado o campo da tabela *candidatos*. Com isso não seria necessário ter a tabela *votacao* e ainda poderia ser mantida para critério de log e auditoria a tabela *votaram*.

## Fluxo de Votação

```mermaid
graph TD
    A[Executa urnaCIPA] --> B[Digitou código válido de início ou término de votação?]
    B --> |sim| C[Código de terminar votação?]
    B --> |não| B
    B --> |sim| D[Código de iniciar votação?]

    C -->|sim| F[Excluir eleitores do banco de dados]
    C -->|não| B
 
    D -->|sim| E[Tela pesquisa de eleitor]
    D -->|não| B
 
    E --> J[Mostrar contagens de votos, eleitores e candidatos]

    F --> G[Fazer contagem de dados]
    G --> H[Abrir navegador e exibir Relatório]
    H --> I[Fechar urnaCIPA]

    J --> L[Consultar CPF eleitor]
    L -->|erro| L
    L --> M[Mostrar dados eleitor]
    M --> N[Liberar votação]
    N --> O[Tela pesquisar candidato]

    O --> P[Consultar número candidato]    
    P -->|erro| P
    P -->|ok| Q[Mostrar dados candidato]

    Q --> R[Votar no candidato]   
    R --> S[Excluir eleitor da tabela eleitores]
    S --> T[Inserir matrícula do eleitor na tabela votaram]
    T --> U[Inserir número do candidato na tabela votacao]
    U --> E
```
![](https://mermaid.ink/svg/pako:eNp1VMFy2jAQ_RWNz-QHOLQDBhIykBAgvQgOa2kDmtoSlWUmbcjHdHro9NBTbr36x7qWjVGdqU-e3ffevreS_RIJIzHqRzsLhz1bjzaa0TPg42cUhQNWWA3xdDHYsqurD2zIR2qnnCmYKN-k2hl2LL-nShomkSld_hbKMOq68pfNlPblo3FQ_ix_mI_bWnzopU65yk4s5nEjREiHFQnsfymaSic2fC8zCmWUVkJ1VWpOXHFqyoQiirRQlmGKFMlizihHAlp4FQnS5NuQdpleV0cXsTFfYwrsgPmXQuVQ8RvVbYjtKox9hFs-N7mz5FgY7WCHOm_2ZvJe4A6ZAC2VBOeN1RITL3HNJ_ANW4GsG-Dao274ILEUWMMRd9Sl6AyfVUKlJdl35ZtVpmHceMaUT1DsyVl7Dc5zb31_xmOj8yJ1BIkXk07omQ-N1lLoWVBi8zaxN9mhzT3mjs9UgjY8x6Z_5_v3_67cXpbTerz3wEXgUZd_MrQmwFa4Gr0I3C7Ckvl8Yg8dx--HPfhhS_7J-EGdGTVm6TGr7s0jTeYgqeK0p91kXXnGmk91jtXRZeAsfWUFQemynvm65Ve7spA17LVnP7bsc3wZuOuQBZzX_OjJ46gXEScDJekv8VK1NpHbY4abqE-vEp-AdruJNvqVoMWBNHEsK1tR_wnSHHsRFM6svmoR9Z0t8AwaKaCfTtagXv8CUC6H3g)

#### Orientações Finais

Verifique sempre os comentários no código-fonte para esclarecer dúvidas, o desenho da interface gráfica é feito no KODA depois copia-se e cola o código gerado pelo KODA dentro do arquivo do script AutoIt.
