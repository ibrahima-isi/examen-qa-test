*** Settings ***
Documentation    Tests d'automatisation pour la page d'accueil et la fonctionnalité de connexion (Scénarios 1001 à 1003).

Resource    ../resources/keywords.robot
Variables    ../pageobject/variables.py

Test Setup    Open Browser To Home Page
Test Teardown    Close Browser Session


*** Test Cases ***
1001 Home page should load
    [Tags]    Smoke    Home
    [Documentation]    Vérifie que la page d'accueil se charge et que ses éléments existent.
    
    Page Should Contain Element    ${LOGIN_LINK}    # Vérifie que le lien de connexion est présent

1002 Login should succeed with valid credentials
    [Tags]    Smoke    Login
    [Documentation]    Vérifie que la connexion réussit avec des identifiants valides.
    Log In With Valid Credentials
    # Vérification déjà faite dans le mot-clé, mais on peut vérifier l'URL ou un élément post-connexion
    Location Should Contain    /customers

1003 Login should fail with missing credentials
    [Tags]    Functional    Login
    [Documentation]    Vérifie que la connexion échoue si les identifiants sont manquants.
    Click Link    ${LOGIN_LINK}
    Wait Until Page Contains    Login
    # Ne rien mettre dans les champs ou laisser seulement l'email vide (selon le comportement souhaité)
    Input Text    ${EMAIL_FIELD}    ${INVALID_EMAIL}
    Input Text    ${PASSWORD_FIELD}    ${INVALID_PASSWORD}    
    Click Button    ${SUBMIT_BUTTON}
    Location Should Contain    /login