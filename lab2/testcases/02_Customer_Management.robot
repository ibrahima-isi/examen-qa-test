# ./testcases/02_Customer_Management.robot
*** Settings ***
Documentation    Tests d'automatisation pour l'ajout de nouveaux clients (Scénarios 1006 et 1007).

Library    String
Library    DateTime
Resource    ../resources/keywords.robot
Variables    ../pageobject/variables.py

Suite Setup    Generate Unique Email
Test Setup    Setup for Customer Tests
Test Teardown    Close Browser Session

*** Variables ***
# --- Sélecteurs spécifiques (Exemples à vérifier sur la page "Add Customer") ---
${NEW_EMAIL}    ${NONE}


*** Keywords ***
Setup for Customer Tests
    [Documentation]    Pré-conditions pour les tests de gestion des clients (Ouvrir le navigateur et se connecter).
    Open Browser To Home Page
    Log In With Valid Credentials

Generate Unique Email
    ${ts}=    Get Time    result_format=%Y%m%d%H%M%S
    Set Suite Variable    ${NEW_EMAIL}    john.doe.${ts}@test.com
# --- Scénarios de Test ---

*** Test Cases ***
1006 Should be able to add new customer
    [Tags]    Smoke    Contacts
    [Documentation]    Vérifie l'ajout d'un nouveau client avec succès.
    Click Button    ${NEW_CUSTOMER_BUTTON}
    Wait Until Page Contains    ${ADD_CUSTOMER_PAGE_TITLE}

    # J'assume des IDs pour le formulaire client (à vérifier sur la page "Add New Customer")
    Input Text    id:customer-email    ${NEW_EMAIL}
    Input Text    id:first-name    ${FIRST_NAME}
    Input Text    id:last-name    ${LAST_NAME}
    Input Text    id:city    ${CITY}
    
    # 6. Select customer state (Exemple : Assuming 'state' has id 'customer-state')
    Select From List By Value    id:customer-state    QC    # Exemple : 'QC' pour Québec
    # 7. Select gender (Exemple : Assuming a radio button group with name 'gender')
    Select Radio Button    gender    Male
    # 8. Optionally check promotion checkbox (Exemple : Assuming id 'promotion-checkbox')
    Click Element    id:promotion-checkbox
    
    # 9. Click "Submit" button
    Click Button    ${SUBMIT_BUTTON}    # Utilise l'ID CORRIGÉ : id:submit-id
    Wait Until Page Contains    Customer successfully added    # Message de succès supposé

1007 Should be able to cancel adding new customer
    [Tags]    Functional    Contacts
    [Documentation]    Vérifie l'annulation de l'ajout d'un nouveau client.
    Click Button    ${NEW_CUSTOMER_BUTTON}
    Wait Until Page Contains    ${ADD_CUSTOMER_PAGE_TITLE}
    
    # 1. Click "Cancel" button
    Click Button    ${CANCEL_BUTTON}
    
    # Expected Result: Returns to the "Customers" page
    Wait Until Page Contains    Customers
    Location Should Contain    /customers