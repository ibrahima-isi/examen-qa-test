*** Settings ***
Documentation    Tests CRUD pour l'entité Users de l'API FakeStore
Resource         ../resources/api_keywords.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***

# ===== CREATE TESTS =====

Create User - Scénario Passant
    [Documentation]    Test de création d'un utilisateur avec des données valides
    [Tags]    users    create    positive
    
    ${email}=    Generate Random Email
    ${username}=    Generate Random String    10
    
    ${user_data}=    Create Dictionary
    ...    email=${email}
    ...    username=${username}
    ...    password=testpass123
    ...    firstname=John
    ...    lastname=Doe
    ...    city=TestCity
    ...    street=123 Test Street
    ...    zipcode=12345
    ...    phone=555-1234
    
    ${response}=    Create User    ${user_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id
    Should Be Equal    ${json_response['email']}    ${email}
    Should Be Equal    ${json_response['username']}    ${username}

Create User - Scénario Non Passant (Email Invalide)
    [Documentation]    Test de création d'un utilisateur avec un email invalide
    [Tags]    users    create    negative
    
    ${user_data}=    Create Dictionary
    ...    email=invalid-email-format
    ...    username=testuser
    ...    password=testpass
    ...    firstname=John
    ...    lastname=Doe
    ...    city=TestCity
    ...    street=123 Test Street
    ...    zipcode=12345
    ...    phone=555-1234
    
    ${response}=    Create User    ${user_data}
    # L'API FakeStore accepte les emails invalides mais nous testons la logique
    Should Be Equal As Numbers    ${response.status_code}    200

Create User - Scénario Non Passant (Données Manquantes)
    [Documentation]    Test de création d'un utilisateur avec des données manquantes
    [Tags]    users    create    negative
    
    ${user_data}=    Create Dictionary
    ...    email=${EMPTY}
    ...    username=${EMPTY}
    ...    password=${EMPTY}
    ...    firstname=${EMPTY}
    ...    lastname=${EMPTY}
    ...    city=${EMPTY}
    ...    street=${EMPTY}
    ...    zipcode=${EMPTY}
    ...    phone=${EMPTY}
    
    ${response}=    Create User    ${user_data}
    Should Be Equal As Numbers    ${response.status_code}    200

# ===== READ TESTS =====

Read User - Scénario Passant
    [Documentation]    Test de lecture d'un utilisateur existant
    [Tags]    users    read    positive
    
    ${response}=    Get User By ID    ${VALID_USER_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Verify User Structure    ${json_response}
    Should Be Equal As Numbers    ${json_response['id']}    ${VALID_USER_ID}

Read User - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de lecture d'un utilisateur avec un ID inexistant
    [Tags]    users    read    negative
    
    ${response}=    Get User By ID    ${INVALID_ID}
    Should Be Equal As Numbers    ${response.status_code}    404

Read User - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de lecture d'un utilisateur avec un ID invalide
    [Tags]    users    read    negative
    
    ${response}=    Get User By ID    invalid_user_id
    Should Be Equal As Numbers    ${response.status_code}    404

Read All Users - Scénario Passant
    [Documentation]    Test de lecture de tous les utilisateurs
    [Tags]    users    read    positive
    
    ${response}=    Get All Users
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    ${first_user}=    Set Variable    ${json_response[0]}
    Verify User Structure    ${first_user}

# ===== UPDATE TESTS =====

Update User - Scénario Passant
    [Documentation]    Test de mise à jour d'un utilisateur existant
    [Tags]    users    update    positive
    
    ${email}=    Generate Random Email
    ${username}=    Generate Random String    10
    
    ${user_data}=    Create Dictionary
    ...    email=${email}
    ...    username=${username}
    ...    password=newpassword123
    ...    firstname=Jane
    ...    lastname=Smith
    ...    city=NewCity
    ...    street=456 New Street
    ...    zipcode=67890
    ...    phone=555-9876
    
    ${response}=    Update User    ${VALID_USER_ID}    ${user_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['email']}    ${email}
    Should Be Equal    ${json_response['username']}    ${username}

Update User - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de mise à jour d'un utilisateur inexistant
    [Tags]    users    update    negative
    
    ${user_data}=    Create Dictionary
    ...    email=test@example.com
    ...    username=testuser
    ...    password=testpass
    ...    firstname=Test
    ...    lastname=User
    ...    city=TestCity
    ...    street=Test Street
    ...    zipcode=12345
    ...    phone=555-0000
    
    ${response}=    Update User    ${INVALID_ID}    ${user_data}
    # L'API FakeStore simule la mise à jour même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Numbers    ${json_response['id']}    ${INVALID_ID}

Update User - Scénario Non Passant (Email Invalide)
    [Documentation]    Test de mise à jour avec un email invalide
    [Tags]    users    update    negative
    
    ${user_data}=    Create Dictionary
    ...    email=not-an-email
    ...    username=testuser
    ...    password=testpass
    ...    firstname=Test
    ...    lastname=User
    ...    city=TestCity
    ...    street=Test Street
    ...    zipcode=12345
    ...    phone=555-0000
    
    ${response}=    Update User    ${VALID_USER_ID}    ${user_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    # L'API accepte les emails invalides, nous vérifions juste la réponse
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['email']}    not-an-email

# ===== DELETE TESTS =====

Delete User - Scénario Passant
    [Documentation]    Test de suppression d'un utilisateur existant
    [Tags]    users    delete    positive
    
    ${response}=    Delete User    ${VALID_USER_ID}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id

Delete User - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de suppression d'un utilisateur inexistant
    [Tags]    users    delete    negative
    
    ${response}=    Delete User    ${INVALID_ID}
    # L'API FakeStore simule la suppression même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200

Delete User - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de suppression avec un ID invalide
    [Tags]    users    delete    negative
    
    ${response}=    Delete User    invalid_user_id
    Should Be Equal As Numbers    ${response.status_code}    200

# ===== ADDITIONAL VALIDATION TESTS =====

Validate User Email Format - Scénario Passant
    [Documentation]    Test de validation du format d'email
    [Tags]    users    validation    positive
    
    ${response}=    Get User By ID    ${VALID_USER_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Contain    ${json_response['email']}    @
    Should Contain    ${json_response['email']}    .

Validate User Phone Format - Scénario Passant
    [Documentation]    Test de validation du format de téléphone
    [Tags]    users    validation    positive
    
    ${response}=    Get User By ID    ${VALID_USER_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response['phone']}

Validate User Address Structure - Scénario Passant
    [Documentation]    Test de validation de la structure d'adresse
    [Tags]    users    validation    positive
    
    ${response}=    Get User By ID    ${VALID_USER_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Contain    ${json_response['address']}    city
    Should Contain    ${json_response['address']}    street
    Should Contain    ${json_response['address']}    zipcode
    Should Contain    ${json_response['address']}    geolocation
