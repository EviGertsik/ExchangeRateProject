({
    loadData: function (component, event, helper) {
        let state, action, ret;
        action = component.get('c.fetchExchangeRate');
        action.setParams({
            strObjectName: 'ExchangeRate__c',
            strFieldsetName: 'ExchangeRateFieldSet'
        });
        action.setCallback(this, function (res) {
            state = res.getState();
            if (state === 'SUCCESS') {
                ret = res.getReturnValue();
                console.log('ret', ret);
                this.createHeader(component, ret['listFields']);
                this.createRows(component, ret['listFields'], ret['listObject'])
            }
        });
        $A.enqueueAction(action);
    },

    createHeader: function (component, field) {
        let orderData = field.map(e => {
            var obj = {};
            obj['label'] = e['label']
            obj['fieldPath'] = e['fieldPath']
            obj['isSortUp'] = true
            obj['isSortDown'] = false
            obj['byDefaultSort'] = e['label'] == "Date" ? true : false
            return obj;
        })
        component.set('v.colData', orderData);
    },

    createRows: function (component, field, row) {
        let fieldPath = field.map(e => {
            return e['fieldPath']
        })
        component.set('v.fieldPath', fieldPath);
        component.set('v.allRowData', row);
        component.set('v.rowData', row.splice(0, component.get('v.prev')));
    }
})