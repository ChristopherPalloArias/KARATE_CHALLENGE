# PetStore API Automation Exercise 2 Requirement

## 1. Challenge Metadata

- **Requirement file name:** `petstore-pet-lifecycle-challenge.md`
- **Feature name:** `petstore-pet-lifecycle-challenge`
- **Challenge name:** PetStore API Automation Exercise 2
- **Document type:** Requirement
- **Document status:** Ready for Specification
- **Source of instructions:** User-provided Exercise 2 statement
- **Preferred automation tool:** Karate
- **Prepared for:** ASDD spec-generation flow
- **Version:** 1.0.0
- **Date:** 2026-03-30

---

## 2. Challenge Overview

- **Objective:** Automate the required PetStore API lifecycle flow for a single pet entity.
- **Business goal:** Demonstrate REST API automation capability with reproducible execution evidence.
- **Expected deliverable:** Public GitHub repository containing automation assets, reports, execution instructions, and conclusions.
- **Primary focus:** Functional API validation of the requested lifecycle.
- **Secondary focus:** Variable capture, request/response evidence, and reproducibility.
- **Success definition:** A reviewer can clone the repository, execute the tests, inspect the reports, and verify the requested lifecycle flow end-to-end.

---

## 3. Exercise Context

The exercise requires using a REST API testing tool, preferably Karate, against the PetStore API documentation available at `https://petstore.swagger.io/`.

The requested validations are:

1. Add a pet to the store.
2. Retrieve the previously created pet by ID.
3. Update the pet name and change the pet status to `sold`.
4. Retrieve the modified pet by status.

The repository must also include:

- `readme.txt` with step-by-step execution instructions.
- `conclusiones.txt` with findings and conclusions from the exercise.

---

## 4. API Context

- **System under test:** PetStore API
- **API documentation source:** `https://petstore.swagger.io/`
- **Candidate base URL:** `https://petstore.swagger.io/v2`
- **API style:** REST
- **Authentication required:** [Not provided]
- **Environment type:** Public shared environment
- **Environment notes:** Shared public data may affect searches and repeated executions.
- **Known dependencies:** Internet access
- **External systems involved:** Public PetStore environment

---

## 5. Environment and Configuration Inputs

- **Required runtime inputs:** `baseUrl`
- **Expected configuration style:** Runtime-configurable base URL
- **Candidate global headers:**
  - `Content-Type: application/json`
  - `Accept: application/json`
- **Timeout considerations:** [Not provided]
- **Retry considerations:** [Not provided]
- **Proxy considerations:** [Not provided]
- **SSL considerations:** [Not provided]

### Configuration Notes

- The implementation should avoid hardcoding the base URL.
- The solution should support reproducible execution in another machine without manual code changes.
- Shared-environment data collisions must be mitigated through unique test data.

---

## 6. Authentication and Authorization

- **Authentication flow:** [Not provided]
- **Credentials required:** [Not provided]
- **Authorization model:** [Not provided]
- **Reusable auth setup needed:** No evidence of this requirement in the exercise statement.
- **Open auth concerns:** None explicitly stated.

---

## 7. Endpoints in Scope

| Requirement ID | Method | Endpoint | Purpose | Dependency |
|---|---|---|---|---|
| FR-01 | POST | `/pet` | Add a new pet | None |
| FR-02 | GET | `/pet/{petId}` | Retrieve created pet by ID | FR-01 |
| FR-03 | PUT | `/pet` | Update existing pet | FR-01 / FR-02 |
| FR-04 | GET | `/pet/findByStatus` | Retrieve pets by status | FR-03 |

---

## 8. Endpoint Details

### FR-01 — POST `/pet`

- **Purpose:** Add a pet to the store.
- **Preconditions:** None.
- **Headers:** `Content-Type: application/json`
- **Path params:** None
- **Query params:** None
- **Request body:** Valid pet payload for a single test pet entity.
- **Primary validation targets:**
  - Request executes successfully.
  - Response confirms the created pet data.
  - The `petId` used for the lifecycle is confirmed and reused later.
- **Success response status:** [To validate during implementation]
- **Error response status:** [Not provided]
- **Schema expectations:** [Not provided]
- **Notes:** Prefer a unique caller-controlled `petId` to reduce collision risk in the shared environment.

### FR-02 — GET `/pet/{petId}`

- **Purpose:** Retrieve the same pet created in FR-01.
- **Preconditions:** FR-01 executed successfully.
- **Headers:** `Accept: application/json`
- **Path params:** `petId`
- **Query params:** None
- **Request body:** None
- **Primary validation targets:**
  - The same `petId` is used.
  - Returned pet matches the created entity.
  - Response is consistent with the data used in FR-01.
- **Success response status:** [To validate during implementation]
- **Error response status:** [Not provided]
- **Schema expectations:** [Not provided]

### FR-03 — PUT `/pet`

- **Purpose:** Update the same pet, changing name and status to `sold`.
- **Preconditions:** Target pet exists.
- **Headers:** `Content-Type: application/json`
- **Path params:** None
- **Query params:** None
- **Request body:** Updated pet payload for the same entity.
- **Primary validation targets:**
  - Request targets the same pet from FR-01.
  - Response reflects the updated name.
  - Response reflects status `sold`.
- **Success response status:** [To validate during implementation]
- **Error response status:** [Not provided]
- **Schema expectations:** [Not provided]

### FR-04 — GET `/pet/findByStatus`

- **Purpose:** Retrieve pets filtered by status.
- **Preconditions:** FR-03 executed successfully.
- **Headers:** `Accept: application/json`
- **Path params:** None
- **Query params:** `status=sold`
- **Request body:** None
- **Primary validation targets:**
  - Query uses `status=sold`.
  - Returned result set contains the updated pet.
  - Returned data reflects the updated state of the same pet entity.
- **Success response status:** [To validate during implementation]
- **Error response status:** [Not provided]
- **Schema expectations:** Array response expected by flow intent; exact schema is [Not provided].
- **Notes:** Assertions should validate target pet presence, not assume result exclusivity.

---

## 9. Functional Expectations

### Required Lifecycle Flow

1. Create a pet using a valid request body.
2. Confirm and capture the same `petId` used for the flow.
3. Retrieve the same pet by ID.
4. Update the same pet, changing:
   - the pet name
   - the pet status to `sold`
5. Retrieve pets filtered by `sold`.
6. Verify that the updated pet appears in the filtered results.

### Required Validation Targets

The automation must validate, at minimum:

- successful request execution for each required step
- correct chaining of variables across the flow
- consistency of `petId` across create, retrieve, and update operations
- correct retrieval of the created pet by ID
- correct update of pet name
- correct update of pet status to `sold`
- visibility of the updated pet in the `sold` query results

---

## 10. Negative and Edge Cases

### Confirmed Negative and Edge Cases
[Not explicitly requested by the exercise]

### Candidate Negative and Edge Cases for Optional Validation

- retrieve non-existent pet by ID
- update pet with invalid or incomplete body
- create pet with invalid payload structure
- search by status and validate behavior when multiple pets share the same status
- validate behavior if the public shared environment contains conflicting data

### Notes

These are optional improvements only. They must not replace or delay the four required lifecycle validations.

---

## 11. Contract / Schema Validation Expectations

- **Required schema validation:** Optional unless implementation decides to formalize the Pet schema.
- **Required field-level validation candidates:**
  - `id`
  - `name`
  - `status`
- **Response-body strictness:** Conservative field-level validation is sufficient if full schema contract is not stabilized during implementation.
- **Mandatory field checks:** [Not fully provided by the exercise]
- **Array validation expectations:** For `findByStatus`, validate that the expected pet exists in the array response.

---

## 12. Test Data Strategy

### Required Dynamic Variables

- `petId`
- initial pet name
- updated pet name
- initial pet status
- updated pet status

### Test Data Rules

- Use unique or dynamic values for `petId`.
- Preserve the same `petId` across FR-01 to FR-04.
- Use a valid initial status before update.
- Use `sold` as the final status because it is explicitly required.
- Avoid static identifiers that may collide in a shared public environment.

### Data Capture Rules

- Capture request inputs and relevant outputs.
- Reuse the same pet entity across the full lifecycle.
- Keep traceability between request payloads and response validations.

---

## 13. Scenario Dependencies

### Execution Order

1. FR-01 → Add pet  
2. FR-02 → Retrieve pet by ID  
3. FR-03 → Update pet name and status  
4. FR-04 → Retrieve updated pet by status  

### Dependency Notes

- FR-02 depends on data produced by FR-01.
- FR-03 depends on the pet created earlier in the flow.
- FR-04 depends on the updated status from FR-03.
- The lifecycle is sequential and data-dependent.

### Parallel Execution Considerations

- Parallel execution is not recommended for the primary flow.
- Shared environment plus data dependencies increase collision risk if parallelized carelessly.

---

## 14. Setup Requirements

- Java runtime compatible with Karate execution
- Maven available for local execution
- Internet access to the public PetStore environment
- Local environment capable of generating reports

### Candidate Local Execution Command

- `mvn test`

### Additional Execution Note

Detailed execution instructions must be documented in `readme.txt`.

---

## 15. Cleanup Requirements

- Cleanup is **not mandatory** because pet deletion is not requested in the exercise.
- The implementation may leave created or updated data in the shared environment.
- Optional cleanup, if added, must be treated as enhancement work outside the required flow.

---

## 16. Acceptance Criteria

- [ ] The automation covers the four requested PetStore operations.
- [ ] A pet is added successfully.
- [ ] The created pet is retrieved successfully by ID.
- [ ] The pet name is updated successfully.
- [ ] The pet status is updated successfully to `sold`.
- [ ] The updated pet is retrievable through the status-based query.
- [ ] The solution is reproducible by a reviewer.
- [ ] The GitHub repository is public.
- [ ] `readme.txt` is included with step-by-step execution instructions.
- [ ] `conclusiones.txt` is included with findings and conclusions.
- [ ] Reports or reproducible evidence are included in the repository.

---

## 17. Risks and Constraints

### Constraints

- Preferred automation tool is Karate.
- Final delivery must be uploaded to a public GitHub repository.
- Reviewer must be able to reproduce execution.
- Required plain-text support files must be included.

### Known Risks

- Shared public environment may contain data created by other users.
- Searches by `status=sold` may return many pets.
- Exact response schemas are not defined in the exercise statement.
- Exact expected HTTP status codes are not explicitly stated by the exercise.
- Public environment instability may affect reproducibility.

### Assertion Risk Notes

- Status-based assertions should validate target pet presence, not assume a single-record result set.
- Dynamic data is strongly preferred to reduce collisions.

---

## 18. Tagging and Execution Notes

### Candidate Tags for Karate Organization

- `@petstore`
- `@pet-lifecycle`
- `@sequential`
- `@smoke`

### Execution Notes

- The main lifecycle flow should run sequentially.
- The implementation should preserve variable reuse across all steps.
- The solution should capture request/response evidence sufficient for review.

---

## 19. Reporting Expectations

### Expected Evidence

- captured request details
- captured response details
- assertions for each required step
- execution outcome for the full lifecycle
- generated report artifacts from the selected tool

### Report Intent

A reviewer should be able to understand:

- what was executed
- what variables were used
- what outputs were captured
- which validations passed or failed

### Complementary Delivery Files

- `readme.txt`
- `conclusiones.txt`

---

## 20. Open Questions

- Should the implementation validate only the presence of the updated pet in the `sold` results, or also validate full object consistency there?
- Is there a preferred repository naming convention?
- Is plain-text formatting sufficient for `readme.txt` and `conclusiones.txt` as long as they are clear and reproducible?
- Should optional negative scenarios be included, or should the delivery remain strictly scoped to the four requested steps?

---

## 21. Out of Scope

- UI testing
- performance testing
- security testing
- CI/CD pipeline implementation
- GitHub Actions
- GitHub Pages
- hosted reporting
- endpoints outside the required pet lifecycle
- mandatory delete cleanup
- non-requested exploratory automation beyond clearly optional enhancements

---

## 22. Implementation Notes for Next Phase

This requirement is intended to support the next steps in the flow:

1. generate the technical specification
2. approve the generated specification
3. generate QA analysis artifacts if needed
4. implement Karate assets and feature files
5. produce repository documentation and final delivery artifacts

The implementation must distinguish clearly between:

- what is explicitly required by the exercise
- what is observed during execution
- what is optional enhancement work