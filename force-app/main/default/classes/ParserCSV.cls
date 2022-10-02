public with sharing class ParserCSV {
    public static List<List<String>> getAllFields(List<String> strCSVLines) {
        List<List<String>> allFields = new List<List<String>>();
        for (String line : strCSVLines) {
            if (line.replaceAll(',', '').trim().length() == 0) {
                break;
            }

            List<String> fields = line.split(',');
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;

            for (String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT', '"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT', '"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField += ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT', '"'));
                }
            }
            allFields.add(cleanFields);
        }
        return allFields;
    }
}
