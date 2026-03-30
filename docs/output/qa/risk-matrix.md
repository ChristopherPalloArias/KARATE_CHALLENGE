# Matriz de Riesgos — petstore-exercise-2

**Especificación:** [.github/specs/petstore-exercise-2.spec.md]  
**Gherkin:** [docs/output/qa/petstore-exercise-2-gherkin.md]  
**Generado:** 2026-03-30  

---

## Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| **Total de Riesgos Identificados** | 11 |
| **Riesgos ALTO (A)** | 2 |
| **Riesgos MEDIO (S)** | 6 |
| **Riesgos BAJO (D)** | 3 |
| **Riesgos Bloqueantes** | 2 |

---

## Matriz de Riesgos Detallada

| ID | HU/FR | Descripción del Riesgo | Factores de Riesgo | Nivel ASD | Testing Requerido | Bloqueante |
|----|----|-----------|--------|--------|-------------|-----------|
| **R-001** | HU-01, FR-01 | Colisión de `petId` en ambiente público compartido | Ambiente compartido, datos dinámicos, interferencia de terceros | **A (ALTO)** | Obligatorio | ✅ Sí |
| **R-002** | HU-01→HU-04 | `petId` no reutilizable entre operaciones secuenciales | Dependencia crítica, flujo secuencial lineal, sin mecanismo de fallback | **A (ALTO)** | Obligatorio | ✅ Sí |
| **R-003** | HU-02, FR-02 | Integración con API PetStore externa no bajo nuestro control | Servicio externo, disponibilidad no garantizada, SLA desconocido | **S (MEDIO)** | Recomendado | ❌ No |
| **R-004** | HU-03, FR-03 | Actualización parcial o no persistida en ambiente inconsistente | Ambiente compartido, operación PUT sin garantía ACID, datos en transición | **S (MEDIO)** | Recomendado | ❌ No |
| **R-005** | FR-01, FR-02, FR-03, FR-04 | Contract desconocido: status codes exactos no confirmados por requirement | Spec marca como "to validate during implementation", ambigüedad de contract | **S (MEDIO)** | Recomendado | ❌ No |
| **R-006** | HU-04, FR-04 | Mascota no aparece en resultado filtrado por status `sold` | Lógica de búsqueda, filtrado en servidor, respuesta puede estar vacía o inconsistente | **S (MEDIO)** | Recomendado | ❌ No |
| **R-007** | HU-03, FR-03 | Nombre y status actualizados no reflejados en siguiente consulta | Persistencia de datos, consistencia eventual, latencia en actualización | **S (MEDIO)** | Recomendado | ❌ No |
| **R-008** | SC-2.2 (Error Path) | Gestión inadecuada de petId inexistente (404 vs otros errores) | Error handling, respuesta inesperada, impacto en validación de escenarios posteriores | **D (BAJO)** | Opcional | ❌ No |
| **R-009** | HU-01, FR-01 | Payload malformado o incompleto rechazado por API | Formato JSON, campos obligatorios variables, esquema no documentado | **D (BAJO)** | Opcional | ❌ No |
| **R-010** | Todos | Performance: latencia acumulada en 4 operaciones secuenciales | SLA desconocido, timeout posible, impacto en reportabilidad | **D (BAJO)** | Opcional | ❌ No |
| **R-011** | HU-04, FR-04 | Array vacío o con múltiples registros en resultado filtrado | Lógica de búsqueda, unicidad de resultados desconocida, validación must handle both | **D (BAJO)** | Opcional | ❌ No |

---

## Plan de Mitigación — Riesgos ALTO (Bloqueantes)

### R-001: Colisión de `petId` en ambiente público compartido

**Descripción:**  
La API PetStore es un ambiente público compartido donde múltiples usuarios ejecutan tests simultáneamente. Un `petId` estático causaría colisión y fallos reproducibl es. La generación dinámica es crítica para garantizar unicidad.

**Factores de Riesgo:**
- Ambiente compartido (no aislado)
- Sin control sobre datos de terceros
- Interferen cia potencial con otras ejecuciones

**Nivel Justificado:** ALTO  
→ Impide reproducibilidad  
→ Causa fallos no determinísticos  
→ Bloquea validación del ciclo de vida

**Mitigación Técnica:**
- ✅ Usar `EXECUTION_ID = System.currentTimeMillis() + random(1000, 9999)`
- ✅ Generar `petId = 1000000000 + EXECUTION_ID` para evitar colisión
- ✅ Usar nombres dinámicos: `TestPet_${EXECUTION_ID}`, `UpdatedPet_${EXECUTION_ID}`
- ✅ Registrar valores dinámicos en reportes para trazabilidad
- ✅ Validar en cada ejecución que `petId` es único

**Tests Obligatorios:**
1. **SC-1.1** — Verificar que petId se genera dinámicamente sin hardcoding
2. **SC-1.2** — Verificar que petId capturado es diferente entre ejecuciones separadas
3. **Retest Security** — Ejecutar 2+ veces y confirmar que no hay colisiones

**Evidencia de Mitigación:**
- Variables en Background: `def executionId = System.currentTimeMillis();`
- Validación: `basePetId != last_execution_basePetId`

**Bloqueante para Release:** ✅ SÍ

---

### R-002: `petId` no reutilizable entre operaciones secuenciales

**Descripción:**  
El flujo tiene dependencia lineal estricta: HU-01 genera `petId` → HU-02 lo reutiliza → HU-03 lo reutiliza → HU-04 lo busca. Si el `petId` no es reutilizable correctamente, toda la cadena falla. No hay mecanismo de fallback.

**Factores de Riesgo:**
- Flujo secuencial sin paralelización
- Dependencia crítica entre pasos
- Sin estado compartido garantizado en Karate entre escenarios

**Nivel Justificado:** ALTO  
→ Si falla, es un bloqueo del 100%  
→ No hay workaround  
→ Invalida el ciclo de vida completo

**Mitigación Técnica:**
- ✅ Ejecutar todos los 4 escenarios en un ÚNICO Feature File (no separados)
- ✅ Usar variable global `* def petId` en Background + captura en SC-1.1
- ✅ Reutilizar `petId` en SC-2.1, SC-3.1, SC-4.1 sin redefinirlo
- ✅ Validar que `response.id == petId` en cada paso para certificar consistencia
- ✅ Detener la ejecución si algún paso devuelve petId ≠ esperado

**Tests Obligatorios:**
1. **SC-1.1** — Capturar `petId = response.id` explícitamente
2. **SC-1.2** — Verificar que `petId` es reutilizable (tipo numérico, > 0)
3. **SC-2.1** — Assert `response.id == petId` (identidad verificada)
4. **SC-3.1** — Enviar el mismo `petId` en PUT y confirmar en response
5. **SC-4.1** — Buscar `petId` en array y confirmar presencia
6. **End-to-End Trace** — Registrar petId en cada paso e imprimir en reportes

**Evidencia de Mitigación:**
- Log de salida: `petId_from_CREATE: 1020260330093000, petId_in_READ: 1020260330093000, petId_in_UPDATE: 1020260330093000, petId_in_FILTER_result: FOUND`
- Assertions explícitas: `And match response.id == petId`

**Bloqueante para Release:** ✅ SÍ

---

## Plan de Mitigación — Riesgos MEDIO (Recomendados)

### R-003: Integración con API PetStore externa no bajo nuestro control

**Descripción:**  
La API PetStore está alojada en `https://petstore.swagger.io/v2`, un servicio público externo. No controlamos su uptime, SLA, o cambios de versión. Cualquier dowtime causa fallo de tests.

**Mitigation Técnica:**
- ✅ Documentar la URL y versión del API (`v2`) en `readme.txt`
- ✅ Validar disponibilidad en CI: verificar endpoint /pet antes de ejecutar suite
- ✅ Usar timeout configurable: `connectTimeout: 5000, readTimeout: 5000`
- ⚠️ Retry logic opcional: re-intentar 1-2 veces si timeout

**Tests Recomendados:**
1. **Smoke Test Pre-Suite** — GET /pet/1 debe responder 200 o 404 (ambos indica disponibilidad)
2. **Timeout Validation** — Confirmar que requests responden en < 5s
3. **Error Handling** — Capturar 503, 502 y registrar en conclusiones.txt

---

### R-004: Actualización parcial o no persistida en ambiente inconsistente

**Descripción:**  
La API puede tomar tiempo en persistir la actualización, o la actualización puede ser parcial. HU-04 (GET /pet/findByStatus) puede no ver la mascota actualizada inmediatamente.

**Mitigation Técnica:**
- ✅ Agregar delay corto (~200-500ms) después de PUT antes de GET /findByStatus
- ✅ Validar en SC-3.2 que `response.status == 'sold'` inmediatamente en response del PUT
- ✅ Validar en SC-4.2 que el registro encontrado tiene datos actualizados (no stale)

**Tests Recomendados:**
1. **SC-3.2** — Buscar exactitud: `response.status == 'sold'` en PUT response
2. **SC-4.1** — Buscar presencia: `response[*].find(item => item.id == petId) != null`
3. **SC-4.2** — Buscar consistencia: `found_item.name == updatedPetName` Y `found_item.status == 'sold'`

---

### R-005: Contract desconocido: status codes exactos no confirmados

**Descripción:**  
El requirement marca varios status codes como "to validate during implementation". No sabemos si es 200 u otro código para create, update, etc.

**Mitigation Técnica:**
- ✅ Documentar valores observados en `conclusiones.txt`
- ✅ Assert flexible: `Then status 200` u observar el status real
- ✅ Registrar en evidencia: "Observed: POST /pet returned 200, expected per PetStore Swagger: [link]"

**Tests Recomendados:**
1. **Assertion Flexible** — Capturar `karate.response.status` y comparar contra expectativa
2. **Documentation** — Recopilr status codes observados en conclusiones

---

### R-006: Mascota no aparece en resultado filtrado por status `sold`

**Descripción:**  
HU-04 busca `status=sold` y espera encontrar la mascota actualizada. La mascota podría no estar en el resultado si:
- Filtro en servidor no está actualizado
- Array vacío devuelto
- Mascota bajo otro ID

**Mitigation Técnica:**
- ✅ SC-4.1 debe buscar presencia, no asumir unicidad: `response[*].find(pet => pet.id == petId)`
- ✅ SC-4.2 debe validar consistencia exacta del registro encontrado

**Tests Recomendados:**
1. **SC-4.1** — `And match response[*].id contains petId`
2. **SC-4.2** — Extraer registro: `def found = response[*].find(pet => pet.id == petId); And assert found != null`

---

### R-007: Nombre y status actualizados no reflejados en siguiente consulta

**Descripción:**  
Zwischen PUT (HU-03) y siguiente GET (HU-04), la actualización podría no estar persistida o visible.

**Mitigation Técnica:**
- ✅ SC-4.2 valida nombre y status exactos del registro encontrado
- ✅ Agregar delay si es necesario

---

## Plan de Mitigación — Riesgos BAJO (Opcionales)

### R-008: Gestión inadecuada de petId inexistente (Error Path SC-2.2)

**Focus:**
- Assert: `Then status 404`
- Validar mensaje de error si existe
- Cliente se recupera gracefully

**Tests Opcionales:**
- **SC-2.2** — Error path (ya incluido en Gherkin)

---

### R-009: Payload malformado o incompleto

**Focus:**
- Validar estructura mínima de payload en creación
- Registrar campos en conclusiones

**Tests Opcionales:**
- Payload validation scenarios (no solicitado por requirement)

---

### R-010: Performance

**Focus:**
- Tiempo total de ejecución del ciclo completo
- No hay SLA especificado

**Tests Opcionales:**
- Capture response times y registrar en conclusiones

---

### R-011: Array vacío o con múltiples registros en resultado filtrado

**Focus:**
- SC-4.1 maneja correctamente arrays de cualquier tamaño
- SC-4.2 busca presencia, no unicidad

---

## Matriz de Control — Mitigación por Escenario

| Escenario | R-001 | R-002 | R-003 | R-004 | R-005 | R-006 | R-007 | Estado |
|-----------|-------|-------|-------|-------|-------|-------|-------|--------|
| SC-1.1 | ✅ Dinámico | ✅ Captura | ✅ Call | ⚪ N/A | ⚪ Observe | ⚪ N/A | ⚪ N/A | **CRÍTICO** |
| SC-1.2 | ✅ Valida | ✅ Reutilizable | ✅ Call | ⚪ N/A | ⚪ Observe | ⚪ N/A | ⚪ N/A | Mitigante |
| SC-2.1 | ⚪ Call | ✅ Reuso | ✅ Call | ⚪ N/A | ⚪ Observe | ⚪ N/A | ⚪ N/A | **CRÍTICO** |
| SC-2.2 | ⚪ N/A | ⚪ N/A | ✅ Call | ⚪ N/A | ⚪ Observe | ⚪ N/A | ⚪ N/A | Error Path |
| SC-3.1 | ⚪ Call | ✅ Reuso | ✅ Call | ✅ Valida | ⚪ Observe | ⚪ N/A | ⚪ N/A | **CRÍTICO** |
| SC-3.2 | ⚪ N/A | ⚪ N/A | ✅ Call | ✅ Valida Exacto | ⚪ Observe | ⚪ N/A | ⚪ N/A | Mitigante |
| SC-4.1 | ⚪ Call | ✅ Reuso | ✅ Call | ⚠️ Delay | ⚪ Observe | ✅ Busca Presencia | ✅ Valida | **CRÍTICO** |
| SC-4.2 | ⚪ N/A | ⚪ N/A | ✅ Call | ✅ Encontrado | ⚪ Observe | ✅ Found Item | ✅ Exacto | Mitigante |

**Leyenda:**
- ✅ = Mitigación activa (control implementado)
- ⚪ = N/A o call pasivo (hacer el call de todas formas)
- ⚠️ = Mejora opcional (agregar delay si falla)

---

## Clasificación ASD — Resumen de Testeos

```
ALTO (A): 2 Riesgos bloqueantes
├─ R-001: Mitigado con EXECUTION_ID dinámico
├─ R-002: Mitigado con una única feature file + variable global petId
└─ Tests obligatorios: SC-1.1, SC-1.2, SC-2.1, SC-3.1, SC-4.1

MEDIO (S): 6 Riesgos recomendados
├─ R-003/R-004/R-005/R-006/R-007: Mitigados en tests específicos de escenarios
├─ R-003: Call a API externa (documentado en conclusiones)
├─ R-004: Validación de persistencia en SC-3.2, SC-4.2
├─ R-005: Observe y documente status codes
├─ R-006/R-007: SC-4.1, SC-4.2 validan presencia y exactitud
└─ Tests recomendados: SC-1.2, SC-2.2, SC-3.2, SC-4.2

BAJO (D): 3 Riesgos opcionales
├─ R-008: SC-2.2 (error path)
├─ R-009: Optional payload validation
├─ R-010, R-011: Performance y array handling
└─ Tests opcionales: Casos negativos adicionales (no en scope inicial)
```

---

## Entregables por Fase

### Fase QA (Actual)
- ✅ Gherkin cases generado: `docs/output/qa/petstore-exercise-2-gherkin.md`
- ✅ Risk matrix generado: `docs/output/qa/risk-matrix.md` (este archivo)

### Fase Implementación (Próxima)
- [ ] Feature file: `src/test/java/petstore/petstore-exercise-2.feature` (8 escenarios)
- [ ] Payloads: `src/test/java/common/payloads/pet-create.json`, `pet-update.json`
- [ ] Schemas: `src/test/java/common/schemas/pet-response.json`

### Fase Ejecución
- [ ] Reportes: `target/karate-reports/`
- [ ] `readme.txt`: pasos de ejecución
- [ ] `conclusiones.txt`: hallazgos observados

---

## Criterios de Aprobación

| Criterio | Validación |
|----------|-----------|
| R-001 Mitigado | ✅ EXECUTION_ID dinámico en logs + 2+ ejecuciones sin colisión |
| R-002 Mitigado | ✅ Feature file único, variable petId reutilizado, trace end-to-end |
| Riesgos ALTO ejecutados | ✅ SC-1.1, SC-2.1, SC-3.1, SC-4.1 en suite |
| Riesgos MEDIO ejecutados | ✅ SC-1.2, SC-2.2, SC-3.2, SC-4.2 en suite |
| Conclusiones documentadas | ✅ Status codes, observaciones, hallazgos |
| Suite reproducible | ✅ Sin hardcoding, todo configurable, sin dependencias locales |

---

**Fin de Matriz de Riesgos**
