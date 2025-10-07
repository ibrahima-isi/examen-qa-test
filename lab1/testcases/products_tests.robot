*** Settings ***
Documentation    Tests CRUD pour l'entité Products de l'API FakeStore
Resource         ../resources/api_keywords.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***

# ===== CREATE TESTS =====

Create Product - Scénario Passant
    [Documentation]    Test de création d'un produit avec des données valides
    [Tags]    products    create    positive
    
    ${product_data}=    Create Dictionary
    ...    title=New Test Product
    ...    price=29.99
    ...    description=A great test product
    ...    category=electronics
    ...    image=https://example.com/image.jpg
    
    ${response}=    Create Product    ${product_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id
    Should Be Equal    ${json_response['title']}    New Test Product
    Should Be Equal As Numbers    ${json_response['price']}    29.99

Create Product - Scénario Non Passant (Données Manquantes)
    [Documentation]    Test de création d'un produit avec des données manquantes
    [Tags]    products    create    negative
    
    ${product_data}=    Create Dictionary
    ...    title=${EMPTY}
    ...    price=${EMPTY}
    
    ${response}=    Create Product    ${product_data}
    # L'API FakeStore retourne toujours 200, mais nous testons la logique
    Should Be Equal As Numbers    ${response.status_code}    200

Create Product - Scénario Non Passant (Prix Négatif)
    [Documentation]    Test de création d'un produit avec un prix négatif
    [Tags]    products    create    negative
    
    ${product_data}=    Create Dictionary
    ...    title=Invalid Product
    ...    price=-50
    ...    description=Product with negative price
    ...    category=electronics
    
    ${response}=    Create Product    ${product_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    # Vérification que le prix négatif est préservé (comportement de l'API)
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Numbers    ${json_response['price']}    -50

# ===== READ TESTS =====

Read Product - Scénario Passant
    [Documentation]    Test de lecture d'un produit existant
    [Tags]    products    read    positive
    
    ${response}=    Get Product By ID    ${VALID_PRODUCT_ID}
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Verify Product Structure    ${json_response}
    Should Be Equal As Numbers    ${json_response['id']}    ${VALID_PRODUCT_ID}

Read Product - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de lecture d'un produit avec un ID inexistant
    [Tags]    products    read    negative
    
    ${response}=    Get Product By ID    ${INVALID_ID}
    Should Be Equal As Numbers    ${response.status_code}    404

Read Product - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de lecture d'un produit avec un ID invalide
    [Tags]    products    read    negative
    
    ${response}=    Get Product By ID    abc
    Should Be Equal As Numbers    ${response.status_code}    404

Read All Products - Scénario Passant
    [Documentation]    Test de lecture de tous les produits
    [Tags]    products    read    positive
    
    ${response}=    Get All Products
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    ${first_product}=    Set Variable    ${json_response[0]}
    Verify Product Structure    ${first_product}

# ===== UPDATE TESTS =====

Update Product - Scénario Passant
    [Documentation]    Test de mise à jour d'un produit existant
    [Tags]    products    update    positive
    
    ${update_data}=    Create Dictionary
    ...    title=Updated Test Product
    ...    price=199.99
    ...    description=Updated description
    ...    category=men's clothing
    
    ${response}=    Update Product    ${VALID_PRODUCT_ID}    ${update_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal    ${json_response['title']}    Updated Test Product
    Should Be Equal As Numbers    ${json_response['price']}    199.99

Update Product - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de mise à jour d'un produit inexistant
    [Tags]    products    update    negative
    
    ${update_data}=    Create Dictionary
    ...    title=Should Not Update
    ...    price=99.99
    
    ${response}=    Update Product    ${INVALID_ID}    ${update_data}
    # L'API FakeStore simule la mise à jour même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Equal As Numbers    ${json_response['id']}    ${INVALID_ID}

Update Product - Scénario Non Passant (Données Invalides)
    [Documentation]    Test de mise à jour avec des données invalides
    [Tags]    products    update    negative
    
    ${update_data}=    Create Dictionary
    ...    title=${EMPTY}
    ...    price=invalid_price
    
    ${response}=    Update Product    ${VALID_PRODUCT_ID}    ${update_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    # L'API accepte les données invalides, nous vérifions juste la réponse
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id

# ===== DELETE TESTS =====

Delete Product - Scénario Passant
    [Documentation]    Test de suppression d'un produit existant
    [Tags]    products    delete    positive
    
    ${response}=    Delete Product    ${VALID_PRODUCT_ID}
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Contain    ${json_response}    id

Delete Product - Scénario Non Passant (ID Inexistant)
    [Documentation]    Test de suppression d'un produit inexistant
    [Tags]    products    delete    negative
    
    ${response}=    Delete Product    ${INVALID_ID}
    # L'API FakeStore simule la suppression même pour des IDs inexistants
    Should Be Equal As Numbers    ${response.status_code}    200

Delete Product - Scénario Non Passant (ID Invalide)
    [Documentation]    Test de suppression avec un ID invalide
    [Tags]    products    delete    negative
    
    ${response}=    Delete Product    invalid_id
    Should Be Equal As Numbers    ${response.status_code}    200

# ===== ADDITIONAL TESTS =====

Get Products By Category - Scénario Passant
    [Documentation]    Test de récupération des produits par catégorie
    [Tags]    products    read    positive
    
    ${response}=    Get Products By Category    electronics
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    FOR    ${product}    IN    @{json_response}
        Should Be Equal    ${product['category']}    electronics
    END

Get Products By Category - Scénario Non Passant
    [Documentation]    Test avec une catégorie inexistante
    [Tags]    products    read    negative
    
    ${response}=    Get Products By Category    nonexistent_category
    Should Be Equal As Numbers    ${response.status_code}    200
    
    ${json_response}=    Set Variable    ${response.json()}
    Should Be Empty    ${json_response}

Get All Categories - Scénario Passant
    [Documentation]    Test de récupération de toutes les catégories
    [Tags]    products    read    positive
    
    ${response}=    Get All Categories
    ${json_response}=    Should Be Valid JSON Response    ${response}
    
    Should Not Be Empty    ${json_response}
    Should Contain    ${json_response}    electronics
    Should Contain    ${json_response}    jewelery
