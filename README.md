# Hands-On-5
# Integrantes
- Angel Sebastian Garnica Carbajal
- Jair Ruvalcaba Prieto
# Descripción

Este proyecto implementa un analizador léxico, sintáctico y parcialmente semántico utilizando Flex y Bison. Su objetivo es procesar código de prueba en C (o código de ejemplo definido en input.c) y verificar la correcta estructura gramatical, identificando errores léxicos, sintácticos y algunos errores semánticos básicos.

El proyecto incluye:

- lexer.l: archivo con las reglas léxicas para reconocer tokens.
- parser.y: archivo con las reglas sintácticas y acciones semánticas.
- input.c: código de prueba para evaluar el funcionamiento del analizador.

# Requisitos

- Flex
- Bison
- GCC (para compilar el ejecutable generado)

# Uso
1. Generar el lexer y parser:
- flex lexer.l
- bison -d parser.y
- gcc lex.yy.c y.tab.c -o hands-on-5.exe

2. Ejecutar el analizador sobre un archivo de prueba:
- ./hands-on-5 < input.c

3. Observar la salida que incluye:

- Tokens reconocidos.
- Estructura sintáctica del código.
- Errores semánticos detectados.


