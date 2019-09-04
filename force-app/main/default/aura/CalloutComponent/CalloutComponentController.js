({
    myAction : function(component, event, helper) {
        
        var startDate = component.find('StartDate').get('v.value');
        var endDate = component.find('EndDate').get('v.value');
        var baseCurrency = component.find('BaseCurrency').get('v.value');
        var action = component.get('c.getjson');
        action.setParams({
            "StartDate": startDate,
            "EndDate": endDate,
            "BaseCurrency": baseCurrency
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
