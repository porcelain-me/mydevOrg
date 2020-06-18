@isTest
private class AnimalLocatorTest {

    @isTest static  void testGetCallout() {
        // Create the mock response based on a static resource
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
      AnimalLocator obj01 = new AnimalLocator();
    AnimalLocator.getAnimalNameById(2);
    }
}