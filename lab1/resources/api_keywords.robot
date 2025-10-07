*** Settings ***
Documentation    Mots-clés spécifiques pour les opérations API FakeStore
Resource         common.robot

*** Keywords ***
# ===== PRODUCT KEYWORDS =====

Get All Products
    [Documentation]    Récupère tous les produits
    ${response}=    GET On Session    fakestore    /products
    RETURN    ${response}

Get Product By ID
    [Arguments]    ${product_id}
    [Documentation]    Récupère un produit par son ID
    ${response}=    GET On Session    fakestore    /products/${product_id}    expected_status=any
    RETURN    ${response}

Create Product
    [Arguments]    ${product_data}
    [Documentation]    Crée un nouveau produit
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${response}=    POST On Session    fakestore    /products    json=${product_data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Update Product
    [Arguments]    ${product_id}    ${product_data}
    [Documentation]    Met à jour un produit existant
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${response}=    PUT On Session    fakestore    /products/${product_id}    json=${product_data}    headers=${headers}    expected_status=any
    RETURN   ${response}

Delete Product
    [Arguments]    ${product_id}
    [Documentation]    Supprime un produit
    ${response}=    DELETE On Session    fakestore    /products/${product_id}    expected_status=any
    RETURN    ${response}

Get Products By Category
    [Arguments]    ${category}
    [Documentation]    Récupère les produits d'une catégorie
    ${response}=    GET On Session    fakestore    /products/category/${category}    expected_status=any
    RETURN    ${response}

Get All Categories
    [Documentation]    Récupère toutes les catégories
    ${response}=    GET On Session    fakestore    /products/categories
    RETURN    ${response}

# ===== USER KEYWORDS =====

Get All Users
    [Documentation]    Récupère tous les utilisateurs
    ${response}=    GET On Session    fakestore    /users
    RETURN    ${response}

Get User By ID
    [Arguments]    ${user_id}
    [Documentation]    Récupère un utilisateur par son ID
    ${response}=    GET On Session    fakestore    /users/${user_id}    expected_status=any
    RETURN   ${response}

Create User
    [Arguments]    ${user_data}
    [Documentation]    Crée un nouvel utilisateur
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${user_payload}=    Create User Payload    ${user_data}
    ${response}=    POST On Session    fakestore    /users    json=${user_payload}    headers=${headers}    expected_status=any
    RETURN    ${response}

Update User
    [Arguments]    ${user_id}    ${user_data}
    [Documentation]    Met à jour un utilisateur existant
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${user_payload}=    Create User Payload    ${user_data}
    ${response}=    PUT On Session    fakestore    /users/${user_id}    json=${user_payload}    headers=${headers}    expected_status=any
    RETURN    ${response}

Delete User
    [Arguments]    ${user_id}
    [Documentation]    Supprime un utilisateur
    ${response}=    DELETE On Session    fakestore    /users/${user_id}    expected_status=any
    RETURN    ${response}

Create User Payload
    [Arguments]    ${user_data}
    [Documentation]    Crée le payload complet pour l'utilisateur
    ${payload}=    Create Dictionary
    ...    email=${user_data.email}
    ...    username=${user_data.username}
    ...    password=${user_data.password}
    ...    name={"firstname": "${user_data.firstname}", "lastname": "${user_data.lastname}"}
    ...    address={"city": "${user_data.city}", "street": "${user_data.street}", "zipcode": "${user_data.zipcode}", "geolocation": {"lat": "0", "long": "0"}}
    ...    phone=${user_data.phone}
    RETURN    ${payload}

# ===== CART KEYWORDS =====

Get All Carts
    [Documentation]    Récupère tous les paniers
    ${response}=    GET On Session    fakestore    /carts
    RETURN   ${response}

Get Cart By ID
    [Arguments]    ${cart_id}
    [Documentation]    Récupère un panier par son ID
    ${response}=    GET On Session    fakestore    /carts/${cart_id}    expected_status=any
    RETURN    ${response}

Create Cart
    [Arguments]    ${cart_data}
    [Documentation]    Crée un nouveau panier
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${response}=    POST On Session    fakestore    /carts    json=${cart_data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Update Cart
    [Arguments]    ${cart_id}    ${cart_data}
    [Documentation]    Met à jour un panier existant
    ${headers}=    Create Dictionary    Content-Type=${CONTENT_TYPE}
    ${response}=    PUT On Session    fakestore    /carts/${cart_id}    json=${cart_data}    headers=${headers}    expected_status=any
    RETURN    ${response}

Delete Cart
    [Arguments]    ${cart_id}
    [Documentation]    Supprime un panier
    ${response}=    DELETE On Session    fakestore    /carts/${cart_id}    expected_status=any
    RETURN    ${response}

Get Carts By User
    [Arguments]    ${user_id}
    [Documentation]    Récupère les paniers d'un utilisateur
    ${response}=    GET On Session    fakestore    /carts/user/${user_id}    expected_status=any
    RETURN    ${response}

Get Carts By Date Range
    [Arguments]    ${start_date}    ${end_date}
    [Documentation]    Récupère les paniers dans une plage de dates
    ${response}=    GET On Session    fakestore    /carts?startdate=${start_date}&enddate=${end_date}    expected_status=any
    RETURN    ${response}
