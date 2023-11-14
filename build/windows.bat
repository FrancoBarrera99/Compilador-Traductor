@echo off

rem Carpeta donde se moverán los archivos intermedios
set INTERMEDIATE_FOLDER=..\intermediates

rem Carpeta de destino del ejecutable
set DESTINATION_FOLDER=..\

rem Crear la carpeta intermediates si no existe
if exist %INTERMEDIATE_FOLDER% (
    echo La carpeta intermediates ya existe. Eliminando y recreando...
    rmdir /s /q %INTERMEDIATE_FOLDER%
)
mkdir %INTERMEDIATE_FOLDER%

rem Compilación de flex
echo Compilacion de flex...
flex ..\traductor.l

rem Compilación de bison
echo Compilacion de bison...
bison -d ..\traductor.y

rem Mover archivos intermedios a la carpeta intermediates
move lex.yy.c %INTERMEDIATE_FOLDER% >nul
move traductor.tab.c %INTERMEDIATE_FOLDER% >nul
move traductor.tab.h %INTERMEDIATE_FOLDER% >nul

rem Compilación con cl (Microsoft C/C++ Compiler)
cl /Fe%DESTINATION_FOLDER%\%EXECUTABLE_NAME% %INTERMEDIATE_FOLDER%\lex.yy.c %INTERMEDIATE_FOLDER%\traductor.tab.c

echo Compilacion completada.

rem Pausa antes de cerrar la consola
pause
