@isTest
private with sharing class BaseStationFlowTest {
    @isTest
    static void assigningInactiveSensorsOnActiveBS() {
        Base_Station__c activeBaseStation = TestFactory.getBaseStations(1, 'Active Base Station', 'Active', true).get(0);
        List<Sensor__c> insertSensorsList = TestFactory.getSensorsWithoutBaseStation(2, 'Inactive Sensor', 'Inactive', false);
        insertSensorsList.addAll(TestFactory.getSensorsWithoutBaseStation(3, 'Active Sensor', 'Active', false));
        if (insertSensorsList.size() > 0){
            for(Sensor__c s : insertSensorsList){
                s.Base_Station__c = activeBaseStation.Id;
            }
        }
        Insert insertSensorsList;
        insertSensorsList = [SELECT Base_Station__c,
                             		Sensor_model__c,
                                    Status__c
                             FROM Sensor__c
                             WHERE Base_Station__c = :activeBaseStation.Id AND Status__c = 'Active'];
        System.assertEquals(5, insertSensorsList.size(), 'Expected test to find a 5 Sensors');
    }
    @isTest
    static void assigningInactiveSensorsOnInactiveBS() {
        Base_Station__c activeBaseStation = TestFactory.getBaseStations(1, 'Inactive Base Station', 'Inactive', true).get(0);
        List<Sensor__c> insertSensorsList = TestFactory.getSensorsWithoutBaseStation(2, 'Inactive Sensor', 'Inactive', false);
        insertSensorsList.addAll(TestFactory.getSensorsWithoutBaseStation(3, 'Active Sensor', 'Active', false));
        if (insertSensorsList.size() > 0){
            for(Sensor__c s : insertSensorsList){
                s.Base_Station__c = activeBaseStation.Id;
            }
        }
        Insert insertSensorsList;
        insertSensorsList = [SELECT Base_Station__c,
                             		Sensor_model__c,
                                    Status__c
                             FROM Sensor__c
                             WHERE Base_Station__c = :activeBaseStation.Id AND Status__c = 'Active'];
        System.assertEquals(3, insertSensorsList.size(), 'Expected test to find a 3 Sensors');
    }
    @isTest
    static void insertActiveSensorsWithoutBS() {
        List<Sensor__c> insertSensorsList = TestFactory.getSensorsWithoutBaseStation(2, 'Inactive Sensor', 'Inactive', false);
        insertSensorsList.addAll(TestFactory.getSensorsWithoutBaseStation(3, 'Active Sensor', 'Active', false));
        Insert insertSensorsList;
        insertSensorsList = [SELECT Base_Station__c,
                             		Sensor_model__c,
                                    Status__c
                             FROM Sensor__c
                             WHERE Base_Station__c = null AND Status__c = 'Inactive'];
        System.assertEquals(5, insertSensorsList.size(), 'Expected test to find a 5 Sensors');
    }
}