*** Settings ***
Library    SeleniumLibrary

Test Setup     Run Keywords
...            Open Browser    url=${URL}     browser=${BROWSER}    AND
...            Maximize Browser Window

Test Teardown    Close Browser

*** Variables ***
### Dados de Configuração (POM) ###
 
${URL}    http://sistemas.t2mlab.com:3006/
${BROWSER}    chrome
${HEADLESS_BROWSER}    headlesschrome

### Page Object Model (POM) ###

&{USUARIO}
...    Username=Alan
...    UsernameInvalido=locked_out_user
...    Password=123

&{LOGIN_PAGE}
...    Username=id:formBasicEmail
...    Password=id:formBasicPassword
...    LoginButton=xpath://button/span[contains(text(), "Entrar")]                      
...    ErrorField=xpath://div[@role="alert"]
...    ErrorMessage=Erro ao realizar

&{HOME_PAGE}
...    WelcomeTitle=xpath://*[@id="root"]/div[1]/div/div[2]/div/div/div/div[1]/div/div/span
...    SistemCompetencia=xpath://div[@title="Sistema de Competência"]

&{BuscarEmpresa}
...    URL=http://sistemas.t2mlab.com:3006/buscarEmpresa
...    inputFiltro=xpath://div/input
...    textPesquisarNoInput=IQS

&{MENU_PAGE}
...    BtnSair=xpath://div/span[contains(text(), 'Sair')]
...    BtnConfirmaSair=xpath://div/button[contains(text(), 'Sim')]

*** Keywords ***
############################## LOGIN ########################################## 

Realizar Login com ${username} e ${password}
    Digitar No Input ${LOGIN_PAGE.Username} o texto ${username}
    Digitar No Input ${LOGIN_PAGE.Password} o texto ${password}
    Clicar no elemento ${LOGIN_PAGE.LoginButton}    

Validar Login Foi Feito com Sucesso
    Esperar Campo Ficar Visivel E Disponivel ${HOME_PAGE.WelcomeTitle}
    ${title_login}    Get Text    ${HOME_PAGE.WelcomeTitle}
    Should Contain    ${title_login}    ${USUARIO.Username}

Validar Login NÃO Foi Feito com Sucesso
    Wait Until Element Is Visible    ${LOGIN_PAGE.ErrorField}
    ${TextError}    Get Text    ${LOGIN_PAGE.ErrorField}
    Should Contain    ${TextError}    ${LOGIN_PAGE.ErrorMessage}    

########################################################################  
############################## LOGOUT ##########################################   

Realizar Logout
    Clicar no elemento ${MENU_PAGE.BtnSair}
    Clicar no elemento ${MENU_PAGE.BtnConfirmaSair}
    Wait Until Element Is Enabled    ${LOGIN_PAGE.Username}

######################################################################## 
############################## ACESSAR MENU POR LINK ##########################################   

Acessar opcao do menu ${menu}
    Clicar no elemento ${menu}

######################################################################## 

Digitar No Input ${field} o texto ${texto}
    Wait Until Element Is Enabled    ${field}
    Input Text    ${field}    ${texto}

Esperar Campo Ficar Visivel E Disponivel ${field}
    Wait Until Element Is Visible    ${field}
    Wait Until Element Is Enabled    ${field}

Clicar no elemento ${field}
    Wait Until Element Is Visible    ${field}
    Wait Until Element Is Enabled    ${field}
    Click Element   ${field}

*** Test Cases ***
TC001 - Realizar login com usuário válido
    Realizar Login com ${USUARIO.Username} e ${USUARIO.Password}
    Validar Login Foi Feito com Sucesso

TC002 - Realizar login com usuário inválido
    Realizar Login com ${USUARIO.UsernameInvalido} e ${USUARIO.Password}
    Validar Login NÃO Foi Feito com Sucesso

TC003 - Realizar logout
    Realizar Login com ${USUARIO.Username} e ${USUARIO.Password}
    Validar Login Foi Feito com Sucesso
    Realizar Logout

TC004 - Buscar Setor de Atuação
    Realizar Login com ${USUARIO.Username} e ${USUARIO.Password}
    Validar Login Foi Feito com Sucesso
    Go To    ${BuscarEmpresa.URL}
    Digitar No Input ${BuscarEmpresa.inputFiltro} o texto ${BuscarEmpresa.textPesquisarNoInput}