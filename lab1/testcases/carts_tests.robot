*** Settings ***
Documentation    Tests CRUD pour l'entité Carts de l'API FakeStore
Resource         ../resources/api_keywords.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***

# ===== CREATE TESTS =====

Create Cart - Scénario Passant
    [Documentation]    Test de création d'un panier avec des données valides
    [Tags]    carts    create    positive
    
    ${cart_data}=    Create Dictionary
    ...    userId=1
    ...    date=2024-01-01
    ...    products=[{"productId": 1, "quantity": 2}, {"productId": 2, "quantity": 1}]
    
    ${response}=    Create Cart    ${cart_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id
    Should Be Equal As Numbers    ${json_response['userId']}    1

Create Cart - Scénario Non Passant (UserID Invalide)
    [Documentation]    Test de création d'un panier avec un userID invalide
    [Tags]    carts    create    negative
    
    ${cart_data}=    Create Dictionary
    ...    userId=-1
    ...    date=2024-01-01
    ...    products=[{"productId": 1, "quantity": 2}]
    
    ${response}=    Create Cart    ${cart_data}
    # L'API FakeStore accepte les userID négatifs mais nous testons la logique
    Should Be Equal As Numbers    ${response.status_code}    200

Create Cart - Scénario Non Passant (Format Produits Invalide)
    [Documentation]    Test de création d'un panier avec un format de produits invalide
    [Tags]    carts    create    negative
    
    ${cart_data}=    Create Dictionary
    ...    userId=1
    ...    date=2024-01-01
    ...    products=invalid_format
    
    ${response}=    Create Cart    ${cart_data}
    Should Be Equal As Numbers    ${response.status_code}    200

# ===== READ TESTS =====

Read Cart - Scénario Passant
    [Documentation]    Test de lecture d'un panier existant
    [Tags]    carts    read    positive
    
    ${response}=    Get Cart By ID    ${VALID_CART_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Verify Cart Structure    ${json_response}
    Should Be Equal As Numbers    ${json_response['id']}    ${VALID_CART_ID}

Read Cart - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de lecture d'un panier avec un ID inexistant
    [Tags]    carts    read    negative
    
    ${response}=    Get Cart By ID    ${INVALID_ID}
    Should Be Equal As Numbers    ${response.status_code}    404

Read Cart - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de lecture d'un panier avec un ID invalide
    [Tags]    carts    read    negative
    
    ${response}=    Get Cart By ID    invalid_cart_id
    Should Be Equal As Numbers    ${response.status_code}    404

Read All Carts - Scénario Passant
    [Documentation]    Test de lecture de tous les paniers
    [Tags]    carts    read    positive
    
    ${response}=    Get All Carts
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    ${first_cart}=    Set Variable    ${json_response[0]}
    Verify Cart Structure    ${first_cart}

# ===== UPDATE TESTS =====

Update Cart - Scénario Passant
    [Documentation]    Test de mise à jour d'un panier existant
    [Tags]    carts    update    positive
    
    ${cart_data}=    Create Dictionary
    ...    userId=1
    ...    date=2024-02-01
    ...    products=[{"productId": 3, "quantity": 5}]
    
    ${response}=    Update Cart    ${VALID_CART_ID}    ${cart_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['date']}    2024-02-01

Update Cart - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de mise à jour d'un panier inexistant
    [Tags]    carts    update    negative
    
    ${cart_data}=    Create Dictionary
    ...    userId=1
    ...    date=2024-01-01
    ...    products=[{"productId": 1, "quantity": 1}]
    
    ${response}=    Update Cart    ${INVALID_ID}    ${cart_data}
    # L'API FakeStore simule la mise à jour même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Numbers    ${json_response['id']}    ${INVALID_ID}

Update Cart - Scénario Non Passant (Date Invalide)
    [Documentation]    Test de mise à jour avec une date invalide
    [Tags]    carts    update    negative
    
    ${cart_data}=    Create Dictionary
    ...    userId=1
    ...    date=invalid-date-format
    ...    products=[{"productId": 1, "quantity": 1}]
    
    ${response}=    Update Cart    ${VALID_CART_ID}    ${cart_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    # L'API accepte les dates invalides, nous vérifions juste la réponse
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['date']}    invalid-date-format

# ===== DELETE TESTS =====

Delete Cart - Scénario Passant
    [Documentation]    Test de suppression d'un panier existant
    [Tags]    carts    delete    positive
    
    ${response}=    Delete Cart    ${VALID_CART_ID}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id

Delete Cart - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de suppression d'un panier inexistant
    [Tags]    carts    delete    negative
    
    ${response}=    Delete Cart    ${INVALID_ID}
    # L'API FakeStore simule la suppression même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200

Delete Cart - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de suppression avec un ID invalide
    [Tags]    carts    delete    negative
    
    ${response}=    Delete Cart    invalid_cart_id
    Should Be Equal As Numbers    ${response.status_code}    200

# ===== ADVANCED TESTS =====

Get Carts By User - Scénario Passant
    [Documentation]    Test de récupération des paniers d'un utilisateur spécifique
    [Tags]    carts    read    positive
    
    ${response}=    Get Carts By User    ${VALID_USER_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    FOR    ${cart}    IN    @{json_response}
        Should Be Equal As Numbers    ${cart['userId']}    ${VALID_USER_ID}
    END

Get Carts By User - Scénario Non Passant (User Inexistant)
    [Documentation]    Test avec un utilisateur inexistant
    [Tags]    carts    read    negative
    
    ${response}=    Get Carts By User    ${INVALID_ID}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Empty    ${json_response}

Get Carts By Date Range - Scénario Passant
    [Documentation]    Test de récupération des paniers par plage de dates
    [Tags]    carts    read    positive
    
    ${response}=    Get Carts By Date Range    2019-01-01    2020-12-31
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json_response}

Get Carts By Date Range - Scénario Non Passant (Dates Invalides)
    [Documentation]    Test avec des dates invalides
    [Tags]    carts    read    negative
    
    ${response}=    Get Carts By Date Range    invalid-start    invalid-end
    # L'API peut retourner une erreur ou des résultats vides
    Should Be True    ${response.status_code} in [200, 400, 404]

# ===== VALIDATION TESTS =====

Validate Cart Products Structure - Scénario Passant
    [Documentation]    Test de validation de la structure des produits dans le panier
    [Tags]    carts    validation    positive
    
    ${response}=    Get Cart By ID    ${VALID_CART_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response['products']}
    ${first_product}=    Set Variable    ${json_response['products'][0]}
    Should Contain    ${first_product}    productId
    Should Contain    ${first_product}    quantity

Validate Cart Date Format - Scénario Passant
    [Documentation]    Test de validation du format de date
    [Tags]    carts    validation    positive
    
    ${response}=    Get Cart By ID    ${VALID_CART_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response['date']}
    Should Contain    ${json_response['date']}    -

Validate Cart Quantities - Scénario Passant
    [Documentation]    Test de validation des quantités dans le panier
    [Tags]    carts    validation    positive
    
    ${response}=    Get Cart By ID    ${VALID_CART_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    FOR    ${product}    IN    @{json_response['products']}
        Should Be True    ${product['quantity']} > 0
        Should Be True    ${product['productId']} > 0
    END
