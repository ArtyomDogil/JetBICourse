public with sharing class SensorConroller {
    @AuraEnabled
    public static List<Sensor__c> getSensorList() {
        return [SELECT Name,
                       Sensor_model__c,
                       Status__c,
                       Base_Station_Name__c
                FROM Sensor__c
                LIMIT 10000];
    }
    @AuraEnabled
    public static Boolean deleteSensor(String sensorId) {
        List<Sensor__c> deletedRecord = [SELECT Id
                                         FROM Sensor__c
                                         WHERE Id = :sensorId
                                         LIMIT 1];
        Boolean answer = false;
        if (!deletedRecord.isEmpty()) {
            try {
                delete deletedRecord;
                answer = true;
            } catch (DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        return answer;
    }
    @AuraEnabled(cacheable=true)
    public static Integer getDefaultPageSize() {
        Parking_Cloud_Setting__mdt mc = Parking_Cloud_Setting__mdt.getInstance('Default');
        return Integer.valueOf(mc.Page_Size__c);
    }
}