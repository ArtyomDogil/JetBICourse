@isTest
private with sharing class BaseStationFlowTest {
    @isTest
    static void changinBSStatusOnInactive(){
        Base_Station__c changingBS = TestFactory.getBaseStations(1, 'Broken Base Station', 'Broken', true).get(0);
        List<Sensor__c> checkingSensors= TestFactory.getSensorsWithoutBaseStation(2, 'Inactive Sensor', 'Inactive', false);
        checkingSensors.addAll(TestFactory.getSensorsWithoutBaseStation(3, 'Active Sensor', 'Active', false));
        if (checkingSensors.size() > 0){
            for(Sensor__c s : checkingSensors){
                s.Base_Station__c = changingBS.Id;
            }
        }
        Insert checkingSensors;
        checkingSensors = [SELECT Base_Station__c,
                             	  Sensor_model__c,
                                  Status__c
                           FROM Sensor__c
                           WHERE Base_Station__c = :changingBS.Id AND Status__c = 'Active'];
        System.assertEquals(3, checkingSensors.size(), 'Expected test to find a 3 Sensors');                     
        changingBS.Status__c = 'Inactive';
        update changingBS;
        checkingSensors = [SELECT Base_Station__c,
                             	  Sensor_model__c,
                                  Status__c
                           FROM Sensor__c
                           WHERE Base_Station__c = :changingBS.Id AND Status__c = 'Inactive'];
        System.assertEquals(5, checkingSensors.size(), 'Expected test to find a 5 Sensors');
    }
    @isTest
    static void changinBSStatusOnBroken(){
        Base_Station__c changingBS = TestFactory.getBaseStations(1, 'Active Base Station', 'Active', true).get(0);
        List<Sensor__c> checkingSensors= TestFactory.getSensorsWithoutBaseStation(2, 'Inactive Sensor', 'Inactive', false);
        checkingSensors.addAll(TestFactory.getSensorsWithoutBaseStation(3, 'Active Sensor', 'Active', false));
        if (checkingSensors.size() > 0){
            for(Sensor__c s : checkingSensors){
                s.Base_Station__c = changingBS.Id;
            }
        }
        Insert checkingSensors;
        checkingSensors = [SELECT Base_Station__c,
                             	  Sensor_model__c,
                                  Status__c
                           FROM Sensor__c
                           WHERE Base_Station__c = :changingBS.Id AND Status__c = 'Active'];
        System.assertEquals(5, checkingSensors.size(), 'Expected test to find a 5 Sensors');                     
        changingBS.Status__c = 'Broken';
        update changingBS;
        checkingSensors = [SELECT Base_Station__c,
                             	  Sensor_model__c,
                                  Status__c
                           FROM Sensor__c
                           WHERE Base_Station__c = null AND Status__c = 'Inactive'];
        System.assertEquals(5, checkingSensors.size(), 'Expected test to find a 5 Sensors');
    }
}