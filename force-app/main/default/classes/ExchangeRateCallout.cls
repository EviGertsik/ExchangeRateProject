public with sharing class ExchangeRateCallout {
    public static String getCurrencyFields(String obj) {
        List < String > fields = new List < String > ();
        SObjectType objType = Schema.getGlobalDescribe().get(obj);
        Map < String, Schema.SObjectField > mfieldsMap = objType.getDescribe().fields.getMap();
        for (Schema.SObjectField fld: mfieldsMap.values()) {
            if (fld.getDescribe().getType() == Schema.DisplayType.CURRENCY) {
                fields.add(fld.getDescribe().getLabel());
            }
        }

        return String.join(fields, ',');

    }

    // @AuraEnabled
    // public static String getjson(String StartDate, String EndDate) {
    //     System.debug(StartDate);
    //     System.debug(EndDate);
        
    //     String mystring = RateCallout(StartDate, EndDate).getBody();
    //     System.debug(mystring);
    //     return mystring;
    // }
    @AuraEnabled
    public static void RateCallout(String StartDate, String EndDate, String BaseCurrency) {
        // new ExchangeRate__c list with ID, Date selection
        ExchangeRate__c newExchangeRateList = [SELECT Id, Date__c FROM ExchangeRate__c ORDER BY Date__c DESC LIMIT 1];
        // variable to store start date in it. Why add +1?
        // Date startDateFromList = newExchangeRateList.Date__c + 1;
        // variable to store end date
        // Date finishDateFromList = Date.today();
        // list, in which I store all picklist values, using "getPickListValuesIntoList" method
        String stringOfBaseCurrencies = getCurrencyFields('ExchangeRate__c');
        List < String > listOfBaseCurrencies = stringOfBaseCurrencies.split(',');
        // variable to store list size
        Integer i = listOfBaseCurrencies.size();
        // list for ExchangeRate__c records, in which I will store my future records
        List < ExchangeRate__c > listForDeploy = new List < ExchangeRate__c > ();
        // map from my custom object
        Map < String, Schema.SObjectField > fieldMap = ExchangeRate__c.getSObjectType().getDescribe().fields.getMap();
        // iteration for each base currency
        for (Integer a = 0; a < i; a++) {
            //String BaseCurrency = listOfBaseCurrencies[a];
            Http Http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.exchangeratesapi.io/history?start_at=' + StartDate + '&end_at=' + EndDate + '&base=' + BaseCurrency + '&symbols=' + getCurrencyFields('ExchangeRate__c'));
            request.setHeader('Content-type', 'application-json');
            request.setMethod('GET');
            HttpResponse response = Http.send(request);
            String myResponseJsonString = response.getBody();
            Map < String, Object > myResult = (Map < String, Object > ) JSON.deserializeUntyped(myResponseJsonString);
            Map < String, Object > mapWithRatesOnly = (Map < String, Object > ) myResult.get('rates');
            for (String keyDate: mapWithRatesOnly.keySet()) {
                ExchangeRate__c ExRa = New ExchangeRate__c();
                ExRa.put(fieldMap.get('Date__c'), Date.valueOf(keyDate));
                ExRa.put(fieldMap.get('Base_currency__c'), String.valueof(myResult.get('base')));
                Map < String, Object > RatesOnly = (Map < String, Object > ) mapWithRatesOnly.get(keyDate);
                for (string key1: fieldMap.keySet()) {
                    String currencyName = key1.remove('__c');
                    currencyName = currencyName.toUpperCase(); {
                        for (string key: RatesOnly.keySet()) {
                            if (key == currencyName) {
                                ExRa.put(key1, Double.valueOf(RatesOnly.get(key)));
                            }
                        }
                    }
                }
                listForDeploy.add(ExRa);
                System.debug(listForDeploy);
                

            }

        }
        upsert listForDeploy;
        List < ExchangeRate__c > ListForEuroCheck = new List < ExchangeRate__c > ();
        for (ExchangeRate__c exc: listForDeploy) {
            if (exc.eur__c == null) {
                exc.eur__c = 1;
                ListForEuroCheck.add(exc);
            }
        }
        upsert ListForEuroCheck;
    }
}