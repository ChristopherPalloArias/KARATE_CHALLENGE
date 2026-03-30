============ INSTRUCCIONES DE EJECUCION DE LA SUITE KARATE (EJERCICIO 2) ============

REQUISITOS PREVIOS:
1. Tener instalado Java 17 en su sistema local (validar con: java -version)
2. Tener instalado Maven 3.8 o superior (validar con: mvn -v)
3. Conectividad estable a Internet, dado que las pruebas atacan directamente el entorno publico: https://petstore.swagger.io/

PASO A PASO:
1. Clonar el repositorio publico o extraer los archivos del proyecto en un directorio local:
   > git clone https://github.com/ChristopherPalloArias/KARATE_CHALLENGE.git
   > cd KARATE_CHALLENGE

2. Limpiar compilaciones anteriores y descargar las dependencias del archivo pom.xml:
   > mvn clean

3. Ejecutar la clase Runner de las pruebas del ciclo E2E (El proyecto esta seteado para auto-configurar el baseUrl con https://petstore.swagger.io/v2 y lanzar la suite definida en src/test/java/api/petstore/petstore-exercise-2.feature):
   > mvn test -Dtest=ChallengeTest

   Nota opcional: Tambien puedes definir o sobreescribir explicitamente el ambiente enviando -DbaseUrl="https://petstore.swagger.io/v2".

4. Validar el resultado devuelto en la consola por surefire (BUILD SUCCESS, Tests run: 1, Failures: 0).

5. Abrir la Evidencia de Trazabilidad y el HTML Report generado automaticamente por Karate:
   - Dirigete dentro de tu sistema al directorio:
     /KARATE_CHALLENGE/target/karate-reports/
   - Abre con tu explorador de internet favorito el archivo maestro:
     karate-summary.html
   - En este reporte encontraras la minuciosa resolucion, documentacion del envio de variables (Request Body JSON), recepcion y match de aserciones.

FIN DE LA EJECUCION.
