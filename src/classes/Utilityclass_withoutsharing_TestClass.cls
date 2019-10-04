@isTest
private class Utilityclass_withoutsharing_TestClass {

    private static testMethod void test() {
        try {
            Utilityclass_withoutsharing utw = new Utilityclass_withoutsharing();
            Opportunity opp = new Opportunity(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'sush', StageName = DOL_AppConstants.NULL_EMPTY_STRING + 'Prospecting', CloseDate = date.parse('12/27/2009'));
            List < Opportunity > opps = new List < Opportunity > ();
            opps.add(opp);
            //Utilityclass_withoutsharing.insertList(opps, true);
            // Utilityclass_withoutsharing.transforminsertupdateLists(opps);//
            Utilityclass_withoutsharing.insertList(opps);

            Utilityclass_withoutsharing.updateList(opps);
            Utilityclass_withoutsharing.upsertList(opps);

            // Utilityclass_withoutsharing.checkObjectFieldAccess('Opportunity','Name, StageName,CloseDate');
            // Utilityclass_withoutsharing.checkSecurityAccessForDelete(opps);
            //Utilityclass_withoutsharing.checkSecurityAccessDML(opps);
            //Utilityclass_withoutsharing.checkSecurityAccessForDMLOps(opps,'update');
            //Utilityclass_withoutsharing.bIsTestClass = True;
            Utilityclass_withoutsharing.queryRecords('Select Name, StageName,CloseDate from Opportunity ');
            Utilityclass_withoutsharing.getRecordCount('Select Count() from Opportunity');
            //Select Count(Name), StageName,CloseDate from Opportunity group by StageName,CloseDate 

            Utilityclass_withoutsharing.getSubQuery('Opportunity');
            Utilityclass_withoutsharing.deleteList(opps);
            // Utilityclass_withoutsharing.checkDMLAccess(opps, 'update');
            /*Map<String, SObjectField> fields = new Map<String, SObjectField>();
            List<String> lstFieldNames = new List<String>();
            Utilityclass_withoutsharing.checkFieldAccess(fields,'upsert', 'Opportunity', lstFieldNames);
            Utilityclass_withoutsharing.throwException('update','Opportunity','Name');*/
        } catch (Exception e) {}
    }

    private static testMethod void test2() {
        Utilityclass_withoutsharing utw = new Utilityclass_withoutsharing();
        Opportunity opp = new Opportunity(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'sush', StageName = DOL_AppConstants.NULL_EMPTY_STRING + 'Prospecting', CloseDate = date.parse('12/27/2009'));
        List < Opportunity > opps = new List < Opportunity > ();
        opps.add(opp);
        //Utilityclass_withoutsharing.checkSecurityAccessForDMLOps(opps,'insert');
        Map < String, SObjectField > fields = new Map < String, SObjectField > ();
        List < String > lstFieldNames = new List < String > ();
        //Utilityclass_withoutsharing.checkFieldAccess(fields,'update', 'Opportunity', lstFieldNames);

    }


}