@echo off

rem Obtener la ubicación anterior del script .bat
set SCRIPT_DIR=%~dp0
for %%I in ("%SCRIPT_DIR%..") do set "PARENT_DIR=%%~fI"
echo "Setting parent: %PARENT_DIR%"

rem Carpeta donde se moverán los archivos intermedios
set INTERMEDIATE_DIR=%PARENT_DIR%\intermediates
echo "Setting parent: %INTERMEDIATE_DIR%"

rem Carpeta de destino del ejecutable
set DESTINATION_DIR=%PARENT_DIR%\bin

rem Nombre del ejecutable
set EXECUTABLE_NAME=traductor

rem Crear la carpeta intermediates si no existe
if exist %INTERMEDIATE_DIR% (
    echo La carpeta intermediates ya existe. Eliminando y recreando...
    rmdir /s /q %INTERMEDIATE_DIR%
)
mkdir %INTERMEDIATE_DIR%

rem Compilación de flex
echo Compilacion de flex...
flex %PARENT_DIR%\traductor.l

rem Compilación de bison
echo Compilacion de bison...
bison -d %PARENT_DIR%\traductor.y

rem Mover archivos intermedios a la carpeta intermediates
move %PARENT_DIR%\lex.yy.c %INTERMEDIATE_DIR%\ >nul
move %PARENT_DIR%\traductor.tab.c %INTERMEDIATE_DIR%\ >nul
move %PARENT_DIR%\traductor.tab.h %INTERMEDIATE_DIR%\ >nul

rem Cambia al directorio de intermediates antes de la compilación
cd %INTERMEDIATE_DIR%

rem Crear la carpeta bin si no existe
if exist %DESTINATION_DIR% (
    echo La carpeta bin ya existe. Eliminando y recreando...
    rmdir /s /q %DESTINATION_DIR%
)
mkdir %DESTINATION_DIR%

rem Compilación con cl (Microsoft C/C++ Compiler)
cl /Fe%DESTINATION_DIR%\%EXECUTABLE_NAME% lex.yy.c traductor.tab.c

rem Vuelve al directorio original
cd %PARENT_DIR%\build

echo Compilacion completada.

rem Crear el archivo .bat adicional para los tests
echo @echo off > %DESTINATION_DIR%\run_test1.bat
echo %EXECUTABLE_NAME% < %PARENT_DIR%\tests\test1.txt >> %DESTINATION_DIR%\run_test1.bat

echo Se generaron los archivos de prueba.

rem Pausa antes de cerrar la consola
pause
