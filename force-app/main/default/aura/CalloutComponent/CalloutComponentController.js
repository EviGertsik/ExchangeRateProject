({
    myAction : function(component, event, helper) {
        
        var StartDate = component.find('StartDate').get('v.value');
        var EndDate = component.find('EndDate').get('v.value');
        var BaseCurrency = component.find('BaseCurrency').get('v.value');
        var action = component.get('c.RateCallout');
        action.setParams({
            "StartDate": StartDate,
            "EndDate": EndDate,
            "BaseCurrency": BaseCurrency
        })
        action.setCallback(this, function(Response){
            var state = Response.getState();
            if (state === "SUCCESS"){
                var result = Response.getReturnValue();
                if (result){
                    result = JSON.parse(result);
                    console.log(result);
                   // Map<String,Map<String,Map<String,Number>>> m =  
                //    var map = Object.entries(result.rates);
                //    console.log(map[0][1]);
                //    console.log(map.values());
                $A.enqueueAction(action);
                }
                
            }
            // for (const iterator of map) 
            //     console.log(iterator [1])
            })
        
        
        
    

    }})