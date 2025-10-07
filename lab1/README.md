# Lab 1 : Tests sur une base de données MongoDB

## Objectif
Automatiser les tests sur une base MongoDB hébergée sur MongoDB Atlas en utilisant l'API FakeStore comme référence.

## Description
Ce lab comprend des tests automatisés avec Robot Framework pour valider les opérations CRUD (Create, Read, Update, Delete) sur les entités suivantes :
- **Products** : Gestion des produits
- **Users** : Gestion des utilisateurs  
- **Carts** : Gestion des paniers

## Structure des tests
Pour chaque entité, nous avons implémenté :
- **1 scénario passant** par opération CRUD
- **2 scénarios non passants** par opération CRUD

## API utilisée
URL de base : https://fakestoreapi.com

## Documentation
- [Documentation de l'API FakeStore](https://fakestoreapi.com/docs)
- Schéma de la base : voir `SCHEMA.md`

## Exécution des tests
```bash
# Exécuter tous les tests
robot testcases/

# Exécuter les tests d'une entité spécifique
robot testcases/products_tests.robot
robot testcases/users_tests.robot  
robot testcases/carts_tests.robot
```

## Structure du projet
```
lab1/
├── README.md              # Ce fichier
├── SCHEMA.md             # Schéma de la base de données
├── resources/            # Ressources partagées
│   ├── common.robot      # Mots-clés communs
│   └── api_keywords.robot # Mots-clés pour les API
├── pageobject/           # (Non utilisé pour les tests API)
└── testcases/           # Cas de tests
    ├── products_tests.robot
    ├── users_tests.robot
    └── carts_tests.robot
```
