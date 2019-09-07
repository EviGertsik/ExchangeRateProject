({
    sort : function(component, event, helper) {
        let notempty, emptydata, colname, data, headerData;
        colname = evt.currentTarget.id;
        data = JSON.parse(JSON.stringify(component.get('v.rowData')));
        headerData = JSON.parse(JSON.stringify(component.get('v.colData')));

        notempty = data.filter(val => {
            return (val.hasOwnProperty(colname))
        })
        emptydata = data.filter(val => {
            return !(val.hasOwnProperty(colname))
        })

        headerData.forEach(obj => {
            if(obj['fieldPath'] == colname){
                if (obj['isSortUp'] == true) {
                notempty.sort(helper.sortDown(colname))
                component.set('v.rowData', emptydata.length > 0 ? notempty.concat(emptydata) : notempty)
                obj['isSortUp'] = false
                obj['isSortDown'] = true
            }else{
                notempty.sort(helper.sortDown(colname))
                component.set('v.rowData', emptydata.length > 0 ? emptydata.concat(notempty) : emptydata)
                obj['isSortUp'] = true
                obj['isSortDown'] = false
            }
            obj['byDefaultSort'] = true
        }
        else
            obj['byDefaultSort'] = false
    });
    component.set('v.colData', headerData);
}
})
