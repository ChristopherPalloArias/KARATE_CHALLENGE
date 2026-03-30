# Casos Gherkin: petstore-exercise-2

**Feature:** PetStore API — Ciclo de vida de una mascota  
**Especificación:** [.github/specs/petstore-exercise-2.spec.md]  
**Generado:** 2026-03-30  
**Estado:** QA Phase  

---

## 1. Identificación de Flujos Críticos

| Tipo | HU | Escenario | Impacto | Tags |
|------|-----|-----------|---------|------|
| Happy Path | HU-01 | Crear mascota exitosamente | Alto | `@smoke` `@critico` |
| Happy Path | HU-02 | Consultar mascota por ID | Alto | `@smoke` `@critico` |
| Happy Path | HU-03 | Actualizar mascota a sold | Alto | `@smoke` `@critico` |
| Happy Path | HU-04 | Filtrar por estado sold | Alto | `@smoke` `@critico` |
| Error Path | HU-02 | Consultar con ID inexistente | Medio | `@error-path` |
| Edge Case | HU-01 | Reutilizar petId capturado | Medio | `@edge-case` |
| Edge Case | HU-03 | Actualizar sin cambiar ID | Medio | `@edge-case` |
| Edge Case | HU-04 | Validar presencia en array | Medio | `@edge-case` |

---

## 2. Escenarios Gherkin Detallados

### 2.1 HU-01: Crear una mascota en PetStore

#### SC-1.1 — Happy Path: Crear mascota exitosamente (CRITERIO-1.1)

```gherkin
#language: es
@smoke @critico @hu-01
Escenario: Crear una mascota en el store y capturar su identificador

  Dado que la API pública de PetStore está disponible en "https://petstore.swagger.io/v2"
  Y que existe un payload válido para crear una mascota con:
    | campo      | valor                      |
    | id         | <generado-timestamp>       |
    | name       | "TestPet_<timestamp>"      |
    | status     | "available"                |
    | photoUrls  | ["https://example.com/p1"] |
  
  Cuando se envía POST /pet con el payload
  
  Entonces el servidor retorna un status 200
  Y la respuesta contiene el petId asignado/enviado
  Y la respuesta contiene el nombre "TestPet_<timestamp>"
  Y la respuesta contiene el status "available"
  Y el petId se captura como variable para reutilizar en pasos posteriores
```

**Datos de Prueba — SC-1.1:**

| Campo | Descripción | Valor Sintético |
|-------|-------------|-----------------|
| id | Identificador único dinámico | `1234567890 + timestamp()` |
| name | Nombre de mascota único | `TestPet_20260330_093000` |
| status | Estado inicial válido | `available` |
| photoUrls | Array de URLs (puede estar vacío) | `["https://example.com/photo.jpg"]` |

**Precondiciones:**
- La API PetStore es accesible en la URL configurada
- Se usa dinámicamente el timestamp para evitar colisiones

**Postcondiciones:**
- El `petId` queda disponible como variable global para HU-02, HU-03, HU-04

---

#### SC-1.2 — Edge Case: Capturar dinámicamente petId para reutilización (CRITERIO-1.2)

```gherkin
#language: es
@edge-case @hu-01
Escenario: El petId capturado es reutilizable en pasos posteriores

  Dado que la mascota fue creada exitosamente en SC-1.1
  Y que la respuesta contiene el atributo "id"
  
  Cuando se extrae y almacena el petId de la respuesta
  
  Entonces el petId es de tipo numérico
  Y el petId no está vacío
  Y el petId puede ser interpolado en URL de pasos posteriores
    Ejemplo: GET /pet/{petId} se convierte en GET /pet/1234567890
```

**Datos de Prueba — SC-1.2:**

| Campo | Descripción | Validación |
|-------|-------------|-----------|
| response.id | ID extraído del response | `type(id) == number` Y `id > 0` |
| variable petId | Variable global capturada | `def petId = response.id` |

---

### 2.2 HU-02: Consultar una mascota existente por ID

#### SC-2.1 — Happy Path: Consultar mascota por ID exitosamente (CRITERIO-2.1)

```gherkin
#language: es
@smoke @critico @hu-02
Escenario: Consultar la mascota creada previamente usando su identificador

  Dado que existe un petId obtenido en HU-01: <petId>
  Y que la API PetStore está disponible en "https://petstore.swagger.io/v2"
  
  Cuando se envía GET /pet/{petId} con el petId capturado
  
  Entonces el servidor retorna un status 200
  Y la respuesta contiene el petId solicitado
  Y la respuesta contiene el nombre "TestPet_<timestamp>" (consistencia con HU-01)
  Y la respuesta contiene el status "available"
  Y la respuesta estructura es consistente con el pet creado
```

**Datos de Prueba — SC-2.1:**

| Campo | Descripción | Valor |
|-------|-------------|-------|
| petId | Reutilizado de HU-01 | `${petId_from_HU01}` |
| HTTP Method | Método esperado | `GET` |
| Path | Ruta con parámetro | `/pet/{petId}` |
| Expected Status | Código esperado | `200` |

**Precondiciones:**
- HU-01 ejecutado exitosamente
- El `petId` está disponible como variable

**Validaciones Clave:**
- Status code es 200
- `response.id == petId` (identidad verificable)
- Campos regresan sin cambios: `name`, `status`, `photoUrls`

---

#### SC-2.2 — Error Path: Gestión de petId inexistente

```gherkin
#language: es
@error-path @hu-02
Escenario: Intentar consultar una mascota con ID inexistente

  Dado que se intenta acceder a un petId que NO existe: "999999999"
  Y que la API PetStore está disponible en "https://petstore.swagger.io/v2"
  
  Cuando se envía GET /pet/999999999
  
  Entonces el servidor retorna un status 404
  Y la respuesta puede incluir un mensaje de error indicando "Pet not found" o similar
  Y la operación NO modifica ningún recurso
```

**Datos de Prueba — SC-2.2:**

| Campo | Descripción | Valor |
|-------|-------------|-------|
| petId | ID inexistente | `999999999` |
| Expected Status | Código esperado | `404` |
| Expected Behavior | Comportamiento | "No modificación, error graceful" |

---

### 2.3 HU-03: Actualizar nombre y estado de la mascota

#### SC-3.1 — Happy Path: Actualizar mascota a estado sold (CRITERIO-3.1)

```gherkin
#language: es
@smoke @critico @hu-03
Escenario: Actualizar el nombre y estado de una mascota a sold

  Dado que existe una mascota previamente creada con petId: <petId>
  Y que se dispone de un nuevo nombre: "UpdatedPet_<timestamp>"
  Y que la API PetStore está disponible en "https://petstore.swagger.io/v2"
  
  Cuando se envía PUT /pet con el payload de actualización:
    | campo      | valor                      |
    | id         | <petId>                    |
    | name       | "UpdatedPet_<timestamp>"   |
    | status     | "sold"                     |
    | photoUrls  | ["https://example.com/p1"] |
  
  Entonces el servidor retorna un status 200
  Y la respuesta refleja el nombre actualizado "UpdatedPet_<timestamp>"
  Y la respuesta refleja el status "sold"
  Y el petId permanece idéntico al original
```

**Datos de Prueba — SC-3.1:**

| Campo | Descripción | Valor Sintético |
|-------|-------------|-----------------|
| id (en PUT) | Reutilizado de HU-01 | `${petId_from_HU01}` |
| name | Nuevo nombre único | `UpdatedPet_20260330_093015` |
| status | Estado final requerido | `sold` |
| photoUrls | Mantener consistencia | `["https://example.com/p1"]` |

**Precondiciones:**
- HU-01 y HU-02 ejecutados exitosamente
- El `petId` está disponible

**Postcondiciones:**
- La mascota ahora tiene `status = sold` en el servidor
- El registro está listo para la consulta por estado en HU-04

---

#### SC-3.2 — Edge Case: Verificar estado sold en la respuesta (CRITERIO-3.2)

```gherkin
#language: es
@edge-case @hu-03
Escenario: El estado actualizado a sold es verificable exactamente

  Dado que la mascota fue actualizada exitosamente
  Y que la respuesta del PUT contiene el atributo "status"
  
  Cuando se evalúa el valor de response.status
  
  Entonces el valor es exactamente "sold" (sensible a mayúsculas/minúsculas)
  Y el tipo del campo es string
  Y el campo no está vacío
```

**Datos de Prueba — SC-3.2:**

| Campo | Validación | Tipo |
|-------|-----------|------|
| response.status | Debe ser "sold" | String |
| Exactitud | Case-sensitive | Verificable durante ejecución |

---

### 2.4 HU-04: Consultar mascotas por estado

#### SC-4.1 — Happy Path: Verificar presencia de mascota actualizada en filtro (CRITERIO-4.1)

```gherkin
#language: es
@smoke @critico @hu-04
Escenario: Consultar mascotas filtradas por estado sold y verificar presencia

  Dado que la mascota fue actualizada al estado "sold" en HU-03
  Y que el petId es conocido: <petId>
  Y que la API PetStore está disponible en "https://petstore.swagger.io/v2"
  
  Cuando se envía GET /pet/findByStatus?status=sold
  
  Entonces el servidor retorna un status 200
  Y la respuesta contiene una colección/array de mascotas
  Y el array contiene al menos un elemento
  Y la mascota con petId <petId> está presente en el array
  Y el elemento encontrado tiene status "sold"
  Y el elemento encontrado contiene el nombre actualizado "UpdatedPet_<timestamp>"
```

**Datos de Prueba — SC-4.1:**

| Campo | Descripción | Búsqueda |
|-------|-------------|----------|
| Query Param | status | `sold` |
| Expected Type | Estructura | Array o colección |
| Search Key | Campo a buscar | `id == <petId>` |
| Validación | Dentro del array | `name == "UpdatedPet_<timestamp>"` Y `status == "sold"` |

**Precondiciones:**
- HU-01, HU-02, HU-03 ejecutados exitosamente
- La mascota tiene estado `sold` en el servidor

**Postcondiciones:**
- Valida el ciclo de vida completo: creación → consulta → actualización → filtrado

---

#### SC-4.2 — Edge Case: Validar consistencia de datos en resultado filtrado (CRITERIO-4.2)

```gherkin
#language: es
@edge-case @hu-04
Escenario: Verificar datos consistentes de la mascota encontrada en el filtro

  Dado que la mascota fue encontrada en el resultado del filtro por status=sold
  Y que la respuesta.items.find(item => item.id == petId) retorna un registro
  
  Cuando se valida el contenido del registro encontrado
  
  Entonces el registro contiene exactamente el petId esperado
  Y el registro contiene el nombre actualizado (no el nombre original)
  Y el registro contiene el status "sold"
  Y todos los campos regresan como fueron enviados en la actualización
```

**Datos de Prueba — SC-4.2:**

| Campo | Valor Esperado | Fuente |
|-------|----------------|--------|
| id | Idéntico a petId original | De HU-01 |
| name | "UpdatedPet_<timestamp>" | De HU-03 |
| status | "sold" | De HU-03 |

---

## 3. Matriz de Datos de Prueba Sintéticos

### Datos Globales por Ejecución

```
EXECUTION_ID = timestamp() + random(1000, 9999)
Example: 20260330_093000_5432

BASE_PET_ID = 1000000000 + EXECUTION_ID
Example: 1000000000 + 20260330_093000_5432 = 1020260330093000

INITIAL_PET_NAME = "TestPet_" + EXECUTION_ID
Example: "TestPet_20260330_093000_5432"

UPDATED_PET_NAME = "UpdatedPet_" + EXECUTION_ID
Example: "UpdatedPet_20260330_093000_5432"
```

### Tabla de Datos por Escenario

| Escenario | Entrada: petId | Entrada: name | Entrada: status | Esperado: status | Esperado: name |
|-----------|---|---|---|---|---|
| SC-1.1 (CREATE) | `BASE_PET_ID` | `INITIAL_PET_NAME` | `available` | `available` | `INITIAL_PET_NAME` |
| SC-2.1 (READ by ID) | `BASE_PET_ID` (reutilizado) | — | — | `available` | `INITIAL_PET_NAME` |
| SC-3.1 (UPDATE) | `BASE_PET_ID` (reutilizado) | `UPDATED_PET_NAME` | `sold` | `sold` | `UPDATED_PET_NAME` |
| SC-4.1 (FILTER) | — | — | `sold` (query) | `sold` | `UPDATED_PET_NAME` |

---

## 4. Categorización de Escenarios por Impacto (Regla ASD)

| Clasificación | Escenarios | Prioridad | Justificación |
|---|---|---|---|
| **ALTO** (Obligatorio) | SC-1.1, SC-2.1, SC-3.1, SC-4.1 | `@smoke @critico` | Flujo secuencial del reto; sin estos fallan las demás fases |
| **MEDIO** (Recomendado) | SC-1.2, SC-2.2, SC-3.2, SC-4.2 | `@edge-case @error-path` | Validan robustez; identifican límites del sistema |
| **BAJO** (Opcional) | Casos negativos adicionales (ej. payload malformado) | — | No solicitados explícitamente por el reto |

---

## 5. Matriz de Riesgos Identificados

| Riesgo | Tipo | Severidad | Escenario(s) Mitigante(s) |
|--------|------|-----------|----------------------|
| Colisión de petId en ambiente compartido | Datos | Alto | SC-1.1 (uso de EXECUTION_ID único) |
| petId no reutilizable entre operaciones | Integración | Alto | SC-1.2, SC-2.1, SC-3.1, SC-4.1 (captura y reuso) |
| Status code o schema inesperado | Contract | Medio | SC-2.2 (error handling) |
| Mascota no aparece en filtro por status | Lógica | Alto | SC-4.1, SC-4.2 (búsqueda de presencia) |
| Actualización parcial o no persistida | Data | Medio | SC-3.2 (verificación exacta de status) |

---

## 6. Notas para Implementación en Karate

### Estructura Recomendada del Feature File

```
src/test/java/petstore/petstore-exercise-2.feature

Feature: PetStore API — Ciclo de vida de una mascota

  Background:
    * url baseUrl
    * def executionId = java.time.Instant.now().toEpochMilli()
    * def basePetId = 1000000000 + executionId
    * def initialPetName = 'TestPet_' + executionId
    * def updatedPetName = 'UpdatedPet_' + executionId
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'

  @smoke @critico @hu-01
  Scenario: SC-1.1 - Crear mascota exitosamente
    Given path '/pet'
    And request {...}
    When method POST
    Then status 200
    And match response.id == basePetId
    * def petId = response.id

  @smoke @critico @hu-02
  Scenario: SC-2.1 - Consultar mascota por ID
    # Reutilizar petId del escenario anterior
    Given path '/pet', petId
    When method GET
    Then status 200
    And match response.id == petId

  @smoke @critico @hu-03
  Scenario: SC-3.1 - Actualizar mascota a sold
    Given path '/pet'
    And request {...}
    When method PUT
    Then status 200
    And match response.status == 'sold'

  @smoke @critico @hu-04
  Scenario: SC-4.1 - Filtrar por estado sold
    Given path '/pet/findByStatus'
    And param status = 'sold'
    When method GET
    Then status 200
    And match response[*].id contains petId
```

### Variables Karate Esperadas

```javascript
// En karate-config.js o background del feature
var executionId = System.currentTimeMillis();
var basePetId = 1000000000 + executionId;
var initialPetName = 'TestPet_' + executionId;
var updatedPetName = 'UpdatedPet_' + executionId;
var petId; // Capturado en primer escenario, reutilizado en posteriores
```

---

## 7. Estrategia de Validación

### Por Escenario

| Escenario | Validación Principal | Validación Secundaria |
|-----------|----------------------|----------------------|
| SC-1.1 | Status 200 + petId capturado | Nombre y status consistentes |
| SC-2.1 | Status 200 + petId matches | Datos no cambiaron |
| SC-3.1 | Status 200 + status=sold | Nombre actualizado persistido |
| SC-4.1 | Status 200 + petId in array | Nombre y status en resultado |
| SC-2.2 | Status 404 | Sin modificación |
| SC-1.2 | petId es reutilizable | Tipo numérico, > 0 |
| SC-3.2 | status == 'sold' exacto | Case-sensitive |
| SC-4.2 | Todas las propiedades coinciden | Sin valores nulos |

---

## 8. Entrega y Siguiente Fase

**Archivos Generados:**
- `docs/output/qa/petstore-exercise-2-gherkin.md` (este documento)

**Próximas Acciones:**
- [ ] Ejecutar `/risk-identifier petstore-exercise-2` → generar matriz de riesgos detallada
- [ ] Aprobar escenarios con stakeholders si aplica
- [ ] Pasar a fase de `implement-karate-feature` para crear el `.feature` file
- [ ] Ejecutar tests y capturar evidencia

---

**FIN DE CASOS GHERKIN**
