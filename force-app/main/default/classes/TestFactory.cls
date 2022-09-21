@isTest
public with sharing class TestFactory {
    public static List<Base_Station__c> getBaseStation(Integer numRec, String name, String picklist, Boolen doInsert){
        List<Base_Station__c> baseStations = new List<Base_Station__c>();
        String ending;
        for(Integer i = 0; i < numRec; i++){
            Base_Station__c bs = new Base_Station__c();
            bs.Name = name;
            bs.Status__c = picklist;
            baseStations.add(bs);
        }
        if(doInsert){
            insert baseStations;
          }
          return baseStations;
}