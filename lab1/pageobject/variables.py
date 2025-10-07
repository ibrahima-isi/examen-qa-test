#!/usr/bin/env python3
"""
Variables Python pour les tests Robot Framework
Contient les données de test et configurations
"""

import datetime

# Configuration API
BASE_URL = "https://fakestoreapi.com"
TIMEOUT = 30
CONTENT_TYPE = "application/json"

# IDs valides pour les tests
VALID_PRODUCT_ID = 1
VALID_USER_ID = 1  
VALID_CART_ID = 1
INVALID_ID = 999999

# Données de test pour Products
PRODUCT_TEST_DATA = {
    "valid": {
        "title": "Test Product",
        "price": 29.99,
        "description": "A test product for automation",
        "category": "electronics",
        "image": "https://example.com/test-product.jpg"
    },
    "invalid_empty": {
        "title": "",
        "price": "",
        "description": "",
        "category": "",
        "image": ""
    },
    "invalid_negative_price": {
        "title": "Invalid Product",
        "price": -50,
        "description": "Product with negative price",
        "category": "electronics",
        "image": "https://example.com/invalid.jpg"
    },
    "update": {
        "title": "Updated Test Product",
        "price": 49.99,
        "description": "Updated test product",
        "category": "men's clothing",
        "image": "https://example.com/updated-product.jpg"
    }
}

# Données de test pour Users
USER_TEST_DATA = {
    "valid": {
        "email": "test@example.com",
        "username": "testuser",
        "password": "testpass123",
        "name": {
            "firstname": "John",
            "lastname": "Doe"
        },
        "address": {
            "city": "TestCity",
            "street": "123 Test Street",
            "zipcode": "12345",
            "geolocation": {
                "lat": "0",
                "long": "0"
            }
        },
        "phone": "555-1234"
    },
    "invalid_email": {
        "email": "invalid-email-format",
        "username": "testuser",
        "password": "testpass",
        "name": {
            "firstname": "John",
            "lastname": "Doe"
        },
        "address": {
            "city": "TestCity", 
            "street": "123 Test Street",
            "zipcode": "12345",
            "geolocation": {
                "lat": "0",
                "long": "0"
            }
        },
        "phone": "555-1234"
    },
    "invalid_empty": {
        "email": "",
        "username": "",
        "password": "",
        "name": {
            "firstname": "",
            "lastname": ""
        },
        "address": {
            "city": "",
            "street": "",
            "zipcode": "",
            "geolocation": {
                "lat": "",
                "long": ""
            }
        },
        "phone": ""
    }
}

# Données de test pour Carts
CART_TEST_DATA = {
    "valid": {
        "userId": 1,
        "date": "2024-01-01",
        "products": [
            {"productId": 1, "quantity": 2},
            {"productId": 2, "quantity": 1}
        ]
    },
    "invalid_user": {
        "userId": -1,
        "date": "2024-01-01",
        "products": [
            {"productId": 1, "quantity": 2}
        ]
    },
    "invalid_products": {
        "userId": 1,
        "date": "2024-01-01",
        "products": "invalid_format"
    },
    "invalid_date": {
        "userId": 1,
        "date": "invalid-date-format",
        "products": [
            {"productId": 1, "quantity": 1}
        ]
    }
}

# Catégories valides de l'API
VALID_CATEGORIES = [
    "electronics",
    "jewelery", 
    "men's clothing",
    "women's clothing"
]

# Messages d'erreur attendus
ERROR_MESSAGES = {
    "not_found": "Product not found",
    "invalid_id": "Invalid ID format",
    "missing_data": "Missing required fields",
    "invalid_email": "Invalid email format"
}

# Configuration des tests de performance
PERFORMANCE_THRESHOLDS = {
    "max_response_time": 5000,  # millisecondes
    "max_memory_usage": 100     # MB
}

# Dates pour les tests
TEST_DATES = {
    "valid_start": "2019-01-01",
    "valid_end": "2020-12-31", 
    "invalid_start": "invalid-start",
    "invalid_end": "invalid-end",
    "current": datetime.datetime.now().strftime("%Y-%m-%d")
}

# Configuration des retry pour les tests
RETRY_CONFIG = {
    "max_attempts": 3,
    "delay_between_attempts": 1,
    "exponential_backoff": True
}
