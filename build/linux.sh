#!/bin/bash

# Carpeta donde se moverán los archivos intermedios
INTERMEDIATE_FOLDER=../intermediates

# Carpeta de destino del ejecutable
DESTINATION_FOLDER=../bin

# Nombre del ejecutable
EXECUTABLE_NAME=traductor

# Carpeta de pruebas
TESTS_FOLDER=../tests

# Compilación de flex
echo "Compilacion de flex..."
flex ../traductor.l

# Compilación de bison
echo "Compilacion de bison..."
bison -d ../traductor.y

# Crear la carpeta intermediates si no existe
mkdir -p $INTERMEDIATE_FOLDER

# Mover archivos intermedios a la carpeta intermediates
mv lex.yy.c $INTERMEDIATE_FOLDER/
mv traductor.tab.c $INTERMEDIATE_FOLDER/
mv traductor.tab.h $INTERMEDIATE_FOLDER/

# Compilación con gcc
gcc -Wall -o $DESTINATION_FOLDER/$EXECUTABLE_NAME $INTERMEDIATE_FOLDER/lex.yy.c $INTERMEDIATE_FOLDER/traductor.tab.c

echo "Compilación completada."
