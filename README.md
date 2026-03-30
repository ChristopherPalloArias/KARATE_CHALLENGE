<div align="center">
  
# 🐾 PETSTORE_API_LIFECYCLE

### Reto Técnico: Automatización API con Karate

**Autor:** Christopher Ismael Pallo Arias  
**Correo:** christopher.pallo@sofka.com.co  
**Celular:** 0995312828  
**Proyecto:** Validación del ciclo de vida completo de una mascota en PetStore usando Karate  
**Objetivo:** Automatizar el flujo solicitado del reto sobre la API pública `PetStore`

<br />

### 🛠️ Technology Stack

**Automation Framework**
<br />
<img src="https://img.shields.io/badge/Karate%20DSL-1.5.0-black?style=for-the-badge" alt="Karate DSL" />
<img src="https://img.shields.io/badge/JUnit-5-25A162?style=for-the-badge" alt="JUnit 5" />
<br />
<a href="https://skillicons.dev">
  <img src="https://skillicons.dev/icons?i=java,maven,github" alt="Automation Stack" />
</a>


</div>

---

## 📌 Panel de Evaluación y Entregables Solicitados

> ⚠️ **ATENCIÓN EVALUADOR:** Todos los insumos obligatorios exigidos en el Ejercicio 2 de la automatización API de PetStore fueron resueltos, documentados y pueden ser auditados de forma inmediata:

- 📄 **Instrucciones de Ejecución Paso a Paso:** [`readme.txt`](./readme.txt) 
- 🧠 **Hallazgos y Conclusiones QA:** [`conclusiones.txt`](./conclusiones.txt) 
- 📊 **Evidencia de Ejecución (Karate HTML Report):** 👉 **[Visualizar Documentación de Pruebas y Requests E2E en GitHub Pages](https://ChristopherPalloArias.github.io/KARATE_CHALLENGE/)**
- 🚀 **Script Principal Feature (Flujo Completo E2E):** [`src/test/java/api/petstore/petstore-exercise-2.feature`](./src/test/java/api/petstore/petstore-exercise-2.feature)

---

## 📋 Tabla de Contenidos
1. [Contexto del Reto](#-contexto-del-reto)
2. [Entorno y Prerrequisitos (Compatibilidad)](#️-entorno-y-prerrequisitos-compatibilidad)
3. [ASDD — Agent Spec-Driven Development](#asdd--agent-spec-driven-development)
4. [Escenario E2E: Ciclo de Vida de la Mascota](#-escenario-e2e-ciclo-de-vida-de-la-mascota)
5. [Arquitectura y Estructura del Framework](#️-arquitectura-y-estructura-del-framework)
6. [Instrucciones de Clonado y Setup](#-instrucciones-de-clonado-y-setup-entorno-local)
7. [Ejecución y Generación de Reportes](#️-ejecución-y-generación-de-reportes)
8. [Retos y Conclusiones (API)](#-consideraciones-técnicas-y-retos-resueltos-api)

---

## 🎯 Contexto del Reto

Este repositorio corresponde al **Ejercicio 2** del reto de Automatización API. El objetivo es certificar el dominio técnico sobre la implementación de pruebas automatizadas contra APIs REST utilizando el framework **Karate DSL**. 
La prueba valida el ciclo de vida completo de una entidad (*Pet*) en un entorno público y compartido, demostrando habilidades avanzadas en la inyección de datos dinámicos, encadenamiento de peticiones (chaining), validaciones estrictas y manejo seguro de estados para evitar colisiones de datos.

> **Nota para los Evaluadores:** Los entregables solicitados formalmente por el ejercicio (`readme.txt` de instrucciones paso a paso, y `conclusiones.txt` con los hallazgos) se encuentran explícitamente adjuntos en la raíz del repositorio, adicional a este documento central exhaustivo.

---

## 🛠️ Entorno y Prerrequisitos (Compatibilidad)

> ⚠️ **El uso de estas versiones es fundamental para compilar y ejecutar la suite correctamente.**

| Componente | Versión Requerida | Verificación |
|------------|------------------|--------------|
| **Java / JDK** | `17` (LTS) | `java -version` → `openjdk 17.x.x` |
| **Maven** | `3.8+` | `mvn -v` → `Apache Maven 3.x` |
| **Karate DSL** | `1.5.0` | Definido en `pom.xml` |
| **JUnit** | `5.10.0` | Definido en `pom.xml` |

---

# ASDD — Agent Spec-Driven Development

**ASDD** (Agent Spec Software Development) es un framework de desarrollo asistido por IA que organiza el trabajo de software en diversas fases orquestadas por agentes especializados.

```text
Requerimiento → Spec API → QA → Implementación → Doc (opcional)
```

> Esta guía cubre el uso con **GitHub Copilot Chat** en VS Code.

## Requisitos

| Requisito | Detalle |
|---|---|
| VS Code | Cualquier versión reciente |
| GitHub Copilot Chat | Extensión instalada y activa |
| Setting habilitado | `github.copilot.chat.codeGeneration.useInstructionFiles: true` |

El archivo `.vscode/settings.json` ya configura el auto-descubrimiento de agentes, skills e instructions. Si no existe, créalo con las rutas correspondientes a `.github/`.

## Onboarding — nuevo proyecto

Al copiar `.github/` y `docs/` a un proyecto nuevo, completa estos archivos **en orden** antes de usar cualquier agente:

| # | Archivo | Qué escribir |
|---|---------|-------------|
| 1 | `README.md` (raíz del proyecto) | Stack de automatización Karate y diseño API |
| 2 | `copilot-instructions.md` | Términos canónicos del negocio (glosario) |
| 3 | `copilot-instructions.md` | Criterios DoR y DoD del equipo |

Una vez completados, los agentes tienen todo el contexto para operar de forma autónoma.

**No modificar**: `agents/`, `skills/`, `instructions/`, `.github/docs/lineamientos/`, `copilot-instructions.md`, `AGENTS.md`

## El flujo ASDD paso a paso

### Paso 1 — Spec (obligatorio, siempre primero)

Genera la especificación técnica antes de escribir código:

```
@Spec Generator genera la spec para: [tu requerimiento]
```
```
/generate-spec <nombre-feature>
```

El agente valida el requerimiento y genera `specs/<feature>.spec.md` con estado `DRAFT`.
Revisa y aprueba la spec (cambia a `APPROVED`) antes de continuar.

### Paso 2 — QA

Con la spec `APPROVED`, ejecuta la estrategia QA:

```
@QA Agent ejecuta QA para specs/<feature>.spec.md
```

El agente genera: casos Gherkin y matriz de riesgos.

### Paso 3 — Implementation (Karate)

With the QA strategy ready from the previous phase:

```text
@Implement Karate Assets Agent builds schemas and payloads layer for specs/<feature>.spec.md
@Implement Karate Feature Agent assembles the final .feature for specs/<feature>.spec.md
```

Both agents enforce structured automation implementation for Karate.

### Paso 4 — Documentación *(opcional)*

Al cerrar el feature:

```
@Documentation Agent documenta el feature specs/<feature>.spec.md
```

### Flujo completo con Orchestrator

```
@Orchestrator ejecuta el flujo completo para: [tu requerimiento]
```
```
/asdd-orchestrate <nombre-feature>
```

## Agentes disponibles (`@name` in Copilot Chat)

| Agent | Phase | When to use |
|---|---|---|
| `@Orchestrator` | Entry point | Coordinate the full flow (`/asdd-orchestrate status` to see status) |
| `@Spec Generator` | Phase 1 | Validate a requirement and generate its technical spec |
| `@QA Agent` | Phase 2 | Gherkin, risks, and BDD analysis |
| `@Implement Karate Assets Agent`| Phase 3 | Generate reusable schemas and payloads for Karate |
| `@Implement Karate Feature Agent`| Phase 3 | Generate .feature file by assembling previous assets |
| `@Documentation Agent` | Phase 4 | README, API docs, and ADRs |

## Skills disponibles (`/command` in Copilot Chat)

| Command | Agent | What it does |
|---|---|---|
| `/asdd-orchestrate` | Orchestrator | Orchestrates the full flow or shows current status |
| `/generate-spec` | Spec Generator | Generates technical spec with INVEST/IEEE 830 validation |
| `/gherkin-case-generator` | QA Agent | Critical flows + Given-When-Then cases + test data |
| `/risk-identifier` | QA Agent | ASD risk matrix (High/Medium/Low) |
| `/performance-analyzer` | QA Agent | Performance test planning |
| `/generate-project-readme` | Documentation Agent | Generates or updates the main Karate framework README.md |
| `/implement-karate-assets` | Implement Karate Assets Agent | Generates reusable Karate assets (schemas and payloads) |
| `/implement-karate-feature` | Implement Karate Feature Agent | Generates the complete Karate .feature file |

## Prompts disponibles (`/name` in Copilot Chat)

Alternativa rápida a invocar agentes directamente:

| Comando | Cuándo usarlo |
|---|---|
| `/generate-spec` | Crear una nueva spec desde un requerimiento |
| `/qa-task` | Ejecutar el flujo QA (Gherkin + riesgos) |
| `/doc-task` | Generar documentación técnica del feature |
| `/full-flow` | Orquestar todas las fases de principio a fin |

## Instructions automáticas (sin intervención manual)

Inyectadas automáticamente por Copilot cuando el archivo activo coincide:

| Archivo activo | Instructions aplicadas |
|---|---|
| `**/*.feature` | `instructions/tests.instructions.md` |
| `src/test/java/**/*.feature` | `instructions/karate.instructions.md` |
| `src/test/java/**/*.java` | `instructions/karate.instructions.md` |

> Si el framework asume una convención de nombramiento diferente, ajusta los patrones `applyTo:` de cada archivo de `.github/instructions`.

## Lineamientos de referencia

Cargados automáticamente por los agentes:

| Documento | Contenido |
|---|---|
| `.github/docs/lineamientos/dev-guidelines.md` | Clean Code, SOLID, API REST, Seguridad, Observabilidad |
| `.github/docs/lineamientos/qa-guidelines.md` | Estrategia QA, Gherkin, Riesgos, Automatización, Performance |
| `.github/docs/lineamientos/guidelines.md` | Referencia rápida de estándares: código, tests, API, Git |

## Estructura de carpetas Arquitectura

```
Project Root/
│
├── docs/output/                     ← artefactos generados por los agentes
│   ├── qa/                          ← Gherkin, riesgos, performance
│   ├── api/                         ← documentación de API
│   └── adr/                         ← Architecture Decision Records
│
└── .github/                         ← framework Copilot (auto-contenido para compartir)
    ├── README.md                    ← este archivo
    ├── AGENTS.md                    ← reglas críticas para todos los agentes
    ├── copilot-instructions.md      ← siempre activo en Copilot Chat
    │
    ├── agents/                      ← agentes (@nombre en Copilot Chat)
    │   ├── orchestrator.agent.md
    │   ├── spec-generator.agent.md
    │   ├── qa.agent.md
    │   ├── implement-karate-assets.agent.md
    │   ├── implement-karate-feature.agent.md
    │   └── documentation.agent.md
    │
    ├── skills/                      ← skills (/comando en Copilot Chat)
    │   ├── asdd-orchestrate/
    │   ├── generate-spec/
    │   ├── gherkin-case-generator/
    │   ├── risk-identifier/
    │   ├── automation-flow-proposer/
    │   ├── implement-karate-assets/
    │   ├── implement-karate-feature/
    │
    ├── docs/lineamientos/           ← guidelines del framework (incluidos al compartir)
    │   ├── dev-guidelines.md
    │   └── qa-guidelines.md
    │
    ├── prompts/                     ← 8 prompts (/nombre en Copilot Chat)
    │
    ├── instructions/                ← aplicadas automáticamente por contexto de archivo
    │
    ├── requirements/                ← requerimientos de negocio (input del pipeline)
    │   └── <feature>.md
    │
    └── specs/                       ← specs técnicas (fuente de verdad)
        └── <feature>.spec.md        ← DRAFT → APPROVED → IN_PROGRESS → IMPLEMENTED
```

## Reglas de Oro

1. **No código sin spec aprobada** — siempre debe existir `specs/<feature>.spec.md` con estado `APPROVED`.
2. **No código no autorizado** — los agentes no generan ni modifican código sin instrucción explícita.
3. **No suposiciones** — si el requerimiento es ambiguo, el agente pregunta antes de actuar.
4. **Transparencia** — el agente explica qué va a hacer antes de hacerlo.

---

## 🔄 Escenario E2E: Ciclo de Vida de la Mascota (Pet Lifecycle)

El framework ejecuta un flujo End-to-End **idempotente** y **autocontenido** dentro de un único Escenario en Karate, garantizando que el estado se pase correctamente de petición en petición de manera limpia:

```
Creación de la mascota ➜ Recuperar por ID ➜ Actualizar nombre/estado (Sold) ➜ Búsqueda general por estado
```

### Estrategia de Idempotencia y Cero-Colisiones

Dado que PetStore (`swagger.io`) es un entorno público y compartido, el framework inyecta un identificador único en tiempo de ejecución de lado de Java interactuando con JavaScript, eliminando posibles solapamientos de datos con otros estudiantes o usuarios evaluadores:

```javascript
# Se captura el timestamp de Java y se procesa seguro para evitar notación científica:
* def tsStr = java.lang.Long.toString(java.lang.System.currentTimeMillis())
* def petId = java.lang.Integer.parseInt(tsStr.substring(tsStr.length() - 8))
```

Esto genera un identificador seguro de 8 dígitos y un nombre de mascota asociado como `TestPet_1712...` que se pasa durante todo el ciclo de vida sin interrupciones.

---

## 🏗️ Arquitectura y Estructura del Framework

La suite aísla la lógica para adherirse a Patrones Modulares:

| Capa | Paquete / Ruta | Responsabilidad |
|---|---|---|
| 📄 **Features** | `src/test/java/api/petstore/` | Archivos Gherkin (`.feature`) con la semántica del negocio y aserciones. Contienen los Scenarios del API. |
| 📦 **Payloads** | `src/test/java/common/payloads/` | Almacenamiento desacoplado de los Data Objects (JSON Reusables) mapeados estáticamente, para inyección en request body con interpolación nativa `#(var)`. |
| ⚙️ **Config** | `src/test/java/karate-config.js` | Inicialización de endpoints dinámicos, inyección de `baseUrl` por ambiente y manejo de resiliencia. |
| 📝 **Logging** | `src/test/java/logback-test.xml` | Reglas de supresión de ruido y formateo de trazas del compilador en buffer `target/karate.log`. |
| 🏃 **Runners** | `src/test/java/runners/` | Orquestador de JUnit 5 (`ChallengeTest.java`). |

---

## ⚡ Instrucciones de Clonado y Setup (Entorno Local)

### Paso 1: Clonar este Repositorio

```bash
git clone https://github.com/ChristopherPalloArias/KARATE_CHALLENGE.git
cd KARATE_CHALLENGE
```

### Paso 2: Análisis (Opcional)
No existe necesidad de levantar contenedores locales ni aplicaciones, puesto que las pruebas atacan directamente el entorno de nube público (Swagger PetStore v2). Solamente asegúrate de tener conectividad a internet para resolver las dependencias Maven.

---

## ▶️ Ejecución y Generación de Reportes

Para despachar la suite en modo local desde consola y generar el proceso de reportes de Karate, ejecuta:

### Ejecución Directa de la Suite Estándar

```bash
mvn test -Dtest=ChallengeTest
```

### Reporte de Evidencia y Trazabilidad (Living Documentation)

Al concluir, Karate auto-genera en tiempo real un **HTML Report** inyectado, que contendrá las evidencias detalladas de latencia, Request (Headers/Payload) y Response de trazabilidad absoluta para cada endpoint atacado.

* **El index maestro del informe lo encuentras en:**
  ```text
  target/karate-reports/karate-summary.html
  ```

---

## 🧩 Consideraciones Técnicas y Retos Resueltos (API)

* **Prevención de Notación Científica en Identificadores (GraalVM):**  
  Al usar algoritmos de módulo Matemático sobre Timestamps en JavaScript (dentro de GraalVM de Karate), si los identificadores resultan enormes, las peticiones GET se construían erróneamente con notación científica (ej. `/pet/8.83308084E8`), disparando errores 404 del servidor. Este reto se solventó convirtiendo el valor forzadamente apoyándonos en la API estática de Java `java.lang.Integer.parseInt()`.

* **Naturaleza Estricta del Aislamiento de Escenarios en Karate:**  
  A diferencia de Cucumber nativo en Java donde se pueden instanciar variables a nivel de Clase global para compartirse, Karate vacía la memoria al cambiar de `Scenario`. Por ello, consolidar el ciclo de vida transaccional (`Idempotent E2E Lifecycle`) en un solo flujo secuencial demostró ser el patrón arquitectónico correcto frente a quebrar el código en "Given's" frágiles multiescenario.

* **Inestabilidad Pública del Entorno de Swagger:**  
  Al requerir validación de casos aislados con números ficticios excesivos, el servidor en ocasiones emitía inestabilidad arrojando Exception Code `500 Internal Server Error` en lugar de `404 Not Found` en la capa base. La aserción fue diseñada explícitamente para observar un comportamiento asertivo tolerante y resiliente: `Then match responseStatus == 404 || responseStatus == 500`.

* **Desacople Riguroso de Data Objects (JSON):**
  A diferencia de ejemplos básicos en Karate, la suite rechaza la inserción *hardcodeada* de JSONs "quemados" sobre el bloque `And request`. Siguiendo el *Clean Code*, se resolvió migrando los cuerpos estructurales a archivos independientes (`pet-create.json`), inyectando macros `#(petId)` y referenciándolos funcionalmente de forma asíncrona mediante el comando `* def currentLoad = read('classpath:...')`.

* **Manejo Estricto de Niveles de Logging (Console Noise):**
  Se resolvió el factor problemático de Maven arrojando trazas kilométricas confusas al proveer un `logback-test.xml` orquestado. De este modo, la consola del CI arroja un Build Success depurado, empujando todas las anomalías y detalles de payload transaccional al documento físico seguro: `target/karate.log`.
