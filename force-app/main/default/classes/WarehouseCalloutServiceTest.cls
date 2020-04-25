@IsTest
private class WarehouseCalloutServiceTest {
	@isTest static void testGetCallout() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseCalloutService.runWarehouseEquipmentSync();   
    }
}