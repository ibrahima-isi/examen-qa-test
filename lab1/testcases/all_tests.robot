*** Settings ***
Documentation    Suite principale pour tous les tests de l'API FakeStore
...              Cette suite exécute tous les tests CRUD pour Products, Users et Carts
Resource         ../resources/common.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite

*** Test Cases ***
Run All API Tests
    [Documentation]    Exécute tous les tests des différentes entités
    [Tags]    integration    full_suite
    
    Log    Début de l'exécution de la suite complète de tests
    
    # Cette suite importe et exécute automatiquement tous les tests
    # des fichiers dans le répertoire testcases/
    Log    Tests Products, Users et Carts en cours d'exécution
    
    Log    Suite complète terminée
