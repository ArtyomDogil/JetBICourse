public with sharing class UploaderCSVFileController {
    @AuraEnabled
    public static Boolean saveFile(String csvString, String typeOfObject) {
        List<List<String>> fileValues = CSVReader.doParse(csvString);
        List<Sensor__c> lstSensors = new List<Sensor__c>();
        List<Base_Station__c> lstBaseStations = new List<Base_Station__c>();
        Boolean markerOfSuccess = false;
        Boolean permissionToProcess = false;
        List<String> baseStationTemplate = new List<String>{'Name',
                                                            'Status__c',
                                                            'External_Id__c'};
        List<String> sensorTemplate = new List<String>{'Sensor_model__c',
                                                       'Status__c',
                                                       'Base_Station__c'};
        if ((typeOfObject == 'BaseStation' && fileValues[0] == baseStationTemplate) ||
            (typeOfObject == 'Sensor' && fileValues[0] == sensorTemplate)) {
            permissionToProcess = true;
        }
        for (Integer i = 1; i < fileValues.size(); i++) {
            List<String> csvRecordData = fileValues[i];
            if (typeOfObject == 'BaseStation' && permissionToProcess) {
                Base_Station__c itemToInsert = new Base_Station__c(
                    Name = csvRecordData[0],
                    Status__c = csvRecordData[1],
                    External_Id__c = csvRecordData[2]
                );
                lstBaseStations.add(itemToInsert);

            } else if (typeOfObject == 'Sensor' && permissionToProcess) {
                Sensor__c itemToInsert = new Sensor__c(
                    Sensor_model__c = csvRecordData[0],
                    Status__c = csvRecordData[1]
                );
                if (String.isNotBlank(csvRecordData[2])) {
                    itemToInsert.Base_Station__r = new Base_Station__c(
                        External_Id__c = csvRecordData[2]
                    );
                }
                lstSensors.add(itemToInsert);
            }
        }
        if (!lstBaseStations.isEmpty()) {
            insert lstBaseStations;
            markerOfSuccess = true;
        } else if (!lstSensors.isEmpty()) {
            insert lstSensors;
            markerOfSuccess = true;
        }
        return markerOfSuccess;
    }
}