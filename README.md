# IA SBC libros

<font size="4">Segunda práctica de la asignatura de IA en la FIB. </font>

<font size="4">Nota obtenida: 10.5 </font>

## Acerca de
Para este prototipo, hemos implementado un formato de diálogo en el que
realizamos preguntas al usuario acerca de sus características y preferencias
como lector. A continuación, utilizando las respuestas proporcionadas por el
usuario, filtramos entre nuestras novelas aquellas que mejor se ajusten a sus
preferencias.

Este prototipo inicial se divide en los siguientes componentes:
- funciones.clp: contiene todas las funciones necesarias.
- instancias.clp: incluye todas las instancias relevantes.
- ontologia.clp: define las diferentes clases de la ontología utilizada.
- reglas.clp: organiza todas las reglas en módulos.
- run.clp.bat: es el archivo batch que hay que cargar para ejecutar el prototipo.

El proceso comienza ejecutando el módulo de "RECOGER DE DATOS", donde
hacemos las siguientes preguntas al usuario:
- En formato de diálogo, preguntamos si el usuario tiene algún género
literario favorito. Si es así, solicitamos que los enumere separados por
espacios en una única línea.
- Luego, indagamos sobre si el usuario tiene algún autor preferido, en caso
afirmativo, pedimos el nombre del autor entre comillas.
- Finalmente, consultamos la edad del usuario, la cual debe ser un número entre
0 y 100. En función de la edad proporcionada, recomendamos novelas dirigidas al
público correspondiente.

A continuación, se realiza una abstracción de datos en su debido modulo. Eso
ocurre con la edad, que la abstraemos convirtiendola al atributo publico_dirigido.

Después de completar las preguntas y realizar las abstracciones necesarias,
iniciamos el proceso de filtrado a través del módulo "PROCESAR DATOS".
Este módulo se encarga de recomendar novelas que se ajusten a las preferencias
del usuario, mostrando un máximo de 3 novelas ordenadas por su valoración. En
caso de no encontrar novelas que cumplan con todas las preferencias, se
recomendarán aquellas que satisfazcan la mayoría de los requisitos.

Finalmente, en el módulo "MOSTRAR LIBROS", se imprimen las novelas recomendadas
al usuario.

Ejemplo de INPUT para cada opción:
- Cuando pregunte por género si hay favorito(se pueden poner varios): fantasia ciencia_ficcion narrativa
- Cuando pregunte por autor si hay favorito(entre comillas y solo 1): "Miguel de cervantes"
- Cuando pregunte por edad: 20

## Cómo iniciar el programa

1. Abrir el IDE de CLIPS.
2. Dentro del IDE, abrir el fichero ``run.clp.bat`` para ejecutar el programa.

Una vez ejecutado el programa, si se desea reiniciarlo:
1. Introducir ``(reset)`` para reiniciar el estado del programa.
2. Introducir ``(run)`` para ejecutar el programa de nuevo.

## Hecho por

Jordi Muñoz - [@jordimunozflorensa](https://github.com/jordimunozflorensa)

Jianing Xu - [@jianingxu1](https://github.com/jianingxu1)

Yiqi Zheng - [@yiqizhengshan](https://github.com/yiqizhengshan)

<br>

Link del proyecto: [https://github.com/yiqizhengshan/IA-SBC-libros](https://github.com/yiqizhengshan/IA-SBC-libros)

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

[Java-url]: https://dev.java/
[Java.com]: https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white