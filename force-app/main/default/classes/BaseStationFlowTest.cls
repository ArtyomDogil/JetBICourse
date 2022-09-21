@isTest
private with sharing class BaseStationFlowTest {
    @isTest
    static void changeStatusOfBaseStationOnInactive() {
        TestFactory.getSensorsWithBaseStation(5, 'model x2', 'Active', 'Parking place 1', 'Active', true);
        Base_Station__c changingBS = [SELECT Id,
                                             Name,
                                             Status__c 
                                      FROM Base_Station__c
                                      WHERE Status__c = 'Active' 
                                      LIMIT 1];
        List<Sensor__c> checkingSensors = [SELECT Id,
                                                  Name,
                                                  Base_Station__c,
                                                  Status__c,
                                                  Sensor_model__c
                                           FROM Sensor__c
                                           WHERE Base_Station__c = :changingBS.Id];
        System.debug('changingBS: ' + changingBS);
        System.debug('checkingSensors size: ' + checkingSensors.size());
        System.debug('checkingSensors.get(0): ' + checkingSensors.get(0));
        /*List<Account> accts = new List<Account>();
        Test.startTest();
        accts = [SELECT Id FROM Account];
        Test.stopTest();
        System.assert(accts.size() > 0, 'Was expecting to find at least one account');*/
    }
}
