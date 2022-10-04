@isTest
private with sharing class UploaderCSVFileControllerTest {
    @isTest
    static void successfulLoadingBaseStations(){
        String typeOfObjectBS = 'BaseStation';
        List<String> csvImitationBS = new List<String> {'Name,Status__c,External_Id__c',
                                                        'parking 1,Active,ex1',
                                                        'parking 2,Inactive,ex2',
                                                        'parking 3,Broken,ex3'};
        String csvStringBS = (String.join(csvImitationBS, '\\r\\n') + '\\r\\n').escapeCsv();
        Test.startTest();
        UploaderCSVFileController.saveFile(csvStringBS, typeOfObjectBS);
        Test.stopTest();
        List<Base_Station__c> checkRecords = [SELECT Id
                                              FROM Base_Station__c
                                              WHERE External_Id__c LIKE 'ex_'];
        System.assertEquals(3, checkRecords.size(), 'You should expect 3 records of Base Station');
    }
    @isTest
    static void successfulLoadingSensors(){
        String typeOfObjectBS = 'BaseStation';
        String typeOfObjectS = 'Sensor';
        List<String> csvImitationBS = new List<String> {'Name,Status__c,External_Id__c',
                                                        'parking 1,Active,ex1'};
        String csvStringBS = (String.join(csvImitationBS, '\\r\\n')).escapeCsv();
        List<String> csvImitationS = new List<String> {'Sensor_model__c,Status__c,Base_Station__c',
                                                        'standart1,Active,ex1',
                                                        'standart2,Inactive,ex1'};
        String csvStringS = (String.join(csvImitationS, '\\r\\n')).escapeCsv();
        Test.startTest();
        UploaderCSVFileController.saveFile(csvStringBS, typeOfObjectBS);
        UploaderCSVFileController.saveFile(csvStringS, typeOfObjectS);
        Test.stopTest();
        List<Sensor__c> checkRecords = [SELECT Id
                                        FROM Sensor__c
                                        WHERE Status__c = 'Active'];
        System.assertEquals(2, checkRecords.size(), 'You should expect 2 active Sensors');
    }
    @isTest
    static void invalidData(){
        String typeOfObjectBS = 'BaseStation';
        List<String> csvImitationBS = new List<String> {'\\"Name\\",Status__c,External_Id__c',
                                                        'parking 1,Active,ex1',
                                                        'parking 2,Inactive,ex2',
                                                        'parking 3,Broken,ex3'};
        String csvStringBS = '"' + String.join(csvImitationBS, '\\r\\n') + '\\r\\n' + '"';
        Test.startTest();
        UploaderCSVFileController.saveFile(csvStringBS, typeOfObjectBS);
        Test.stopTest();
        List<Base_Station__c> checkRecords = [SELECT Id
                                              FROM Base_Station__c
                                              WHERE External_Id__c LIKE 'ex_'];
        System.assertEquals(3, checkRecords.size(), 'You should expect 3 records of Base Station');
    }
}