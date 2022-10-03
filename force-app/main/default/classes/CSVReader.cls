public with sharing class CSVReader {
    private static final String PARSER_COMMA = String.fromCharArray(new List<Integer>{44});
    private static final String PARSER_CR = '\r';
    private static final String PARSER_DQUOTE = '\"';
    private static final String PARSER_LF = '\n';
    private static final String PARSER_CRLF = PARSER_CR + PARSER_LF;
    private static final String PARSER_DQUOTE_DQUOTE = PARSER_DQUOTE + PARSER_DQUOTE;

    public static List<List<String>> doParse(String file) {
        String fileString = JSON.deserializeUntyped(file).toString();
        if (!fileString.endsWith(PARSER_CRLF)) {
            fileString = fileString + PARSER_CRLF;
        }
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CSVValue csvValue = new CSVValue();
        Boolean eod = false;
        while (!eod) {
            csvValue = parseStringValue(fileString);
            rowValues.add(csvValue.value);
            if (csvValue.delimiter == PARSER_CRLF) {
                fileValues.add(rowValues);
                if (!fileValues.isEmpty()) {
                    System.assertEquals(fileValues.get(0).size(),rowValues.size());
                }
                rowValues = new List<String>();
            }

            if (csvValue.biteSize() == fileString.length()) {
                eod = true;
            }
            else {
                fileString = fileString.substring(csvValue.biteSize());
            }
        }
        return fileValues;
    }

    public static CSVValue parseStringValue(String data) {
        System.assert(data.endsWith(PARSER_CRLF));
        CSVValue csvValue = new CSVValue();
        if (data.startsWith(PARSER_DQUOTE)){
            csvValue.enclosed = true;
            Integer searchIndex = 1;
            Integer dquoteIndex = -1;
            Integer dquotesIndex = -1;
            Boolean closerFound = false;
            while (!closerFound) {
                dquoteIndex = data.indexOf(PARSER_DQUOTE, searchIndex);
                dquotesIndex = data.indexOf(PARSER_DQUOTE_DQUOTE,searchIndex);
                System.assert(dquoteIndex != -1);
                if (dquoteIndex == dquotesIndex) {
                    searchIndex = dquotesIndex+PARSER_DQUOTE_DQUOTE.length();
                }
                else {
                    closerFound = true;
                }
            }
            csvValue.value = data.substring(PARSER_DQUOTE.length(), dquoteIndex).replaceAll(PARSER_DQUOTE_DQUOTE, PARSER_DQUOTE);
            Integer commaIndex = data.indexOf(PARSER_COMMA, dquoteIndex);
            Integer crlfIndex = data.indexOf(PARSER_CRLF, dquoteIndex);
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.delimiter = PARSER_COMMA;
            }
            else {
                csvValue.delimiter = PARSER_CRLF;
            }
        }
        else {
            csvValue.enclosed = false;
            Integer commaIndex = data.indexOf(PARSER_COMMA);
            Integer crlfIndex = data.indexOf(PARSER_CRLF);
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.value = data.substring(0, commaIndex);
                csvValue.delimiter = PARSER_COMMA;
            }
            else {
                csvValue.value = data.substring(0, crlfIndex);
                csvValue.delimiter = PARSER_CRLF;
            }
        }
        return csvValue;
    }

    private class CSVValue {
        public String value;
        public Boolean enclosed;
        public String delimiter;

        public CSVValue() {
            this(null, null, null);
        }

        public CSVValue(String value, Boolean enclosed, String delimiter) {
            this.value = value;
            this.enclosed = enclosed;
            this.delimiter = delimiter;
        }

        public Integer biteSize() {
            Integer biteSize = value.replaceAll(PARSER_DQUOTE, PARSER_DQUOTE_DQUOTE).length() + delimiter.length();
            if (enclosed) {
                biteSize += PARSER_DQUOTE.length() * 2;
            }
            return biteSize;
        }
    }
 }