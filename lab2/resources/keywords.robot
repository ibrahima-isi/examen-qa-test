*** Settings ***
Library    SeleniumLibrary
# Importer les variables Python
Variables    ../pageobject/variables.py 
Variables    ../pageobject/locator.py   

*** Keywords ***
# --- Mots-clés de Pré-conditions / Post-conditions ---

Open Browser To Home Page
    [Documentation]    Ouvre le navigateur et navigue à la page d'accueil.
    Open Browser    ${BASE_URL}    ${BROWSER}   
    Set Selenium Speed    0.5s    # Défini à 0.5s pour la démonstration. Ajustez selon besoin.
    Set Selenium Timeout    10s
    Wait Until Page Contains    Welcome to the customer relationship manager site!

Close Browser Session
    [Documentation]    Ferme la session du navigateur.
    Close Browser

# --- Mots-clés d'Actions Récurrentes ---

Log In With Valid Credentials
    [Documentation]    Effectue la connexion avec des identifiants valides.
    Click Link    ${LOGIN_LINK}
    Wait Until Page Contains    Sign In
    Input Text    ${EMAIL_FIELD}    ${VALID_EMAIL}
    Input Text    ${PASSWORD_FIELD}    ${VALID_PASSWORD}
    Click Button    ${SUBMIT_BUTTON}
    Wait Until Page Contains    Customer
    # Le test 1002 dit 'Contacts page loads', j'assume 'Customers' est le titre de la page de contacts.