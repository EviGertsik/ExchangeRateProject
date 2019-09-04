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

    @AuraEnabled
    public static Map < String, Object > getCalloutResponseContents(String url) {
 
		// Instantiate a new http object
		Http h = new Http();
 
		// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url + '&symbols=' + getCurrencyFields('ExchangeRate__c'));
		req.setMethod('GET');
 
		// Send the request, and return a response
		HttpResponse res = h.send(req);
		System.debug('response:--> ' + res.getBody());
 
		// Deserialize the JSON string into collections of primitive data types.
		Map < String,
		Object > resultsMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
		system.debug('resultsMap-->' + resultsMap);
 
		return resultsMap;
	
    }
}