````markdown
---
id: SPEC-001
status: APPROVED
feature: petstore-exercise-2
created: 2026-03-30
updated: 2026-03-30
author: spec-generator
version: "1.0"
related-specs: []
tags:
  - karate
  - api
  - petstore
  - exercise-2
  - pet-lifecycle
---

# Spec: PetStore API Automation Exercise 2

> **Estado:** `DRAFT`  
> Esta spec debe pasar a `APPROVED` antes de iniciar implementación.

---

## 1. REQUERIMIENTOS

### 1.1 Descripción

Automatizar un flujo secuencial sobre el recurso **Pet** en la API pública de PetStore para validar lo siguiente:

1. agregar una mascota a la tienda  
2. consultar la mascota ingresada previamente por ID  
3. actualizar el nombre de la mascota y cambiar su estado a `sold`  
4. consultar la mascota modificada por estado  

La solución debe ser reproducible, ejecutable con Karate y entregarse en un repositorio GitHub público con documentación de ejecución, conclusiones y evidencia de ejecución.

---

### 1.2 Requerimiento de negocio

El objetivo del ejercicio es validar el ciclo de vida básico de una mascota en la API PetStore mediante una automatización reproducible y defendible.

El alcance funcional obligatorio del reto es:

- `POST /pet` para agregar una mascota
- `GET /pet/{petId}` para consultar la mascota creada
- `PUT /pet` para actualizar el nombre y el estado de la misma mascota
- `GET /pet/findByStatus` para consultar mascotas por estado y confirmar la presencia de la mascota actualizada

El flujo debe depender del **mismo `petId`** desde el alta hasta la consulta final por estado.

**Base URL objetivo:** `https://petstore.swagger.io/v2`

**Entregables obligatorios del reto:**

- automatización reproducible
- reportes de ejecución
- `readme.txt`
- `conclusiones.txt`
- repositorio GitHub público

---

### 1.3 Historias de usuario

#### HU-01 — Crear mascota

**Como** tester de automatización  
**Quiero** crear una mascota en la API PetStore  
**Para** capturar su identificador y reutilizarlo en los pasos posteriores del flujo

- **Prioridad:** Alta
- **Dependencias:** Ninguna
- **Capa:** API / Automatización

#### HU-02 — Consultar mascota por ID

**Como** tester de automatización  
**Quiero** consultar la mascota creada usando su ID  
**Para** verificar que la creación fue persistida correctamente

- **Prioridad:** Alta
- **Dependencias:** HU-01
- **Capa:** API / Automatización

#### HU-03 — Actualizar nombre y estado

**Como** tester de automatización  
**Quiero** actualizar el nombre de la mascota y cambiar su estado a `sold`  
**Para** verificar que los cambios quedan reflejados en el recurso

- **Prioridad:** Alta
- **Dependencias:** HU-01, HU-02
- **Capa:** API / Automatización

#### HU-04 — Consultar mascota por estado

**Como** tester de automatización  
**Quiero** consultar mascotas filtradas por estado `sold`  
**Para** verificar que la mascota actualizada aparece dentro del resultado filtrado

- **Prioridad:** Alta
- **Dependencias:** HU-03
- **Capa:** API / Automatización

---

### 1.4 Criterios de aceptación en formato Gherkin

#### HU-01 — Crear mascota

```gherkin
Feature: Crear una mascota en PetStore

  Scenario: Crear una mascota y capturar su identificador
    Given que la API pública de PetStore está disponible
    And que existe un payload válido para crear una mascota
    When se envía la solicitud para agregar la mascota
    Then la respuesta indica creación exitosa o aceptación exitosa según comportamiento observado durante la implementación
    And la respuesta contiene el identificador de la mascota
    And la respuesta contiene datos consistentes con la mascota enviada
    And el petId queda disponible para reutilizarse en los pasos siguientes
````

#### HU-02 — Consultar mascota por ID

```gherkin
Feature: Consultar una mascota existente por ID

  Scenario: Consultar la mascota creada previamente
    Given que existe un petId obtenido en el paso de creación
    When se envía la solicitud de consulta por ID
    Then la respuesta indica consulta exitosa según comportamiento observado durante la implementación
    And la respuesta corresponde al mismo petId
    And la respuesta conserva consistencia con los datos de la mascota creada
```

#### HU-03 — Actualizar nombre y estado

```gherkin
Feature: Actualizar nombre y estado de una mascota

  Scenario: Actualizar la misma mascota a estado sold
    Given que existe una mascota previamente creada e identificada por su petId
    And que se dispone de un nuevo nombre para esa misma mascota
    When se envía la solicitud de actualización usando el mismo petId
    Then la respuesta indica actualización exitosa según comportamiento observado durante la implementación
    And la respuesta refleja el nombre actualizado
    And la respuesta refleja el estado sold
```

#### HU-04 — Consultar por estado

```gherkin
Feature: Consultar mascotas por estado

  Scenario: Verificar la presencia de la mascota actualizada en el filtro por sold
    Given que la mascota ya fue actualizada al estado sold
    When se envía la solicitud para consultar mascotas con status sold
    Then la respuesta indica consulta exitosa según comportamiento observado durante la implementación
    And la respuesta contiene una colección de mascotas o una estructura equivalente a validar durante la implementación
    And la mascota actualizada está presente en el resultado
    And el registro encontrado conserva el mismo petId
    And el registro encontrado refleja el nombre actualizado y el estado sold
```

---

### 1.5 Reglas de negocio

1. El flujo es **secuencial** y depende del mismo `petId`.
2. La mascota consultada por ID debe ser la misma que fue creada previamente.
3. La mascota actualizada debe conservar el mismo `petId`.
4. El nombre y el estado deben actualizarse en el mismo flujo requerido por el reto.
5. El estado final requerido por el ejercicio es `sold`.
6. La validación de la búsqueda por estado debe confirmar la **presencia** de la mascota actualizada dentro del resultado, no asumir que será el único registro devuelto.
7. No se debe asumir un paso de limpieza por `DELETE`, porque no forma parte del alcance solicitado.
8. La estrategia de datos debe considerar que el ambiente es público y compartido.
9. Cualquier status code, estructura exacta de payload o contrato de respuesta no confirmado por el requirement debe tratarse como **to validate during implementation**.
10. La solución final debe incluir `readme.txt`, `conclusiones.txt`, reportes y repositorio público.

---

## 2. DISEÑO API

### 2.1 Resumen de endpoints en alcance

| ID    | Método | Endpoint            | Propósito                                      | Dependencia  |
| ----- | ------ | ------------------- | ---------------------------------------------- | ------------ |
| FR-01 | POST   | `/pet`              | Agregar una mascota                            | Ninguna      |
| FR-02 | GET    | `/pet/{petId}`      | Consultar mascota por ID                       | FR-01        |
| FR-03 | PUT    | `/pet`              | Actualizar nombre y estado de la misma mascota | FR-01, FR-02 |
| FR-04 | GET    | `/pet/findByStatus` | Consultar mascotas por estado                  | FR-03        |

---

### 2.2 Base URL y configuración

* **Base URL objetivo:** `https://petstore.swagger.io/v2`
* **Fuente de configuración esperada:** propiedad configurable en tiempo de ejecución
* **Variable de configuración esperada:** `baseUrl`
* **Autenticación:** [Not provided]
* **Tipo de API:** REST
* **Ambiente:** público y compartido

---

### 2.3 Diseño por endpoint

#### FR-01 — POST `/pet`

* **Objetivo:** agregar una mascota a la tienda
* **Precondición:** ninguna
* **Headers esperados:**

  * `Content-Type: application/json`
  * `Accept: application/json`
* **Path params:** ninguno
* **Query params:** ninguno
* **Request body esperado:** payload válido para creación de mascota

  * debe contener la información necesaria para:

    * identificar la mascota en el flujo
    * consultarla luego por ID
    * actualizarla posteriormente
  * estructura exacta: **to validate during implementation**
* **Response esperado:** respuesta consistente con la creación o aceptación de la mascota
* **Success status code:** **to validate during implementation**
* **Error status code:** [Not provided]
* **Validaciones mínimas:**

  * se obtiene un `petId`
  * la respuesta mantiene consistencia con la mascota creada
* **Observaciones:**

  * el `petId` debe conservarse para los pasos posteriores
  * el payload debe usar datos dinámicos para reducir colisiones

#### FR-02 — GET `/pet/{petId}`

* **Objetivo:** consultar la mascota creada previamente
* **Precondición:** FR-01 ejecutado con éxito funcional
* **Headers esperados:**

  * `Accept: application/json`
* **Path params:**

  * `petId`
* **Query params:** ninguno
* **Request body:** ninguno
* **Response esperado:** respuesta consistente con la mascota creada en FR-01
* **Success status code:** **to validate during implementation**
* **Error status code:** [Not provided]
* **Validaciones mínimas:**

  * el `petId` retornado coincide con el usado en la consulta
  * la respuesta conserva consistencia con los datos de creación
* **Observaciones:**

  * no se debe introducir aquí un caso negativo obligatorio porque no forma parte del alcance mínimo pedido

#### FR-03 — PUT `/pet`

* **Objetivo:** actualizar el nombre de la mascota y cambiar su estado a `sold`
* **Precondición:** la mascota existe y su `petId` ya fue capturado
* **Headers esperados:**

  * `Content-Type: application/json`
  * `Accept: application/json`
* **Path params:** ninguno
* **Query params:** ninguno
* **Request body esperado:** payload válido de actualización para la misma mascota

  * debe reutilizar el mismo `petId`
  * debe incluir el nuevo nombre
  * debe incluir el estado final `sold`
  * estructura exacta: **to validate during implementation**
* **Response esperado:** respuesta consistente con el recurso actualizado
* **Success status code:** **to validate during implementation**
* **Error status code:** [Not provided]
* **Validaciones mínimas:**

  * el `petId` sigue siendo el mismo
  * el nombre queda actualizado
  * el estado queda en `sold`

#### FR-04 — GET `/pet/findByStatus`

* **Objetivo:** consultar mascotas por estado y confirmar la presencia de la mascota actualizada
* **Precondición:** FR-03 ejecutado con éxito funcional
* **Headers esperados:**

  * `Accept: application/json`
* **Path params:** ninguno
* **Query params:**

  * `status=sold`
* **Request body:** ninguno
* **Response esperado:** conjunto o colección de registros filtrados por estado, a validar durante implementación
* **Success status code:** **to validate during implementation**
* **Error status code:** [Not provided]
* **Validaciones mínimas:**

  * la respuesta contiene el `petId` de la mascota actualizada
  * el registro encontrado refleja el nombre actualizado
  * el registro encontrado refleja el estado `sold`
* **Observaciones:**

  * no se debe asumir que la respuesta contendrá solo una mascota
  * la validación clave es la **presencia del registro esperado** dentro del resultado

---

### 2.4 Dependencias del flujo

1. **FR-01** genera o confirma el `petId` a usar.
2. **FR-02** consulta el mismo `petId` obtenido en FR-01.
3. **FR-03** actualiza el mismo `petId` usando nuevo nombre y estado `sold`.
4. **FR-04** confirma que el mismo `petId` aparece en la consulta por `status=sold`.

**Orden obligatorio del flujo:**

`FR-01 -> FR-02 -> FR-03 -> FR-04`

---

### 2.5 Request / response esperados

#### Lineamientos de request

* Los payloads deben ser válidos para el endpoint objetivo.
* Los datos deben ser dinámicos cuando ayuden a evitar colisiones en ambiente compartido.
* El mismo `petId` debe viajar a través de todo el flujo.
* La actualización debe cambiar únicamente lo requerido por el ejercicio:

  * nombre
  * estado a `sold`

#### Lineamientos de response

* La respuesta de cada paso debe demostrar consistencia funcional con la operación realizada.
* No se deben fijar contracts estrictos no confirmados por el requirement.
* Cualquier validación adicional de schema exacto debe tratarse como **candidate** o **to validate during implementation**.

---

### 2.6 Notas de implementación

1. La implementación preferida es con **Karate**.
2. `baseUrl` debe ser configurable por propiedad.
3. Se deben usar datos dinámicos para reducir colisiones en el entorno público.
4. La automatización debe centrarse solo en el flujo obligatorio del reto.
5. No se debe implementar `DELETE` como parte del flujo requerido.
6. La validación final en `findByStatus` debe buscar la mascota dentro del resultado y no asumir unicidad del listado.
7. Los reportes deben quedar accesibles en `target/karate-reports/`.
8. Los archivos mínimos esperados en la siguiente fase de implementación son:

   * `src/test/java/karate-config.js`
   * `src/test/java/runners/ChallengeTest.java`
   * `src/test/java/petstore/petstore-pet-lifecycle.feature`
   * `readme.txt`
   * `conclusiones.txt`

---

## 3. LISTA DE TAREAS

### 3.1 Tareas de QA

* [ ] Revisar que el requirement y la spec mantengan el mismo alcance funcional
* [ ] Confirmar que el flujo sea estrictamente secuencial y dependiente del mismo `petId`
* [ ] Confirmar que no se agregaron endpoints fuera del alcance
* [ ] Confirmar que no se asumió cleanup por delete
* [ ] Confirmar que la validación por status se basa en presencia dentro del resultado
* [ ] Tratar cualquier status code no confirmado como **to validate during implementation**
* [ ] Ejecutar `/gherkin-case-generator petstore-exercise-2`
* [ ] Ejecutar `/risk-identifier petstore-exercise-2`

### 3.2 Tareas de automatización Karate

* [ ] Crear `src/test/java/karate-config.js`
* [ ] Crear `src/test/java/runners/ChallengeTest.java`
* [ ] Crear `src/test/java/petstore/petstore-pet-lifecycle.feature`
* [ ] Implementar FR-01 para agregar mascota
* [ ] Capturar y reutilizar el mismo `petId`
* [ ] Implementar FR-02 para consultar por ID
* [ ] Implementar FR-03 para actualizar nombre y estado a `sold`
* [ ] Implementar FR-04 para consultar por `status=sold`
* [ ] Validar que la mascota actualizada esté presente en el resultado del filtro
* [ ] Parametrizar `baseUrl`
* [ ] Usar datos dinámicos para evitar colisiones
* [ ] Generar reportes en `target/karate-reports/`

### 3.3 Tareas de documentación

* [ ] Crear `readme.txt` con pasos de ejecución
* [ ] Incluir prerequisitos de ejecución
* [ ] Incluir comando de ejecución del proyecto
* [ ] Indicar la ubicación de los reportes
* [ ] Crear `conclusiones.txt` con hallazgos y conclusiones
* [ ] Preparar el contenido del repositorio para revisión pública

### 3.4 Tareas de ejecución y validación

* [ ] Ejecutar la suite localmente
* [ ] Confirmar que el flujo completo se ejecuta sin romper la secuencia de datos
* [ ] Capturar evidencia de requests, responses y validaciones
* [ ] Confirmar que los entregables requeridos están incluidos
* [ ] Cambiar `status: DRAFT` a `status: APPROVED` cuando la spec quede validada
* [ ] Continuar con implementación una vez aprobada la spec
* [ ] Publicar la solución final en un repositorio GitHub público

---

## 4. ENTREGABLES

Los entregables esperados para el reto son:

* automatización reproducible con Karate
* archivos fuente necesarios para ejecución
* reportes de ejecución
* `readme.txt`
* `conclusiones.txt`
* repositorio GitHub público

---

## 5. LIMITACIONES Y CONSIDERACIONES

* El ambiente es público y compartido.
* Puede existir interferencia por datos creados por terceros.
* El requirement no fija schemas exactos ni status codes exactos.
* La implementación debe distinguir entre:

  * lo requerido por el ejercicio
  * lo observado durante ejecución
  * lo opcional o candidate
* Cualquier hallazgo observable del comportamiento real debe documentarse en `conclusiones.txt` o en la implementación, sin convertirlo retroactivamente en requisito original del reto.

---

**Fin de la especificación**

```
```
