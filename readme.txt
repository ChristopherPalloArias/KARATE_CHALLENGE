===========================================================
EJERCICIO 2: Automatización API Lifecycle (Karate DSL)
Instrucciones de Ejecución Paso a Paso
===========================================================

NOTA IMPORTANTE: 
Toda la metodología, arquitectura de pruebas y justificaciones técnicas ("ASDD")
se encuentran documentadas exhaustivamente en el archivo "README.md"
ubicado en la raíz de este repositorio, donde se puede visualizar con gráficas. 
A continuación, se detalla lo estrictamente solicitado para la ejecución.

1. TECNOLOGÍAS Y VERSIONES A USAR
-----------------------------------------------------------
- Framework Automatización: Karate DSL (Versión 1.5.0 o superior)
- Lenguaje / Plataforma: Java JDK (Versión 17 LTS requerida)
- Gestor de Dependencias: Apache Maven (v3.8 o superior)
- Trazabilidad y Aserción E2E: JUnit 5 (Orquestador embebido)

2. INSTRUCCIONES DE EJECUCIÓN PASO A PASO (CÓMO REPLICAR EL TEST)
-----------------------------------------------------------
Paso 1: Abra una terminal o línea de comandos.

Paso 2: Clonar el proyecto público y posicionarse en la carpeta raíz.
> git clone https://github.com/ChristopherPalloArias/KARATE_CHALLENGE.git
> cd KARATE_CHALLENGE

Paso 3: Verifique en su terminal que Java 17 y Maven estén configurados en sus variables de entorno.
> java -version
> mvn -v

Paso 4: Descargue las dependencias del pom.xml y limpie previas compilaciones.
> mvn clean

Paso 5: Ejecutar la clase Runner de las pruebas del ciclo E2E.
El proyecto está configurado para auto-inyectar la baseUrl a "https://petstore.swagger.io/v2" mediante karate-config.js y lanzar la suite completa definida en "src/test/java/api/petstore/petstore-exercise-2.feature":

> mvn test -Dtest=ChallengeTest

(Opcional) Si desea forzar o sobreescribir la URL del entorno de la API pública manualmente, ejecute:
> mvn test -Dtest=ChallengeTest -DbaseUrl="https://petstore.swagger.io/v2"

3. EVIDENCIAS Y REPORTES OFICIALES (HTML REPORT)
-----------------------------------------------------------
A diferencia de otras metodologías, Karate DSL no exige dependencias de terceros para reportabilidad. Genera nativamente su "Living Documentation" llena de trazas JSON de Request/Response.

- Ubique en su sistema la carpeta generada: /target/karate-reports/
- Dé doble clic sobre el archivo maestro: karate-summary.html

Ahí se visualizarán exitosamente las 4 pruebas exigidas por el Escenario:
1. Añadir mascota
2. Consultar por ID
3. Actualizar a "sold"
4. Consultar por status
