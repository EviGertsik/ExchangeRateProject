public with sharing class DynamicTable {
    public class ResultWrapper {
        @AuraEnabled
        public List < SObject > listObject;
        @AuraEnabled
        public List < FieldsWrapper > listFields;

        public ResultWrapper(List < SObject > listObject, List < FieldsWrapper > listFields) {
            this.listObject = listObject;
            this.listFields = listFields;
        }
    }
    public with sharing class FieldsWrapper {
        @AuraEnabled
        public String fieldPath {
            get;
            set;
        }
        @AuraEnabled
        public String label {
            get;
            set;
        }
        @AuraEnabled
        public String Type {
            get;
            set;
        }

        public FieldsWrapper(String fieldPath, String strLabel, String strType) {
            this.fieldPath = fieldPath;
            this.Label = strLabel;
            this.Type = strType;
        }
    }
    @AuraEnabled
    public static ResultWrapper fetchExchangeRate(String strObjectName, String strFieldsetName) {
        Set < String > setFieldsToQuery = new Set < String > ();
        List < FieldsWrapper > listFieldsetWrapper = new List < FieldsWrapper > ();
        Map < String, String > mapfieldpathlabel = new Map < String, String > ();

        for (Schema.FieldSetMember fld: readFieldSet(strfieldSetName, strObjectName)) {
            setFieldsToQuery.add(fld.getFieldPath().toLowerCase());
            mapfieldpathlabel.put(String.valueOf(fld.getType()), fld.getFieldPath());
            listFieldsetWrapper.add(new FieldsWrapper(fld.getFieldPath(), fld.getLabel(), String.valueOf(fld.getType())));

        }
        String queryString = 'SELECT id, ';
        setFieldsToQuery.remove('id');
        queryString += String.join(new List < String > (setFieldsToQuery), ',');
        queryString.removeEnd(',');
        queryString += ' FROM ' + strObjectName;
        List < sObject > listObject = Database.query(queryString);
        System.debug('listObject' + listObject);
        return new ResultWrapper(listObject, listFieldsetWrapper);
    }

    private static List < Schema.FieldSetMember > readFieldSet(String fieldSetName, String ObjectName) {
        Map < String, Schema.SObjectType > GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSobjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSobjectResultObj.fieldsets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }
}