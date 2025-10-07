@echo off
REM Script pour exécuter tous les tests Robot Framework du Lab 1
REM Auteur: QA Team - Looma Startup

echo ================================================
echo        Tests API FakeStore - Lab 1
echo ================================================
echo.

REM Vérification de l'environnement Python
echo Vérification de l'environnement Python...
if not exist ".venv\Scripts\python.exe" (
    echo ERREUR: Environnement virtuel Python non trouvé!
    echo Veuillez d'abord créer l'environnement virtuel avec:
    echo python -m venv .venv
    echo .venv\Scripts\activate
    echo pip install -r requirements.txt
    pause
    exit /b 1
)

REM Activation de l'environnement virtuel
echo Activation de l'environnement virtuel...
call .venv\Scripts\activate.bat

REM Création du dossier de rapports
if not exist "lab1\reports" mkdir lab1\reports

echo.
echo Démarrage des tests...
echo.

REM Exécution des tests avec génération des rapports
cd lab1

REM Test 1: Tests Products
echo [1/4] Exécution des tests Products...
robot --outputdir reports\products --name "Tests Products" --variable SUITE_NAME:"Products Tests" testcases\products_tests.robot

REM Test 2: Tests Users  
echo [2/4] Exécution des tests Users...
robot --outputdir reports\users --name "Tests Users" --variable SUITE_NAME:"Users Tests" testcases\users_tests.robot

REM Test 3: Tests Carts
echo [3/4] Exécution des tests Carts...
robot --outputdir reports\carts --name "Tests Carts" --variable SUITE_NAME:"Carts Tests" testcases\carts_tests.robot

REM Test 4: Tous les tests ensemble
echo [4/4] Exécution de la suite complète...
robot --outputdir reports\all_tests --name "Suite Complète FakeStore API" --reporttitle "Rapport Complet - Tests API FakeStore" --logtitle "Log Complet - Tests API FakeStore" testcases\

echo.
echo ================================================
echo           Tests terminés avec succès!
echo ================================================
echo.
echo Rapports générés dans:
echo - lab1\reports\products\
echo - lab1\reports\users\
echo - lab1\reports\carts\  
echo - lab1\reports\all_tests\
echo.
echo Ouvrir le rapport principal:
echo lab1\reports\all_tests\report.html
echo.

cd ..

REM Déactivation de l'environnement virtuel
deactivate

pause
