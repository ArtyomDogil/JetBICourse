public with sharing class UploaderCSVFileController {
    @AuraEnabled
    public static void saveFile(String base64Data, String typeOfObject) {
        List<Sensor__c> lstSensors = new List<Sensor__c>();
        List<Base_Station__c> lstBaseStations = new List<Base_Station__c>();
        List<List<String>> allFields = new List<List<String>>();
        String strCSVFile = JSON.deserializeUntyped(base64Data).toString();
        strCSVFile = strCSVFile.replaceAll(',"""', ',"DBLQT').replaceall('""",', 'DBLQT",');
        strCSVFile = strCSVFile.replaceAll('""', 'DBLQT');
        List<String> strCSVLines = new List<String>();
        strCSVLines = strCSVFile.split('\n');

       // Calling Parser Logic from the parseCSV Helper Class
        allFields = ParserCSV.getAllFields(strCSVLines);
       // Removed the first row at it contains the column name
        if (allFields.size() > 0) {
            allFields.remove(0);
        }        

        for (Integer i = 0; i < allFields.size(); i++) {           
            List<String> csvRecordData = allFields[i];
            if (typeOfObject == 'BaseStation') {
                Base_Station__c itemToInsert = new Base_Station__c(
                    Name = csvRecordData[0],
                    Status__c = csvRecordData[1],
                    External_Id__c = csvRecordData[2]
                );
                lstBaseStations.add(itemToInsert);

            } else if (typeOfObject == 'Sensor') {
                Sensor__c itemToInsert = new Sensor__c(
                    Sensor_model__c = csvRecordData[0],
                    Status__c = csvRecordData[1]
                );
                if (csvRecordData[2] != ' ') {
                    itemToInsert.Base_Station__r = new Base_Station__c(External_Id__c = csvRecordData[2]);
                }
                lstSensors.add(itemToInsert);
            }
        }
        if (!lstBaseStations.isEmpty()) {
            insert lstBaseStations;
        } else if (!lstSensors.isEmpty()) {
            insert lstSensors;
        }
    }
}
