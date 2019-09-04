({
    makeCallout : function(component, event, helper) {
        
        var startDate = component.find('StartDate').get('v.value');
        var endDate = component.find('EndDate').get('v.value');
        var baseCurrency = component.find('BaseCurrency').get('v.value');
        var action = component.get("c.getCalloutResponseContents");
        action.setParams({
            "url": 'https://api.exchangeratesapi.io/history?start_at=' + startDate + '&end_at=' + endDate + '&base=' + baseCurrency
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS') {
                component.set("v.response", response.getReturnValue());
                var getAllRates = component.get("v.response")['v.rates'];
                var CurrencyList = [];
                for (var key in getAllRates){
                    CurrencyList.push(key + ' = ' + getAllRates[key]);
                }
                component.set("v.ListOfCurrency", CurrencyList);
            }
        });
        $A.enqueueAction(action);
    }})
