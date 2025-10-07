*** Settings ***
Documentation    Ressources communes pour tous les tests de l'API FakeStore
Library          RequestsLibrary
Library          JSONLibrary
Library          Collections
Library          String

*** Variables ***
${BASE_URL}                https://fakestoreapi.com
${CONTENT_TYPE}            application/json
${VALID_PRODUCT_ID}        1
${VALID_USER_ID}           1
${VALID_CART_ID}           1
${INVALID_ID}              999999
${EMPTY_STRING}            ${EMPTY}

# Test Data for Products
&{VALID_PRODUCT_DATA}      title=Test Product    price=99.99    description=Test Description    category=electronics    image=https://test.com/image.jpg
&{INVALID_PRODUCT_DATA}    title=${EMPTY}        price=-10      description=${EMPTY}            category=${EMPTY}       image=invalid-url
&{UPDATE_PRODUCT_DATA}     title=Updated Product    price=149.99    description=Updated Description    category=men's clothing

# Test Data for Users  
&{VALID_USER_DATA}         email=test@example.com    username=testuser    password=testpass123    firstname=John    lastname=Doe    city=TestCity    street=123 Test St    zipcode=12345    phone=555-1234
&{INVALID_USER_DATA}       email=invalid-email       username=${EMPTY}    password=${EMPTY}       firstname=${EMPTY}    lastname=${EMPTY}    city=${EMPTY}    street=${EMPTY}    zipcode=${EMPTY}    phone=${EMPTY}
&{UPDATE_USER_DATA}        email=updated@example.com    username=updateduser    password=newpass123    firstname=Jane    lastname=Smith    city=NewCity    street=456 New St    zipcode=67890    phone=555-9876

# Test Data for Carts
&{VALID_CART_DATA}         userId=1    date=2024-01-01    products=[{"productId": 1, "quantity": 2}]
&{INVALID_CART_DATA}       userId=-1   date=invalid-date  products=invalid-format
&{UPDATE_CART_DATA}        userId=1    date=2024-02-01    products=[{"productId": 2, "quantity": 3}]

*** Keywords ***
Setup Test Suite
    [Documentation]    Configuration initiale pour la suite de tests
    Create Session    fakestore    ${BASE_URL}    verify=True

Teardown Test Suite  
    [Documentation]    Nettoyage après la suite de tests
    Delete All Sessions

Setup Test Case
    [Documentation]    Configuration pour chaque cas de test
    Log    Début du test: ${TEST NAME}

Teardown Test Case
    [Documentation]    Nettoyage après chaque cas de test  
    Log    Fin du test: ${TEST NAME}

Should Be Valid JSON Response
    [Arguments]    ${response}
    [Documentation]    Vérifie que la réponse est un JSON valide
    Should Be Equal As Numbers    ${response.status_code}    200
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json_response}
    RETURN    ${json_response}

Should Be Error Response
    [Arguments]    ${response}    ${expected_status}
    [Documentation]    Vérifie qu'une réponse d'erreur est correcte
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status}

Verify Product Structure
    [Arguments]    ${product}
    [Documentation]    Vérifie la structure d'un objet produit
    Should Contain    ${product}    id
    Should Contain    ${product}    title  
    Should Contain    ${product}    price
    Should Contain    ${product}    description
    Should Contain    ${product}    category
    Should Contain    ${product}    image
    Should Contain    ${product}    rating

Verify User Structure
    [Arguments]    ${user}
    [Documentation]    Vérifie la structure d'un objet utilisateur
    Should Contain    ${user}    id
    Should Contain    ${user}    email
    Should Contain    ${user}    username
    Should Contain    ${user}    name
    Should Contain    ${user}    address
    Should Contain    ${user}    phone

Verify Cart Structure  
    [Arguments]    ${cart}
    [Documentation]    Vérifie la structure d'un objet panier
    Should Contain    ${cart}    id
    Should Contain    ${cart}    userId
    Should Contain    ${cart}    date
    Should Contain    ${cart}    products

Generate Random String
    [Arguments]    ${length}=10
    [Documentation]    Génère une chaîne aléatoire
    ${random_string}=    Generate Random String    ${length}
    RETURN    ${random_string}

Generate Random Email
    [Documentation]    Génère un email aléatoire pour les tests
    ${random}=    Generate Random String    8
    ${email}=    Set Variable    test${random}@example.com
    RETURN    ${email}
