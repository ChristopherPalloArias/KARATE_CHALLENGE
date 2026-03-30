#language: en
@petstore @exercise-2 @pet-lifecycle
Feature: PetStore API — Pet Lifecycle Automation

  Background:
    * url baseUrl
    * def executionId = java.lang.System.currentTimeMillis()
    * def basePetId = 1000000000 + executionId
    * def initialPetName = 'TestPet_' + executionId
    * def updatedPetName = 'UpdatedPet_' + executionId
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * def photoUrls = ['https://example.com/photo.jpg']

  # ============================================================================
  # HU-01: Create Pet
  # ============================================================================

  @smoke @critical @hu-01
  Scenario: SC-1.1 - Create pet successfully and capture petId

    Given path '/pet'
    * def requestPayload = { id: basePetId, name: initialPetName, status: 'available', photoUrls: photoUrls }
    And request requestPayload
    
    When method POST
    
    Then status 200
    And assert response.id != null
    And assert response.id == basePetId
    And assert response.name == initialPetName
    And assert response.status == 'available'
    * def petId = response.id
    * karate.log('INFO: Pet created with petId=' + petId)


  @edge-case @hu-01
  Scenario: SC-1.2 - Captured petId is reusable across subsequent operations

    # Precondition: SC-1.1 executed (petId captured)
    # This scenario validates that the captured petId from SC-1.1 is reusable
    
    Given assert petId != null
    And assert typeof petId == 'number'
    And assert petId > 0
    
    Then match petId == basePetId
    * karate.log('INFO: petId is reusable: ' + petId)


  # ============================================================================
  # HU-02: Retrieve Pet by ID
  # ============================================================================

  @smoke @critical @hu-02
  Scenario: SC-2.1 - Retrieve pet by ID successfully

    # Precondition: SC-1.1 executed, petId available
    Given path '/pet', petId
    
    When method GET
    
    Then status 200
    And assert response.id != null
    And assert response.id == petId
    And assert response.name == initialPetName
    And assert response.status == 'available'
    * karate.log('INFO: Pet retrieved by ID, consistency verified')


  @error-path @hu-02
  Scenario: SC-2.2 - Handle non-existent petId gracefully

    Given path '/pet', 999999999
    
    When method GET
    
    Then status 404
    * karate.log('INFO: 404 returned for non-existent petId as expected')


  # ============================================================================
  # HU-03: Update Pet Name and Status
  # ============================================================================

  @smoke @critical @hu-03
  Scenario: SC-3.1 - Update pet name and status to sold

    # Precondition: SC-1.1 and SC-2.1 executed, petId available
    Given path '/pet'
    * def updatePayload = { id: petId, name: updatedPetName, status: 'sold', photoUrls: photoUrls }
    And request updatePayload
    
    When method PUT
    
    Then status 200
    And assert response.id != null
    And assert response.id == petId
    And assert response.name == updatedPetName
    And assert response.status == 'sold'
    * karate.log('INFO: Pet updated successfully, status set to sold')


  @edge-case @hu-03
  Scenario: SC-3.2 - Verify updated status is exactly 'sold'

    # Precondition: SC-3.1 executed
    Given assert response.status != null
    
    When evaluate script
    
    Then assert response.status == 'sold'
    And assert typeof response.status == 'string'
    And assert response.status.length() > 0
    * karate.log('INFO: Status validation successful: ' + response.status)


  # ============================================================================
  # HU-04: Retrieve Pets by Status
  # ============================================================================

  @smoke @critical @hu-04
  Scenario: SC-4.1 - Retrieve pets filtered by status sold and verify presence

    # Precondition: SC-3.1 executed, pet has status 'sold'
    Given path '/pet/findByStatus'
    And param status = 'sold'
    
    When method GET
    
    Then status 200
    And assert response != null
    And assert typeof response == 'array'
    And assert response.length > 0
    * def foundPet = null
    * foreach item in response
      * if item.id == petId
        * def foundPet = item
    And assert foundPet != null
    And assert foundPet.status == 'sold'
    And assert foundPet.name == updatedPetName
    * karate.log('INFO: Pet found in filtered results by status')
    * karate.log('INFO: Found pet - ID: ' + foundPet.id + ', Name: ' + foundPet.name + ', Status: ' + foundPet.status)


  @edge-case @hu-04
  Scenario: SC-4.2 - Verify consistency of pet data in filtered results

    # Precondition: SC-4.1 executed, foundPet available
    Given assert foundPet != null
    
    When evaluate assertions
    
    Then assert foundPet.id == petId
    And assert foundPet.name == updatedPetName
    And assert foundPet.status == 'sold'
    And assert foundPet.id != null
    And assert foundPet.name != null
    And assert foundPet.status != null
    * karate.log('INFO: All consistency checks passed for found pet')
    * karate.log('INFO: Final state - ID: ' + foundPet.id + ', Name: ' + foundPet.name + ', Status: ' + foundPet.status)
