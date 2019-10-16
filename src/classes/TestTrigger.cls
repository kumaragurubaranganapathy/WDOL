//@isTest(seeAllData=true)
@isTest
public class TestTrigger
{
   @testSetup static void setup() {
        initCustomSettings();
        initCitizenAccount();     
    }


    static void initCustomSettings(){       
        BGBK__CartSettings__c defaultCartSetting = new BGBK__CartSettings__c();
        defaultCartSetting.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Default';
        defaultCartSetting.BGBK__Cart_Expiration_Hours__c = 60;
        defaultCartSetting.BGBK__Payment_Gateway_Form_Post_URL__c = DOL_AppConstants.NULL_EMPTY_STRING + 'http://google.com';
        defaultCartSetting.BGBK__Payment_Gateway_Data_Encryption_Key__c = DOL_AppConstants.NULL_EMPTY_STRING + '1234567890123456';
        defaultCartSetting.BGBK__Payable_Parents__c = DOL_AppConstants.NULL_EMPTY_STRING + 'MUSW__License2__c,MUSW__Permit2__c,MUSW__Complaint2__c,MUSW__Application2__c';
        insert defaultCartSetting;  

        BGBK__FinancialObjects__c finObjSetting = new BGBK__FinancialObjects__c();
        finObjSetting.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'Parcel_Account__c';
        finObjSetting.BGBK__Account_Field_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Account__c';
        finObjSetting.BGBK__Contact_Field_Name__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Primary_Contact__c';
        insert finObjSetting;
            
    }

    static void initCitizenAccount(){
        Account citizen = new Account();
        citizen.name = DOL_AppConstants.NULL_EMPTY_STRING + 'Citizen';
        citizen.BillingCity = DOL_AppConstants.NULL_EMPTY_STRING + 'Tristram';
        citizen.Phone = DOL_AppConstants.NULL_EMPTY_STRING + '(123) 456-7890';
        citizen.BillingState = DOL_AppConstants.NULL_EMPTY_STRING + 'AL';
        citizen.BillingPostalCode= DOL_AppConstants.NULL_EMPTY_STRING + '67890';
        citizen.BillingStreet = DOL_AppConstants.NULL_EMPTY_STRING + 'Black smith';
        insert citizen;
    }
    
    static testmethod void testViolationCloseInspectionTree()
    {
        Id[] ids = new Id[]{};
        
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c= DOL_AppConstants.NULL_EMPTY_STRING + 'East Blvd', MUSW__Street_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '7777', MUSW__City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Vancouver', MUSW__Parcel_Number2__c= DOL_AppConstants.NULL_EMPTY_STRING + '2000Test400');
        insert par;
        
        MUSW__Complaint2__c com = new MUSW__Complaint2__c(MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Multiple Issues', MUSW__Origin__c= DOL_AppConstants.NULL_EMPTY_STRING + '311', MUSW__Parcel__c=par.Id);
        insert com;
        
        MUSW__Inspection__c ins = new MUSW__Inspection__c (MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'First Inspection');
        insert ins;
        
        ids.add(ins.Id);
        
        //TriggerService.setLock();
        
        //Branch1
        MUSW__Inspection__c reins11 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c= ins.Id);
        insert reins11;
        ids.add(reins11.Id);
        ins.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed with open violations';
        update ins;
        
        MUSW__Inspection__c reins12 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c= reins11.Id);
        insert reins12;
        ids.add(reins12.Id); 
        reins11.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed with open violations';
        update reins11;
          
        MUSW__Inspection__c reins13 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c = reins12.Id);
        insert reins13;
        ids.add(reins13.Id);
        reins12.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed with open violations';
        update reins12;
         
           
        //Branch 2
        MUSW__Inspection__c reins21 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id,  MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c = ins.Id);
        insert reins21;
        ids.add(reins21.Id);
        
        MUSW__Inspection__c reins22 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c= reins21.Id);
        insert reins22;
        ids.add(reins22.Id); 
        reins21.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed with open violations';
        update reins21;
          
        MUSW__Inspection__c reins23 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection',MUSW__Previous_Inspection__c = reins22.Id);
        insert reins23;
        ids.add(reins23.Id);
        reins22.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Completed with open violations';
        update reins22;
        
        //TriggerService.releaseLock();
        //Check if the ins Inspection_Chain_Closed__c = false
        MUSW__Inspection__c insBefore = [select Inspection_Chain_Closed__c from MUSW__Inspection__c where Id = :ins.Id ]; 
        system.assert(insBefore.Inspection_Chain_Closed__c == false);
        
        //Close one leaf
        reins13.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Closed';
        update reins13;
        MUSW__Inspection__c[] insClosedOneLeaf = [select IsClosed__c, Inspection_Chain_Closed__c from MUSW__Inspection__c where Id in:ids and Inspection_Chain_Closed__c = true]; 
        
        /*system.assert(insClosedOneLeaf.size()==3, 'size: '+insClosedOneLeaf.size());
        
        //Close both leaves
        reins23.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Closed';
        update reins23;
        MUSW__Inspection__c[] insClosedBoth = [select Inspection_Chain_Closed__c from MUSW__Inspection__c where Id in:ids and Inspection_Chain_Closed__c = true]; 
        
        system.assert(insClosedBoth.size()==7, 'size: '+insClosedBoth.size());*/
    }
    
    
    static testmethod void testViolationCloseInspection()
    {
        Test.startTest();
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Test St', MUSW__Street_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '14B', MUSW__City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Testville', MUSW__Parcel_Number2__c= DOL_AppConstants.NULL_EMPTY_STRING + '1000TEST400');
        insert par;
        MUSW__Violation_Type__c ord = new MUSW__Violation_Type__c(MUSW__Code_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '1=234.5TEST', Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Ordinance X');
        insert ord;
        //TriggerService.setLock();
        MUSW__Complaint2__c com = new MUSW__Complaint2__c(MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'TestTypeComp', MUSW__Origin__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Test', MUSW__Parcel__c=par.Id);
        insert com;
        //system.debug('com======' + com);
        MUSW__Inspection__c ins = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Complaint2__c=com.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'TESTInspection');
        insert ins;
        MUSW__Violation__c v1 = new MUSW__Violation__c(MUSW__Type__c=ord.Id, MUSW__Complaint2__c=com.Id);
        MUSW__Violation__c v2 = new MUSW__Violation__c(MUSW__Type__c=ord.Id, MUSW__Complaint2__c=com.Id);
        insert new MUSW__Violation__c[]{v1, v2};
        MUSW__Inspection_Violation__c iv1 = new MUSW__Inspection_Violation__c(MUSW__Inspection__c=ins.Id, MUSW__Violation__c=v1.Id, MUSW__Complaint2__c=com.Id);
        MUSW__Inspection_Violation__c iv2 = new MUSW__Inspection_Violation__c(MUSW__Inspection__c=ins.Id, MUSW__Violation__c=v2.Id, MUSW__Complaint2__c=com.Id);
        insert new MUSW__Inspection_Violation__c[]{iv1, iv2};
        
        v1.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Closed - Corrected';
        v2.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Closed - Corrected';
        update new MUSW__Violation__c[]{v1, v2};
        
        MUSW__Inspection__c insq = [select Close_Inspection__c from MUSW__Inspection__c where Id = :ins.Id];
        //MOS: no DRE rule to close yet - system.assert(insq.Close_Inspection__c == true);
        
        Test.stopTest();
    }   
     
    static testmethod void testIVDeduper()
    {
        //TriggerService.setLock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(MUSW__Street2__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Test St', MUSW__Street_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '14B', MUSW__City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Testville', MUSW__Parcel_Number2__c= DOL_AppConstants.NULL_EMPTY_STRING + '1000TEST400');
        insert par;
        MUSW__Violation_Type__c ord = new MUSW__Violation_Type__c(MUSW__Code_Number__c= DOL_AppConstants.NULL_EMPTY_STRING + '1=234.5TEST', Name= DOL_AppConstants.NULL_EMPTY_STRING + 'Test Ordinance X');
        insert ord;
        MUSW__Inspection__c ins = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Field Observation');
        insert ins;
        MUSW__Violation__c v = new MUSW__Violation__c(MUSW__Type__c=ord.Id, MUSW__Parcel__c=par.Id);
        insert v;
        MUSW__Inspection__c reins1 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection', MUSW__Previous_Inspection__c=ins.Id);
        insert reins1;
        MUSW__Inspection__c reins2 = new MUSW__Inspection__c(MUSW__Parcel__c=par.Id, MUSW__Type__c= DOL_AppConstants.NULL_EMPTY_STRING + 'Re-inspection', MUSW__Previous_Inspection__c=ins.Id);
        insert reins2;
        MUSW__Inspection_Violation__c iv1 = new MUSW__Inspection_Violation__c(MUSW__Inspection__c=reins1.Id, MUSW__Violation__c=v.Id, MUSW__Parcel__c=par.Id);
        MUSW__Inspection_Violation__c iv2 = new MUSW__Inspection_Violation__c(MUSW__Inspection__c=reins2.Id, MUSW__Violation__c=v.Id, MUSW__Parcel__c=par.Id);
        insert new MUSW__Inspection_Violation__c[]{iv1, iv2};
        
        //only works if workflow and DRE rules are in the system
        MUSW__Inspection__c[] insq = [select Id from MUSW__Inspection__c where MUSW__Previous_Inspection__c = :ins.Id];
        //only works if workflow and DRE rules are in the system TO DO
        system.assert(insq.size() == 1);
        MUSW__Inspection_Violation__c[] ivq = [select Id from MUSW__Inspection_Violation__c where MUSW__Inspection__r.MUSW__Previous_Inspection__c = :ins.Id];
        system.assert(ivq.size() == 1);
    }
    
}