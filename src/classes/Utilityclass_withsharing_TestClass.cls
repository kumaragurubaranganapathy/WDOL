@isTest
private class Utilityclass_withsharing_TestClass {
    
    private static testMethod void test1() {
        try {
            Utilityclass_withsharing utw = new Utilityclass_withsharing();
            Opportunity opp = new Opportunity(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'sush', StageName = DOL_AppConstants.NULL_EMPTY_STRING + 'Prospecting', CloseDate = date.parse('12/27/2009'));
            List < Opportunity > opps = new List < Opportunity > ();
            opps.add(opp);
            //Utilityclass_withsharing.insertList(opps, true);
            Utilityclass_withsharing.insertList(opps);
            //Utilityclass_withsharing.transforminsertupdateLists(opps);
            Utilityclass_withsharing.updateList(opps);
            Utilityclass_withsharing.upsertList(opps);
            Utilityclass_withsharing.deleteList(opps);
            Utilityclass_withsharing.checkObjectFieldAccess('Opportunity', 'Name, StageName,CloseDate');
            Utilityclass_withsharing.checkSecurityAccessForDelete(opps);
            Utilityclass_withsharing.checkSecurityAccessDML(opps);
            Utilityclass_withsharing.checkSecurityAccessForDMLOps(opps, 'update');
            Utilityclass_withsharing.bIsTestClass = True;
            Utilityclass_withsharing.queryRecords('Select Name, StageName,CloseDate from Opportunity ');
            
            Set<String> setStr = new Set<String>();
            setStr.add('ABC');
            Utilityclass_withsharing.queryRecordsInClause('Select Name, StageName,CloseDate from Opportunity ', setStr);
            Utilityclass_withsharing.getRecordCount('Select Count() from Opportunity');
            //Select Count(Name), StageName,CloseDate from Opportunity group by StageName,CloseDate 
            
            Utilityclass_withsharing.getSubQuery('Opportunity');
            Utilityclass_withsharing.checkDMLAccess(opps, 'update');

            
            Schema.DescribeFieldResult F = Account.Name.getDescribe();
            Schema.sObjectField T = F.getSObjectField();
            Map < String, SObjectField > fields = new Map < String, SObjectField > ();
            fields.put('Name', T);
            List < String > lstFieldNames = new List < String > ();
            lstFieldNames.add('Name');
            Utilityclass_withsharing.checkFieldAccess(fields, 'upsert', 'Opportunity', lstFieldNames);
            Utilityclass_withsharing.throwException('update', 'Opportunity', 'Name');
        } catch (Exception e) {}
    }
    
    private static testMethod void test2() {
        Utilityclass_withsharing utw = new Utilityclass_withsharing();
        Opportunity opp = new Opportunity(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'sush', StageName = DOL_AppConstants.NULL_EMPTY_STRING + 'Prospecting', CloseDate = date.parse('12/27/2009'));
        List < Opportunity > opps = new List < Opportunity > ();
        opps.add(opp);
        Utilityclass_withsharing.checkSecurityAccessForDMLOps(opps, 'insert');
        
        SObject s = new Opportunity();
        List<SObject> lstSObjects = new List<SObject>();
        lstSObjects.add(s);
        Utilityclass_withsharing.checkSecurityAccessForDMLOps(lstSObjects, 'update');
        
        Map < String, SObjectField > fields = new Map < String, SObjectField > ();
        List < String > lstFieldNames = new List < String > ();
        Utilityclass_withsharing.checkFieldAccess(fields, 'update', 'Opportunity', lstFieldNames);
        
    }
    
    
}