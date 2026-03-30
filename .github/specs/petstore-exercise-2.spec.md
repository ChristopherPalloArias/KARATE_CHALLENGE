---
id: SPEC-001
status: DRAFT
feature: petstore-exercise-2
created: 2026-03-30
updated: 2026-03-30
author: spec-generator
version: "1.0"
related-specs: []
---

# Spec: PetStore API Automation Exercise 2

> **Estado:** `DRAFT` → aprobar con `status: APPROVED` antes de iniciar implementación.
> **Ciclo de vida:** DRAFT → APPROVED → IN_PROGRESS → IMPLEMENTED → DEPRECATED

---

## 1. REQUERIMIENTOS

### Descripción

Automatizar el flujo completo de un recurso Pet en la API PetStore pública: creación de una mascota, verificación de su existencia por ID, actualización de su nombre y estado a "sold", y consulta de mascotas filtradas por estado. La solución debe ser reproducible y documentar hallazgos y conclusiones.

### Requerimiento de Negocio

El requerimiento original del usuario especifica:

> "Automate the requested PetStore API flow to validate the lifecycle of a pet resource through creation, retrieval by ID, update of name and status, and retrieval by status. The resulting solution must be reproducible and delivered in a public GitHub repository, including the automation assets, execution instructions, findings, and generated reports."

**Endpoints en Scope:**
1. `POST /pet` — Agregar una mascota al store.
2. `GET /pet/{petId}` — Recuperar la mascota por ID.
3. `PUT /pet` — Actualizar nombre y estado de la mascota a `sold`.
4. `GET /pet/findByStatus` — Recuperar mascotas filtradas por estado.

**Base URL:** `https://petstore.swagger.io/v2`

### Historias de Usuario

#### HU-01: Crear una nueva mascota en el store

```
Como:        Tester de automatización
Quiero:      Crear una nueva mascota en la API PetStore
Para:        Validar el flujo de creación y capturar el petId para pruebas posteriores

Prioridad:   Alta
Estimación:  S
Dependencias: Ninguna
Capa:        API / Automatización
```

#### Criterios de Aceptación — HU-01

**Happy Path**
```gherkin
CRITERIO-1.1: Crear mascota exitosamente
  Dado que:   El endpoint POST /pet está disponible
  Cuando:     Se envía un request con un payload válido de mascota
              (id, name, status, photoUrls)
  Entonces:   El servidor retorna un status 200
              Y el response contiene el petId asignado/enviado
              Y el response contiene el nombre enviado
              Y el response contiene el status enviado
```

**Edge Case**
```gherkin
CRITERIO-1.2: Capturar dinámicamente el petId para reutilización
  Dado que:    La mascota fue creada exitosamente
  Cuando:      El response contiene el atributo 'id'
  Entonces:    El petId se captura para usarse en los pasos siguientes
```

---

#### HU-02: Recuperar una mascota existente por ID

```
Como:        Tester de automatización
Quiero:      Recuperar la mascota creada usando su ID
Para:        Validar que la mascota se creó correctamente y existe en el store

Prioridad:   Alta
Estimación:  S
Dependencias: HU-01
Capa:        API / Automatización
```

#### Criterios de Aceptación — HU-02

**Happy Path**
```gherkin
CRITERIO-2.1: Recuperar mascota por ID exitosamente
  Dado que:    La mascota fue creada en HU-01 con petId válido
  Cuando:      Se envía GET /pet/{petId}
  Entonces:    El servidor retorna status 200
               Y el response contiene el petId solicitado
               Y el response contiene los mismos datos de la mascota creada
               Y se verifica la consistencia de nombre y estado
```

**Error Path**
```gherkin
CRITERIO-2.2: Manejo de petId inválido
  Dado que:    Se intenta recuperar una mascota con ID inexistente
  Cuando:      Se envía GET /pet/{petId_invalido}
  Entonces:    El servidor retorna status 404
```

---

#### HU-03: Actualizar nombre y estado de la mascota

```
Como:        Tester de automatización
Quiero:      Actualizar el nombre y el estado de la mascota a 'sold'
Para:        Validar que los cambios se persisten correctamente en el store

Prioridad:   Alta
Estimación:  M
Dependencias: HU-01, HU-02
Capa:        API / Automatización
```

#### Criterios de Aceptación — HU-03

**Happy Path**
```gherkin
CRITERIO-3.1: Actualizar mascota exitosamente
  Dado que:    La mascota existe en el store con petId conocido
  Cuando:      Se envía PUT /pet con:
               - id igual al petId creado
               - name actualizado
               - status = 'sold'
  Entonces:    El servidor retorna status 200
               Y el response refleja el nombre actualizado
               Y el response refleja status = 'sold'
```

**Validation**
```gherkin
CRITERIO-3.2: Estado actualizado a 'sold' es verificable
  Dado que:    La mascota fue actualizada exitosamente
  Cuando:      Se negocia el response del PUT
  Entonces:    El status en el response es exactamente 'sold'
```

---

#### HU-04: Recuperar mascotas filtradas por estado 'sold'

```
Como:        Tester de automatización
Quiero:      Recuperar todas las mascotas con estado 'sold'
Para:        Validar que la mascota actualizada aparece en los resultados filtrados

Prioridad:   Alta
Estimación:  S
Dependencias: HU-03
Capa:        API / Automatización
```

#### Criterios de Aceptación — HU-04

**Happy Path**
```gherkin
CRITERIO-4.1: Recuperar mascotas por status exitosamente
  Dado que:    La mascota fue actualizada a status 'sold'
  Cuando:      Se envía GET /pet/findByStatus?status=sold
  Entonces:    El servidor retorna status 200
               Y el response es un array de mascotas
               Y la mascota actualizada existe en el array
               Y se verifica que el petId figura en los resultados
               Y todos los items en el array tienen status = 'sold'
```

**Validation**
```gherkin
CRITERIO-4.2: Consistencia de datos en resultado filtrado
  Dado que:    Se recuperó la lista de mascotas con status 'sold'
  Cuando:      Se busca el petId creado en los resultados
  Entonces:    El item encontrado contiene el nombre actualizado
               Y el item contiene el status 'sold'
```

---

### Reglas de Negocio

1. **Identificador Único:** El `petId` es asignado por el servidor o enviado en el request y se reutiliza en todos los pasos posteriores.
2. **Estados Válidos:** El estado debe ser válido según la API PetStore (available, pending, sold).
3. **Actualización Atómica:** Una actualización de mascota cambia todos los campos en una sola solicitud.
4. **Filtrado por Status:** El endpoint `/pet/findByStatus` retorna un array de mascotas cuyo status coincide exactamente con el parámetro query.
5. **Ambiente Compartido:** La API es pública y compartida; se deben usar identificadores únicos o dinámicos para evitar colisiones.
6. **Headers Obligatorios:** 
   - `Content-Type: application/json` en requests con payload (POST, PUT)
   - `Accept: application/json` en todos los requests

---

## 2. DISEÑO API

### API Endpoints

#### FR-01: POST /pet — Crear mascota

- **Descripción:** Agrega una nueva mascota al store.
- **Auth requerida:** No
- **Request Headers:**
  ```
  Content-Type: application/json
  Accept: application/json
  ```
- **Request Body:**
  ```json
  {
    "id": 12345,
    "name": "UniqueTestPet_2026_03_30_001",
    "status": "available",
    "photoUrls": ["https://example.com/photo.jpg"]
  }
  ```
- **Response 200:**
  ```json
  {
    "id": 12345,
    "name": "UniqueTestPet_2026_03_30_001",
    "photoUrls": ["https://example.com/photo.jpg"],
    "status": "available"
  }
  ```
- **Notas:** El `id` puede ser enviado en el request o asignado por el servidor. Se captura para los pasos posteriores.

---

#### FR-02: GET /pet/{petId} — Recuperar mascota por ID

- **Descripción:** Recupera los detalles completos de una mascota existente.
- **Auth requerida:** No
- **Path Parameters:**
  - `petId` (integer): ID único de la mascota
- **Request Headers:**
  ```
  Accept: application/json
  ```
- **Response 200:**
  ```json
  {
    "id": 12345,
    "name": "UniqueTestPet_2026_03_30_001",
    "photoUrls": ["https://example.com/photo.jpg"],
    "status": "available"
  }
  ```
- **Response 404:** No encontrado (petId inexistente)
- **Notas:** El response debe reflejar los datos creados en FR-01.

---

#### FR-03: PUT /pet — Actualizar mascota

- **Descripción:** Actualiza una mascota existente, incluyendo cambio de nombre y estado.
- **Auth requerida:** No
- **Request Headers:**
  ```
  Content-Type: application/json
  Accept: application/json
  ```
- **Request Body:**
  ```json
  {
    "id": 12345,
    "name": "UpdatedPetName_2026_03_30",
    "photoUrls": ["https://example.com/photo.jpg"],
    "status": "sold"
  }
  ```
- **Response 200:**
  ```json
  {
    "id": 12345,
    "name": "UpdatedPetName_2026_03_30",
    "photoUrls": ["https://example.com/photo.jpg"],
    "status": "sold"
  }
  ```
- **Notas:** El `id` debe coincidir con el petId de la mascota a actualizar. El status debe ser exactamente "sold".

---

#### FR-04: GET /pet/findByStatus — Recuperar mascotas por estado

- **Descripción:** Recupera un listado de mascotas filtradas por status.
- **Auth requerida:** No
- **Query Parameters:**
  - `status` (string): Estado a filtrar (available, pending, sold)
- **Request Headers:**
  ```
  Accept: application/json
  ```
- **Response 200:**
  ```json
  [
    {
      "id": 12345,
      "name": "UpdatedPetName_2026_03_30",
      "photoUrls": ["https://example.com/photo.jpg"],
      "status": "sold"
    },
    {
      "id": 67890,
      "name": "AnotherPet",
      "photoUrls": ["https://example.com/photo2.jpg"],
      "status": "sold"
    }
  ]
  ```
- **Notas:** El response es un array. Todos los items deben tener el status solicitado. La mascota actualizada en FR-03 debe estar presente.

---

### Arquitectura y Dependencias

- **Paquetes nuevos requeridos:** Ninguno (Karate framework ya incluido)
- **Servicios externos:** PetStore API pública en `https://petstore.swagger.io/v2`
- **Impacto en punto de entrada:** Se registra un runner de Karate en `src/test/java/runners/` que ejecuta el feature file.
- **Configuración Global:** El `baseUrl` se configura en `karate-config.js` y se pasa como parámetro en tiempo de ejecución.

### Estructura de Código

```
src/test/java/
├── api/
│   └── petstore/
│       └── petstore-exercise-2.feature    (Feature file con 4 escenarios)
├── common/
│   ├── payloads/
│   │   ├── pet-create.json                (Request para FR-01)
│   │   └── pet-update.json                (Request para FR-03)
│   └── schemas/
│       ├── pet-response.json              (Schema para FR-01, FR-02, FR-03)
│       └── pet-list.json                  (Schema para FR-04)
└── runners/
    └── ChallengeTest.java                 (Ya existe, ejecuta todos los features)
```

### Notas de Implementación

1. **Generación Dinámica de petId:** Use timestamps o UUIDs para evitar colisiones en el ambiente compartido.
2. **Captura de Variables:** Use `* def petId = response.id` después de FR-01 para reutilizarla en pasos posteriores.
3. **Headers Reutilizables:** Configure headers comunes en el Background del feature.
4. **Validación de Schema:** Use `match response == read('classpath:common/schemas/...')` para validaciones robustas.
5. **Orden Secuencial:** Los 4 escenarios deben ejecutarse en orden (HU-01 → HU-02 → HU-03 → HU-04) en un único feature o en escenarios separados con datos compartidos a través de variables de contexto.

---

## 3. LISTA DE TAREAS

> Checklist accionable para la automatización en Karate. Marcar cada ítem (`[x]`) al completarlo.

### QA y Gherkin

- [ ] Ejecutar skill `/gherkin-case-generator` → generar escenarios detallados para CRITERIO-1.1, 1.2, 2.1, 2.2, 3.1, 3.2, 4.1, 4.2
- [ ] Ejecutar skill `/risk-identifier` → clasificación ASD de riesgos para el flujo PetStore
- [ ] Revisar criterios de aceptación contra datos de prueba dinámicos
- [ ] Validar que la estrategia de datos evita colisiones en ambiente compartido

### Automatización Karate

- [ ] Crear archivo `src/test/java/api/petstore/petstore-exercise-2.feature` con Background configurado
- [ ] Implementar FR-01 (POST /pet): escenario feliz + captura de petId
- [ ] Implementar FR-02 (GET /pet/{petId}): validación de consistencia
- [ ] Implementar FR-03 (PUT /pet): actualización de nombre y status
- [ ] Implementar FR-04 (GET /pet/findByStatus): validación de presencia en resultados filtrados
- [ ] Crear payload `common/payloads/pet-create.json` con estructura válida
- [ ] Crear payload `common/payloads/pet-update.json` con nombre y status actualizado
- [ ] Crear schema `common/schemas/pet-response.json` para validación de response individual
- [ ] Crear schema `common/schemas/pet-list.json` para validación de array en FR-04
- [ ] Incorporar aserciones precisas (codes HTTP 200, arrays, campos obligatorios)
- [ ] Validar flujo end-to-end: crear → leer → actualizar → filtrar
- [ ] Ejecutar tests localmente contra base URL configurada

### Documentación y Entrega

- [ ] Crear archivo `readme.txt` con instrucciones step-by-step de ejecución:
  - Requisitos (Maven, Java)
  - Cómo clonar el repositorio
  - Cómo ejecutar los tests (comando Maven o Karate CLI)
  - Dónde encontrar los reportes (target/karate-reports/)
- [ ] Crear archivo `conclusiones.txt` con hallazgos:
  - Resumen del flujo probado
  - Endpoints validados
  - Datos dinámicos usados y estrategia de colisión
  - Observaciones sobre la API PetStore
  - Mejoras o limitaciones encontradas
- [ ] Confirmar que el repositorio es público en GitHub
- [ ] Verificar que todos los assets son reproducibles sin hardcoding

### QA Final

- [ ] Ejecutar skill `/gherkin-case-generator` → casos negativos opcionales (invalid ID, malformed payloads)
- [ ] Revisar cobertura de tests contra todos los criterios de aceptación
- [ ] Validar que todas las reglas de negocio están cubiertas
- [ ] Actualizar estado spec: `status: APPROVED` (una vez validado)
- [ ] Actualizar estado spec a `status: IMPLEMENTED` al completar la automatización

---

**Fin de la Especificación SPEC-001**
