@isTest
private with sharing class SensorControllerTest {
    @testSetup static void setupData() {
        Base_Station__c newBaseStation = new Base_Station__c(Name = 'test Base',
                                                             Status__c = 'Active',
                                                             External_Id__c = 'e1');
        insert newBaseStation;
        List<Sensor__c> insertSensors = new List<Sensor__c>();
        for (Integer i=0; i<10; i++) {
            insertSensors.add(new Sensor__c(Sensor_model__c = 'test Model',
                                            Status__c = 'Active',
                                            Base_Station__c = newBaseStation.Id));
        }
        insert insertSensors;
    }
    @isTest
    static void getSensorListTest(){
        Test.startTest();
        List<Sensor__c> methodAnswer = SensorConroller.getSensorList();
        Test.stopTest();
        List<Sensor__c> curentAnswer = [SELECT Name,
                                               Sensor_model__c,
                                               Status__c,
                                               Base_Station_Name__c
                                        FROM Sensor__c
                                        LIMIT 10000];
        System.assertEquals(methodAnswer, curentAnswer, 'Lists should be equil');
    }
    @isTest
    static void successfulDeleteSensorTest(){
        Id idDeletedSensor = [SELECT Id
                              FROM Sensor__c
                              LIMIT 1][0].Id;
        String stringId = Id.valueOf(idDeletedSensor);
        Test.startTest();
        Boolean methodAnswer = SensorConroller.deleteSensor(stringId);
        Test.stopTest();
        List<Sensor__c> curentAnswer = [SELECT Id
                                        FROM Sensor__c
                                        WHERE Id = :idDeletedSensor];
        System.assertEquals(True, methodAnswer, 'Boolean answer should be True');
        System.assertEquals(True, curentAnswer.isEmpty(), 'List must not contain elements');
    }
    @isTest
    static void unsuccessfulDeleteSensorTest(){
        Sensor__c deletedSensor = [SELECT Id
                                   FROM Sensor__c
                                   LIMIT 1][0];
        String stringId = Id.valueOf(deletedSensor.Id);
        delete deletedSensor;
        Test.startTest();
        Boolean methodAnswer = SensorConroller.deleteSensor(stringId);
        Test.stopTest();
        List<Sensor__c> curentAnswer = [SELECT Id
                                        FROM Sensor__c
                                        WHERE Id = :deletedSensor.Id];
        System.assertEquals(False, methodAnswer, 'Boolean answer should be False');
        System.assertEquals(True, curentAnswer.isEmpty(), 'List must not contain elements');
    }
    @isTest
    static void getDefaultPageSizeTest(){
        Test.startTest();
        Integer methodAnswer = SensorConroller.getDefaultPageSize();
        Test.stopTest();
        System.assertEquals(25, methodAnswer, 'Custom Metadata Type set to the number 25');
    }
}