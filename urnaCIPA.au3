#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <GuiStatusBar.au3>
#include <ButtonConstants.au3>
#include <IE.au3>
#include <Date.au3>

; define variáveis globais

Local $linha,$linhas,$coluna,$matricula,$numero,$cpfEleitor,$HTML,$banco

; lê arquivo de configuração

$bancoDados           = IniRead("configuracao.ini", "Urna", "Banco de Dados da Urna", "")
$senhaIniciarEleicao  = IniRead("configuracao.ini", "Urna", "Senha para Iniciar Eleicao", "8888")
$senhaTerminarEleicao = IniRead("configuracao.ini", "Urna", "Senha para Terminar Eleicao", "9999")
$nomeEmpresa          = IniRead("configuracao.ini", "Urna", "Nome da Empresa", "EMPRESA DE TESTE")
$anoCipa              = IniRead("configuracao.ini", "Urna", "Ano da CIPA", "1990")

; tenta abrir o SQLite para confirmar se a DLL está presente na pasta

_SQLite_Startup()
If @error Then Exit MsgBox(16, "Erro", "Sem os arquivos necessários na pasta!")

; abre o banco de dados

$banco = _SQLite_Open($bancoDados)
If @error Then
    MsgBox(16, "Erro no Banco de Dados", "Não foi possível abrir o arquivo do banco de dados!")
    Exit
 EndIf

; TELA 1 - Código copiado do KODA e personalizadas variáveis de preenchimento dinâmico $nomeEmpresa e $anoCipa
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=tela1.kxf
$tela1 = GUICreate("Urna Eletrônica para Eleição de CIPA - Versão 1.0 - Desenvolvido por DANIEL CARVALHO GIANNI", 801, 601, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "tela1Close")
$Label1 = GUICtrlCreateLabel("Eleição da CIPA", 248, 131, 296, 50)
GUICtrlSetFont($Label1, 30, 400, 0, "MS Sans Serif")
$lbanoCIPA = GUICtrlCreateLabel($anoCipa, 360, 208, 88, 48)
GUICtrlSetFont($lbanoCIPA, 28, 800, 0, "Arial")
$Label2 = GUICtrlCreateLabel($nomeEmpresa, 10, 8, 780, 39)
GUICtrlSetFont($Label2, 18, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("Para iniciar a votação digite o código de Início de Votação e aperte ENTER", 232, 336, 364, 17)
$codigoVotacao = GUICtrlCreateInput("", 344, 376, 121, 37, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_PASSWORD,$ES_NUMBER))
GUICtrlSetOnEvent($codigoVotacao, "codigoVotacaoChange")
GUICtrlSetLimit($codigoVotacao, 4)
GUICtrlSetFont($codigoVotacao, 18, 400, 0, "MS Sans Serif")
$StatusBar1 = _GUICtrlStatusBar_Create($tela1)
_GUICtrlStatusBar_SetSimple($StatusBar1)
_GUICtrlStatusBar_SetText($StatusBar1, "Aguardando digitação do código...")
$Label4 = GUICtrlCreateLabel("Para terminar a votação digite o código de Término de Votação e aperte ENTER", 224, 440, 385, 17)
GUISetState(@SW_SHOW, $tela1)
#EndRegion ### END Koda GUI section ###

; TELA 2 - Código copiado do KODA e personalizadas variáveis de preenchimento dinâmico $nomeEmpresa e $anoCipa
#Region ### START Koda GUI section ### Form=tela2.kxf
$tela2 = GUICreate("Urna Eletrônica para Eleição de CIPA - Versão 1.0 - Desenvolvido por DANIEL CARVALHO GIANNI", 1025, 721, -1, -1, BitOR($WS_SYSMENU,$DS_MODALFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "tela2Close")
$Label2 = GUICtrlCreateLabel("Eleição da CIPA", 840, 11, 140, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$lbanoCIPA = GUICtrlCreateLabel($anoCipa, 864, 40, 88, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Label3 = GUICtrlCreateLabel($nomeEmpresa, 10, 8, 780, 39)
GUICtrlSetFont(-1, 18, 400, 0, "Arial")
$Label1 = GUICtrlCreateLabel("Total de Eleitores", 24, 139, 150, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$eleitores = GUICtrlCreateLabel("0", 200, 128, 169, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Label4 = GUICtrlCreateLabel("Total que já Votou", 24, 211, 157, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$jaVotou = GUICtrlCreateLabel("0", 200, 200, 177, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Label6 = GUICtrlCreateLabel("Total de Candidatos", 24, 291, 171, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$candidatos = GUICtrlCreateLabel("0", 200, 280, 185, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Label5 = GUICtrlCreateLabel("Total de Votos", 24, 363, 125, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$votos = GUICtrlCreateLabel("0", 200, 352, 193, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Label7 = GUICtrlCreateLabel("Digite o NÚMERO DO CPF do eleitor:", 488, 184, 319, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$cpf = GUICtrlCreateInput("", 560, 228, 185, 37, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit(-1, 11)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
$pesquisarEleitor = GUICtrlCreateButton("Pesquisar Eleitor", 560, 288, 187, 49)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "pesquisarEleitorClick")
$Group1 = GUICtrlCreateGroup(" Confira se o Eleitor está corretamente sendo exibido abaixo: ", 32, 440, 777, 249)
$Label8 = GUICtrlCreateLabel("Matrícula do Eleitor", 64, 520, 96, 17)
$Label9 = GUICtrlCreateLabel("Nome do Eleitor", 64, 488, 79, 17)
$Label10 = GUICtrlCreateLabel("CPF do Eleitor", 64, 560, 71, 17)
$Label11 = GUICtrlCreateLabel("Cargo", 64, 600, 32, 17)
$Label12 = GUICtrlCreateLabel("Departamento", 64, 640, 71, 17)
$eleitorNome = GUICtrlCreateLabel("", 168, 480, 618, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$eleitorMatricula = GUICtrlCreateLabel("", 168, 512, 362, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$eleitorCPF = GUICtrlCreateLabel("", 168, 552, 354, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$eleitorCargo = GUICtrlCreateLabel("", 168, 592, 626, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$eleitorDepartamento = GUICtrlCreateLabel("", 168, 632, 626, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$votar = GUICtrlCreateButton("Autorizar Votação", 832, 512, 171, 113)
GUICtrlSetOnEvent(-1, "votarClick")
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetData($eleitores, contaEleitores($linhas))
GUICtrlSetData($jaVotou, contaJaVotaram($linhas))
GUICtrlSetData($candidatos, contaCandidatos($linhas))
GUICtrlSetData($votos, contaVotos($linhas))
#EndRegion ### END Koda GUI section ###


; TELA 3 - Código copiado do KODA e personalizadas variáveis de preenchimento dinâmico $nomeEmpresa e $anoCipa
#Region ### START Koda GUI section ### Form=tela3.kxf
$tela3 = GUICreate("Urna Eletrônica para Eleição de CIPA - Versão 1.0 - Desenvolvido por DANIEL CARVALHO GIANNI", 1025, 721, -1, -1, BitOR($WS_SYSMENU,$DS_MODALFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "tela3Close")
$Label3 = GUICtrlCreateLabel($nomeEmpresa, 10, 8, 780, 39)
GUICtrlSetFont(-1, 18, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel("Eleição da CIPA", 840, 11, 140, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$lbanoCIPA = GUICtrlCreateLabel($anoCipa, 864, 40, 88, 48)
GUICtrlSetFont(-1, 28, 800, 0, "Arial")
$Group1 = GUICtrlCreateGroup(" CANDIDATO ESCOLHIDO ", 100, 310, 777, 249)
$Label8 = GUICtrlCreateLabel("Número do Candidato", 120, 400, 107, 17)
$Label9 = GUICtrlCreateLabel("Nome do Candidato", 120, 358, 98, 17)
$Label10 = GUICtrlCreateLabel("Função", 120, 450, 40, 17)
$Label11 = GUICtrlCreateLabel("Unidade", 120, 490, 44, 17)
$candidatoNome = GUICtrlCreateLabel("", 236, 350, 618, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$candidatoNumero = GUICtrlCreateLabel("", 236, 400, 362, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$candidatoFuncao = GUICtrlCreateLabel("", 236, 450, 354, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
$candidatoUnidade = GUICtrlCreateLabel("", 236, 485, 626, 28)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label1 = GUICtrlCreateLabel("A) Digite o número do candidato com 2 dígitos e clique no VERIFICAR", 20, 100, 607, 33)
GUICtrlSetFont(-1, 18, 400, 0, "Arial Narrow")
$numeroDigitado = GUICtrlCreateInput("", 248, 160, 121, 45, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit(-1, 2)
GUICtrlSetFont(-1, 24, 400, 0, "Arial Narrow")
$verificarCandidato = GUICtrlCreateButton("VERIFICAR", 416, 150, 179, 65)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "verificarCandidatoClick")
$Label4 = GUICtrlCreateLabel("B) Depois de clicar no VERIFICAR, confira no quadro se este candidato é o que você deseja votar!", 20, 260, 855, 33)
GUICtrlSetFont(-1, 18, 400, 0, "Arial Narrow")
$votou = GUICtrlCreateButton("CONFIRMO MEU VOTO", 592, 590, 379, 97, $BS_MULTILINE)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "votouClick")
$Label5 = GUICtrlCreateLabel("C) Depois de conferir, clique no CONFIRMO MEU VOTO,", 22, 608, 502, 33, $SS_NOPREFIX)
GUICtrlSetFont(-1, 18, 400, 0, "Arial Narrow")
$Label6 = GUICtrlCreateLabel("para depositar seu voto na urna e terminar sua votação!", 47, 648, 488, 33, $SS_NOPREFIX)
GUICtrlSetFont(-1, 18, 400, 0, "Arial Narrow")
$Label7 = GUICtrlCreateLabel("Eleitor votando:", 24, 64, 78, 17)
$eleitorVotando = GUICtrlCreateLabel("", 112, 56, 718, 25)
GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
#EndRegion ### END Koda GUI section ###

; loop infinito necessário para manter a interface gráfica funcionando
While 1
 Sleep(100)
WEnd

; função que é disparada quando clica no botão fechar da primeirao tela que faz o fechamento do banco de dados e encerra o urnaCIPA.exe

Func tela1Close()
 _SQLite_Close($banco)
 _SQLite_Shutdown()
 Exit
EndFunc

; função que é disparada quando clica no botão fechar da segunda tela, oculta as demais, preenche os campos na tela com texto padrão

Func tela2Close()
   GUISetState(@SW_HIDE, $tela2)
   GUISetState(@SW_HIDE, $tela3)
   GUISetState(@SW_SHOW, $tela1)
   GUICtrlSetData($codigoVotacao, "")
   GUICtrlSetData($cpf, "")
   GUICtrlSetData($numeroDigitado, "")
   _GUICtrlStatusBar_SetText($StatusBar1, "Aguardando digitação do código...")
EndFunc

; código disparado quando digita o código de 4 dígitos na primeira tela
; se o código for de iniciar Eleição abre a segunda tela e oculta a primeira
; se o código for de terminar Eleição seta mensagem para aguardar finalização da Eleição, chama a função que finaliza a Eleição, fecha o banco de dados e encerra o urnaCIPA.exe
Func codigoVotacaoChange()
 If GUICtrlRead($codigoVotacao) == $senhaIniciarEleicao Then
   GUISetState(@SW_HIDE, $tela1)
   GUISetState(@SW_SHOW, $tela2)
   _GUICtrlStatusBar_SetText($StatusBar1, "Acessando painel de votação...")
   GUICtrlSetData($eleitores, contaEleitores($linhas))
   GUICtrlSetData($jaVotou, contaJaVotaram($linhas))
   GUICtrlSetData($candidatos, contaCandidatos($linhas))
   GUICtrlSetData($votos, contaVotos($linhas))
 ElseIf GUICtrlRead($codigoVotacao) == $senhaTerminarEleicao Then
    _GUICtrlStatusBar_SetText($StatusBar1, "Aguarde... Finalizando a Eleição!")
    finalizarEleicao($linhas);
    _SQLite_Close($banco)
    _SQLite_Shutdown()
    Exit
   Else
   _GUICtrlStatusBar_SetText($StatusBar1, "Código informado não é válido...")
   return False
 EndIf
EndFunc

; função que é executada quando clica no botão para pesquisar eleitor na segunda tela
; procura o eleitor pelo cpf digitado, se encontrou preenche os dados encontrados na tela, caso contrário exibe mensagem de erro
Func pesquisarEleitorClick()
 $eleitor=retornaEleitor($linha, GUICtrlRead($cpf) )
 If $eleitor == "eleitor não encontrado" And GUICtrlRead($eleitorNome) == "" Then
   GUICtrlSetData($eleitorNome,"")
   GUICtrlSetData($eleitorMatricula,"")
   GUICtrlSetData($eleitorCPF,"")
   GUICtrlSetData($eleitorCargo,"")
   GUICtrlSetData($eleitorDepartamento,"")
    MsgBox(48, "Erro na Pesquisa", "Esse eleitor não foi encontrado no banco de dados.")
	return False
 Else
  $cpfEleitor=$eleitor[2]
  GUICtrlSetData($eleitorNome,$eleitor[0])
  GUICtrlSetData($eleitorMatricula,$eleitor[1])
  GUICtrlSetData($eleitorCPF,$eleitor[2])
  GUICtrlSetData($eleitorCargo,$eleitor[3])
  GUICtrlSetData($eleitorDepartamento,$eleitor[4])
  GUICtrlSetData($eleitores, contaEleitores($linhas))
  GUICtrlSetData($jaVotou, contaJaVotaram($linhas))
  GUICtrlSetData($candidatos, contaCandidatos($linhas))
  GUICtrlSetData($votos, contaVotos($linhas))
 EndIf
EndFunc

; função que é executada quando clica no botão para autorizar o eleitor votar na segunda tela
; esconde as telas anteriores e carrega as informacoes do eleitor na tela 3 limpando os dados do eleitor na tela 2

Func votarClick()
   If GUICtrlRead($eleitorNome) <> "" and GUICtrlRead($cpf) <> "" Then
    GUISetState(@SW_HIDE, $tela1)
    GUISetState(@SW_HIDE, $tela2)
    GUISetState(@SW_SHOW, $tela3)
    GUICtrlSetData($numeroDigitado, "")
    GUICtrlSetData($candidatoNome, "")
    GUICtrlSetData($candidatoNumero, "")
    GUICtrlSetData($candidatoFuncao, "")
    GUICtrlSetData($candidatoUnidade, "")
    GUICtrlSetData($codigoVotacao, "")
    GUICtrlSetData($cpf, "")
    GUICtrlSetData($numeroDigitado, "")
	GUICtrlSetData($eleitorVotando, GUICtrlRead($eleitorNome))
    _GUICtrlStatusBar_SetText($StatusBar1, "Aguardando digitação do código...")
   Else
    MsgBox(48, "Erro na Pesquisa", "Não foram carregados os dados do eleitor a partir do CPF!")
	return False
   EndIf
EndFunc

; função que é executada quando clica no fechar da tela 3 que ativa a tela 2 e limpa os dados do candidato e do eleitor nas respectiva tela1Close

Func tela3Close()
   GUISetState(@SW_HIDE, $tela1)
   GUISetState(@SW_HIDE, $tela3)
   GUISetState(@SW_SHOW, $tela2)
   GUICtrlSetData($codigoVotacao, "")
   GUICtrlSetData($cpf, "")
   GUICtrlSetData($numeroDigitado, "")
   GUICtrlSetData($candidatoNome, "")
   GUICtrlSetData($candidatoNumero, "")
   GUICtrlSetData($candidatoFuncao, "")
   GUICtrlSetData($candidatoUnidade, "")
   GUICtrlSetData($eleitorNome,"")
   GUICtrlSetData($eleitorMatricula,"")
   GUICtrlSetData($eleitorCPF,"")
   GUICtrlSetData($eleitorCargo,"")
   GUICtrlSetData($eleitorDepartamento,"")
   GUICtrlSetData($eleitores, contaEleitores($linhas))
   GUICtrlSetData($jaVotou, contaJaVotaram($linhas))
   GUICtrlSetData($candidatos, contaCandidatos($linhas))
   GUICtrlSetData($votos, contaVotos($linhas))
   _GUICtrlStatusBar_SetText($StatusBar1, "Aguardando digitação do código...")
EndFunc

; função que é executada quando o eleitor clica no botão para confirmar o voto
; chama a função para fazer a gravação do voto no banco de dados e faz várias verificações para garantir que as exclusões e gravações no banco sejam executadas avisando de qualquer error

Func votouClick()
 If GUICtrlRead($candidatoNome) == "" And GUICtrlRead($numeroDigitado) <> "" Then
    MsgBox(16, "Erro na Pesquisa", "Esse NÚMERO do Candidato não foi encontrado no banco de dados.")
	return False
 Else
	If GUICtrlRead($candidatoNumero) <> "" and GUICtrlRead($candidatoNome) <> ""  Then
	 Switch insereVoto($linha,$cpfEleitor,GUICtrlRead($candidatoNumero))
      Case "eleitor não encontrado"
       MsgBox(16, "Erro na Votação", "Dados do Eleitor não puderam ser confirmados durante a votação.")
	   return False
      Case "votando novamente"
       MsgBox(16, "Erro na Votação", "Eleitor já votou e está tentando votar novamente.")
	   return False
      Case "voto não registrado"
       MsgBox(16, "Erro na Votação", "Não foi possível gravar o voto no banco de dados.")
	   return False
      Case "eleitor permanece no banco"
       MsgBox(16, "Erro na Votação", "Cancele a Eleição, urna comprometida, eleitor permanece no banco de dados como apto a votar novamente.")
	   return False
	  Case Else
       GUICtrlSetData($codigoVotacao, "")
       GUICtrlSetData($cpf, "")
       GUICtrlSetData($numeroDigitado, "")
       GUICtrlSetData($candidatoNome, "")
       GUICtrlSetData($candidatoNumero, "")
       GUICtrlSetData($candidatoFuncao, "")
       GUICtrlSetData($candidatoUnidade, "")
       GUICtrlSetData($eleitorNome,"")
	   GUICtrlSetData($eleitorMatricula,"")
       GUICtrlSetData($eleitorCPF,"")
       GUICtrlSetData($eleitorCargo,"")
	   GUICtrlSetData($eleitorDepartamento,"")
       GUICtrlSetData($eleitores, contaEleitores($linhas))
       GUICtrlSetData($jaVotou, contaJaVotaram($linhas))
       GUICtrlSetData($candidatos, contaCandidatos($linhas))
       GUICtrlSetData($votos, contaVotos($linhas))
       _GUICtrlStatusBar_SetText($StatusBar1, "Aguardando digitação do código...")
       MsgBox(64, "Sucesso na Votação", "Seu voto foi registrado com sucesso.")
       GUISetState(@SW_HIDE, $tela1)
       GUISetState(@SW_HIDE, $tela3)
       GUISetState(@SW_SHOW, $tela2)
      EndSwitch

   Else
	MsgBox(16, "Erro na Pesquisa", "Você NÃO VERIFICOU os dados do candidato!")
	return False
   EndIf
 EndIf

EndFunc

; função que faz a busca do candidato no banco de dados para retornar as informações do candidato e preencher na tela três

Func verificarCandidatoClick()
 $nroCandidato=GUICtrlRead($numeroDigitado)
 if $nroCandidato > 0 and $nroCandidato < 10 then $nroCandidato="0"&$nroCandidato
 GUICtrlSetData($numeroDigitado, $nroCandidato)
 $candidato=retornaCandidato($linha, $nroCandidato )
 If $candidato == "candidato não encontrado" Then
    MsgBox(16, "Erro na Pesquisa", "Esse NÚMERO do Candidato não foi encontrado no banco de dados, confira com o Mesário a relação de candidatos.")
	return False
 Else
   GUICtrlSetData($candidatoNome, $candidato[2])
   GUICtrlSetData($candidatoNumero, $candidato[0])
   GUICtrlSetData($candidatoFuncao, $candidato[3])
   GUICtrlSetData($candidatoUnidade, $candidato[4])
 EndIf
EndFunc


; função que faz a contagem dos votos depois da finalização, monta um HTML e abre o internet explorer com o código html para permitir a impressão do relatório bastando confirmar em qual impressora deseja imprimir.

Func finalizarEleicao($linhas)
 Local $IE = _IECreate()
 Local $HTML = ""
 $HTML &= "<html><head><title>Resultado da Eleição da CIPA " & $anoCipa & " - " & $nomeEmpresa  & "</title><meta charset='UTF-8'></head><body>"
 $HTML &= "<h1>Resultado da Eleição da CIPA " & $anoCipa & "</h1>"
 $HTML &= "<h2>" & $nomeEmpresa  & "</h2><hr>"
 $HTML &= "<h2>TOTALIZAÇÃO DE VOTOS APÓS ENCERRAMENTO DA VOTAÇÃO  "& _Now() &" PARA CANDIDADOS QUE TIVERAM PELO MENOS 1 VOTO OU MAIS.</h2><table border='1' style='font-family:Arial Black, Gadget, sans-serif'><th>Número</th><th>Nome do Candidato</th><th>Matrícula</th><th>Função</th><th>Unidade</th><th>Total de Votos</th>"
  _SQLite_Query(-1, "SELECT COUNT(*) as Votos, Numero FROM votacao GROUP BY Numero ORDER BY Votos DESC;", $banco)
  While _SQLite_FetchData($banco, $linhas, False, False) = $SQLITE_OK
	$numero = $linhas[1]
	$votos  = $linhas[0]
	$candidato=retornaCandidato($linhas,$numero)
    $candidatoNome=$candidato[2]
    $candidatoMatricula=$candidato[1]
    $candidatoFuncao=$candidato[3]
    $candidatoUnidade=$candidato[4]
    $HTML &= "<tr><td align='center'>[" & $numero & "]</td><td>" & $candidatoNome & "</td><td>" & $candidatoMatricula & "</td><td>" & $candidatoFuncao & "</td><td>" & $candidatoUnidade & "</td><td align='center'>[" & $votos & "]</td></tr>"
 WEnd
 _SQLite_Exec(-1, "DELETE FROM eleitores;")
 _SQLite_QueryFinalize($linhas)
 $HTML &= "</table></body></html>"
 _IEBodyWriteHTML($IE, $HTML)
 _IEAction($IE, "print")
EndFunc

; função que calcula a quantidade de candidatos no banco de Dados

Func contaCandidatos($linhas)
 _SQLite_QuerySingleRow(-1, "SELECT COUNT(NOME) AS QTD FROM candidatos;", $linhas)
 return $linhas[0]
EndFunc

; função que calcula a quantidade de eleitores no banco de Dados

Func contaEleitores($linhas)
 _SQLite_QuerySingleRow(-1, "SELECT COUNT(CPF) AS QTD FROM eleitores;", $linhas)
 return $linhas[0]
EndFunc

; função que calcula a quantidade de eleitores que já votaram

Func contaJaVotaram($linhas)
 _SQLite_QuerySingleRow(-1, "SELECT COUNT(MATRICULA) AS QTD FROM votaram;", $linhas)
 return $linhas[0]
EndFunc

; função que calcula quantos votos foram registrados no banco de Dados

Func contaVotos($linhas)
 _SQLite_QuerySingleRow(-1, "SELECT COUNT(ID) AS QTD FROM votacao;", $linhas)
 return $linhas[0]
EndFunc

; função que procura no banco de dados um candidato pelo número e retorna os dados do candidato

Func retornaCandidato($linhas,$numero)
 If $SQLITE_OK <> _SQLite_QuerySingleRow(-1, "SELECT * FROM candidatos WHERE numero = '" & $numero & "';", $linhas) Then return "candidato não encontrado"
  return $linhas
EndFunc

; função que procura no banco de dados um eleitor pelo cpf e retorna os dados do eleitor

Func retornaEleitor($linhas,$cpf)
  If $SQLITE_OK <> _SQLite_QuerySingleRow(-1, "SELECT * FROM eleitores WHERE REPLACE(REPLACE(REPLACE(CPF,'.',''),'/',''),'-','') = '" & $cpf & "';", $linhas) Then return "eleitor não encontrado"
 return $linhas
EndFunc

; função que insere o voto na tabela de votacao do banco de dados, remove o eleitor da tabela editores e insere a matrícula do eleitor na tabela votaram

Func insereVoto($linhas,$cpf,$numeroCandidato)
 $cpf=StringReplace(StringReplace(StringReplace($cpf,"-",""),"/",""),".","")
 $eleitor=retornaEleitor($linhas,$cpf)
 If $eleitor == "eleitor não encontrado"  Then
   return "eleitor não encontrado"
 Else
 $matricula=$eleitor[1]
 EndIf
 ConsoleWrite($numeroCandidato&@CRLF)
 If $SQLITE_OK <> _SQLite_Exec(-1, "INSERT INTO votaram (matricula) VALUES ('" & $matricula &"');") Then return "votando novamente"
 If $SQLITE_OK <> _SQLite_Exec(-1, "INSERT INTO votacao (numero) VALUES ('" & $numeroCandidato & "');") Then return "voto não registrado"
 If $SQLITE_OK <> _SQLite_Exec(-1, "DELETE FROM eleitores WHERE codigo = '" & $matricula & "';") Then return "eleitor permanece no banco"
 return "votacao ok"
EndFunc
