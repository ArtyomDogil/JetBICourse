public with sharing class SensorConroller {
    @AuraEnabled(cacheable=true)
    public static List<Sensor__c> getSensorList() {
        return [SELECT Name, 
                       Sensor_model__c,
                       Status__c,
                       Base_Station__c
                FROM Sensor__c
                LIMIT 10000];
    }
}