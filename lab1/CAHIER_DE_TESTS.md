# Cahier de Tests - API FakeStore MongoDB

## Contexte

Tests automatisés pour l'API FakeStore en vue de valider les opérations CRUD sur une base de données MongoDB simulée.

## Objectifs

- Valider toutes les opérations CRUD (Create, Read, Update, Delete)
- Tester les scénarios passants et non passants
- Assurer la qualité et la robustesse de l'API

## Entités Testées

### 1. Products (Produits)

**Structure:**

```json
{
  "id": 1,
  "title": "Fjallraven - Foldsack No. 1 Backpack",
  "price": 109.95,
  "description": "Your perfect pack...",
  "category": "men's clothing",
  "image": "https://fakestoreapi.com/img/image.jpg",
  "rating": {
    "rate": 3.9,
    "count": 120
  }
}
```

**Tests CREATE:**

- ✅ **Passant:** Création avec données valides
- ❌ **Non passant 1:** Données manquantes (titre, prix vides)
- ❌ **Non passant 2:** Prix négatif

**Tests READ:**

- ✅ **Passant:** Lecture d'un produit existant
- ❌ **Non passant 1:** ID inexistant (999999)
- ❌ **Non passant 2:** ID invalide (abc)

**Tests UPDATE:**

- ✅ **Passant:** Mise à jour avec données valides
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** Données invalides

**Tests DELETE:**

- ✅ **Passant:** Suppression d'un produit existant
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** ID invalide

### 2. Users (Utilisateurs)

**Structure:**

```json
{
  "id": 1,
  "email": "john@gmail.com",
  "username": "johnd",
  "password": "hashedpassword",
  "name": {
    "firstname": "John",
    "lastname": "Doe"
  },
  "address": {
    "city": "kilcoole",
    "street": "7835 new road",
    "zipcode": "12926-3874",
    "geolocation": {
      "lat": "-37.3159",
      "long": "81.1496"
    }
  },
  "phone": "1-570-236-7033"
}
```

**Tests CREATE:**

- ✅ **Passant:** Création avec données valides
- ❌ **Non passant 1:** Email invalide
- ❌ **Non passant 2:** Données manquantes

**Tests READ:**

- ✅ **Passant:** Lecture d'un utilisateur existant
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** ID invalide

**Tests UPDATE:**

- ✅ **Passant:** Mise à jour avec données valides
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** Email invalide

**Tests DELETE:**

- ✅ **Passant:** Suppression d'un utilisateur existant
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** ID invalide

### 3. Carts (Paniers)

**Structure:**

```json
{
  "id": 1,
  "userId": 1,
  "date": "2020-03-02T00:00:00.000Z",
  "products": [
    {
      "productId": 1,
      "quantity": 4
    },
    {
      "productId": 2,
      "quantity": 1
    }
  ]
}
```

**Tests CREATE:**

- ✅ **Passant:** Création avec données valides
- ❌ **Non passant 1:** UserID invalide (-1)
- ❌ **Non passant 2:** Format produits invalide

**Tests READ:**

- ✅ **Passant:** Lecture d'un panier existant
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** ID invalide

**Tests UPDATE:**

- ✅ **Passant:** Mise à jour avec données valides
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** Date invalide

**Tests DELETE:**

- ✅ **Passant:** Suppression d'un panier existant
- ❌ **Non passant 1:** ID inexistant
- ❌ **Non passant 2:** ID invalide

## Statistiques des Tests

| Entité    | CREATE | READ   | UPDATE | DELETE | Total  |
| --------- | ------ | ------ | ------ | ------ | ------ |
| Products  | 3      | 4      | 3      | 3      | 13     |
| Users     | 3      | 4      | 3      | 3      | 13     |
| Carts     | 3      | 4      | 3      | 3      | 13     |
| **TOTAL** | **9**  | **12** | **9**  | **9**  | **39** |

## Critères d'Acceptation

### Scénarios Passants

- Code de réponse HTTP 200
- Structure de réponse JSON valide
- Données cohérentes avec la requête
- Respect du schéma de données

### Scénarios Non Passants

- Codes d'erreur appropriés (400, 404, 500)
- Messages d'erreur explicites
- Gestion gracieuse des erreurs
- Validation des données d'entrée

## Environnement de Test

- **API:** https://fakestoreapi.com
- **Framework:** Robot Framework
- **Librairies:** RequestsLibrary, JSONLibrary
- **Python:** 3.13.3

## Exécution

```bash
# Tous les tests
robot testcases/

# Par entité
robot testcases/products_tests.robot
robot testcases/users_tests.robot
robot testcases/carts_tests.robot

# Par type de test
robot --include positive testcases/
robot --include negative testcases/
robot --include create testcases/
```

## Rapports

Les rapports de test sont générés automatiquement :

- `report.html` : Rapport détaillé
- `log.html` : Log d'exécution
- `output.xml` : Résultats au format XML
