===========================================================
EJERCICIO 2: Automatización API Lifecycle (Karate DSL)
===========================================================

1. TECNOLOGÍAS Y VERSIONES A USAR
-----------------------------------------------------------
- Framework Automatización: Karate DSL (v1.5.0)
- Lenguaje / Plataforma: Java JDK (Versión 17 LTS requerida)
- Gestor de Dependencias: Apache Maven (v3.8 o superior)
- Trazabilidad y Aserción E2E: JUnit 5 (Orquestador embebido)

2. INSTRUCCIONES DE EJECUCIÓN PASO A PASO
-----------------------------------------------------------
Paso A: Abra una terminal o línea de comandos.

Paso B: Clonar el proyecto y posicionarse en la carpeta raíz.
Comando a ejecutar: cd /ruta/al/proyecto/KARATE_CHALLENGE

Paso C: Verifique en su terminal que Java y Maven estén configurados.
Comandos útiles: java -version / mvn -v

Paso D: Limpie compilaciones previas y ejecute la suite de pruebas completa:
Comando E2E: mvn clean test -Dtest=ChallengeTest

(Nota: El framework autoconfigura internamente la URL a https://petstore.swagger.io/v2 en su ambiente nativo).

3. EVIDENCIAS Y REPORTES OFICIALES (HTML REPORT)
-----------------------------------------------------------
A diferencia de otras metodologías, Karate DSL no exige dependencias pesadas de reportabilidad. Genera nativamente en una fracción de segundo su "Living Documentation" llena de trazas JSON (Request/Response).

- Ubique la carpeta generada: /target/karate-reports
- Dé doble clic sobre el archivo principal: karate-summary.html

Si inspecciona este reporte, confirmará que las 4 transacciones exigidas (Crear, Recuperar ID, Actualizar "sold" y Recuperar por Status) se empalmaron exitosamente a nivel idempotencial en un solo flujo verde impecable.
