#language: en
@petstore @exercise-2 @pet-lifecycle
Feature: PetStore API — Pet Lifecycle Automation

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * def photoUrls = ['https://example.com/photo.jpg']

  # ============================================================================
  # HU-01 → HU-04: Full Pet Lifecycle (sequential, data-dependent)
  # ============================================================================

  @smoke @critical @sequential
  Scenario: SC-1 - Full pet lifecycle: create, retrieve, update, and find by status

    # --- Step 1: Generate unique, collision-safe petId (8-digit safe integer) ---
    * def tsStr = java.lang.Long.toString(java.lang.System.currentTimeMillis())
    * def petId = java.lang.Integer.parseInt(tsStr.substring(tsStr.length() - 8))
    * def petName = 'TestPet_' + tsStr
    * karate.log('INFO: Using petId=' + petId + ', name=' + petName)

    # --- Step 2: Create the pet (FR-01) ---
    Given path '/pet'
    * def requestPayload = read('classpath:common/payloads/pet-create.json')
    And request requestPayload
    When method POST
    Then status 200
    And assert response.id != null
    And match response.id == petId
    And match response.name == petName
    And match response.status == 'available'
    * karate.log('INFO: Pet created with petId=' + response.id)

    # --- Step 3: Retrieve pet by ID (FR-02) ---
    Given path '/pet', petId
    When method GET
    Then status 200
    And match response.id == petId
    And match response.name == petName
    And match response.status == 'available'
    * karate.log('INFO: Pet retrieved by ID successfully')

    # --- Step 4: Update pet name and status to sold (FR-03) ---
    Given path '/pet'
    * def petName = 'UpdatedPet_' + tsStr
    * def updatePayload = read('classpath:common/payloads/pet-update.json')
    And request updatePayload
    When method PUT
    Then status 200
    And match response.id == petId
    And match response.name == petName
    And match response.status == 'sold'
    * karate.log('INFO: Pet updated - name=' + petName + ', status=sold')

    # --- Step 5: Retrieve pets by status=sold and verify presence (FR-04) ---
    Given path '/pet/findByStatus'
    And param status = 'sold'
    When method GET
    Then status 200
    And match response == '#array'
    And assert response.length > 0
    * def foundPets = karate.filter(response, function(item){ return item.id == petId })
    * def foundPet = foundPets.length > 0 ? foundPets[0] : null
    And assert foundPet != null
    And match foundPet.id == petId
    And match foundPet.name == petName
    And match foundPet.status == 'sold'
    * karate.log('INFO: Pet found in sold results - ID=' + foundPet.id + ', Name=' + foundPet.name + ', Status=' + foundPet.status)


  # ============================================================================
  # HU-02 (Edge Case): Non-existent pet returns 404
  # ============================================================================

  @edge-case @hu-02
  Scenario: SC-2 - Handle non-existent petId gracefully

    # Use an ID that is extremely unlikely to exist in the public shared environment
    * def nonExistentId = 999888777

    Given path '/pet', nonExistentId
    When method GET
    Then match responseStatus == 404 || responseStatus == 500
    * karate.log('INFO: Non-existent pet handled gracefully, status=' + responseStatus)
