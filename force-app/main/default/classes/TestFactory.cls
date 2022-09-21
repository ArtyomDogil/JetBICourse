@isTest
public with sharing class TestFactory {
    public static List<Base_Station__c> getBaseStations(Integer numRec, String name, String statusBS, Boolean doInsert){
        List<Base_Station__c> baseStations = new List<Base_Station__c>();
        for(Integer i = 0; i < numRec; i++){
            Base_Station__c bs = new Base_Station__c();
            bs.Name = name;
            bs.Status__c = statusBS;
            baseStations.add(bs);
        }
        if(doInsert){
            insert baseStations;
        }
        return baseStations;
    }
    public static List<Sensor__c> getSensorsWithoutBaseStation(Integer numRec, String model, String statusS, Boolean doInsert){
        List<Sensor__c> sensors = new List<Sensor__c>();
        for(Integer i = 0; i < numRec; i++){
            Sensor__c s = new Sensor__c();
            s.Sensor_model__c = model;
            s.Status__c = statusS;
            sensors.add(s);
        }
        if(doInsert){
            insert sensors;
        }
        return sensors;
    }
    public static List<Sensor__c> getSensorsWithBaseStation(Integer numRec, String name, String statusS, String nameBS, String statusBS, Boolean doInsert){
        Base_Station__c baseStation = getBaseStations(1, nameBS, statusBS, true).get(0);
        List<Sensor__c> sensors = getSensorsWithoutBaseStation(numRec, name, statusS, false);
        if (sensors.size() > 0){
            for(Sensor__c s : sensors){
                s.Status__c = baseStation.id;
                sensors.add(s);
            }
        }
        if(doInsert){
            insert sensors;
        }
        return sensors;
    }
}