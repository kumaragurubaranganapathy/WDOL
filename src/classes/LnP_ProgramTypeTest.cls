@isTest
public class LnP_ProgramTypeTest {

     
    public static testMethod void setupMethod(){
        //creating Deposit
        MUSW__Deposit__c deposit = new MUSW__Deposit__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'System Number');
        deposit.Amount__c = 100.00;
        deposit.wadol_Program_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Misc Payments';
        insert deposit;
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.MUSW__Amount_Tendered__c = 100.00;
        receipt.MUSW__Payment_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Cash';
        insert receipt;
        
        Lockbox_Envelope__c lockbox = new Lockbox_Envelope__c(); insert lockbox;
        
        
        Customer_Envelope__c cEnve = TestUtility.getCEnvelope();
        cEnve.Lockbox_Envelope__c = lockbox.id;
        insert cEnve;
 
        
        list<MUSW__Deposit__c> depList = [Select Id, Amount__c, wadol_Program_Type__c from MUSW__Deposit__c];
        list<MUSW__Receipt__c> recList = [Select Id,MUSW__Amount_Tendered__c,MUSW__Payment_Method__c from MUSW__Receipt__c];
       // system.debug('depLst : '+depLst);
        //system.debug('recLst : '+recLst);
        
        Customer_Envelope__c custEnv = new Customer_Envelope__c();
        MUSW__License2__c obj = new MUSW__License2__c();
        
        Test.startTest();
        try{
        LnP_ProgramType.getDependency(obj,'Application_Type__c','Credential_Type__c');
        }
        catch(Exception e){}
         try{
             LnP_ProgramType.deleteCustomerEnvelope(custEnv);
         }
         catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            }
             Map<String, String> mapDefProgramType = LnP_ProgramType.getDefaultProgramType();
             Map<String, String> mapPayment = LnP_ProgramType.getPayment();
             Map<String, String> mapProgramType = LnP_ProgramType.getProgramType();
             Map<String, String> mapFormNumber = LnP_ProgramType.getFormNumber();
             LnP_ProgramType.getDepositInfo();
             try{
             LnP_ProgramType.saveReciept(recList);
             }catch(Exception ex){}
             List<ListView> listViewList = LnP_ProgramType.getObjViews();
             try{
             LnP_ProgramType.saveReciptRecords(receipt);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateRecieptRec(recList[0]);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.saveDeposit_Receipt_Records(depList[0]);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateDepositRec(depList[0]);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateEnvelopRec('Architect', recList, depList, custEnv, lockbox.id);
             }catch(Exception ex){}
           try{
             LnP_ProgramType.getValidationNumberInfo();
           }catch(Exception ex){}
           try{
             LnP_ProgramType.updateEnvelopRec('Architect', null, depList, custEnv, lockbox.id);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateEnvelopRec('Architect', null, depList, null, lockbox.id);
             }catch(Exception ex){}
        Test.stopTest();
    }
    
    public static testMethod void setupMethod2(){
        //creating Deposit
        MUSW__Deposit__c deposit = new MUSW__Deposit__c(Name = DOL_AppConstants.NULL_EMPTY_STRING + 'System Number');
        deposit.Amount__c = 100.00;
        deposit.wadol_Program_Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Misc Payments';
        insert deposit;
        
        MUSW__Receipt__c receipt = new MUSW__Receipt__c();
        receipt.MUSW__Amount_Tendered__c = 100.00;
        receipt.MUSW__Payment_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Cash';
        insert receipt;
        
        Lockbox_Envelope__c lockbox = new Lockbox_Envelope__c(); insert lockbox;
        
        
        Customer_Envelope__c cEnve = TestUtility.getCEnvelope();
        cEnve.Lockbox_Envelope__c = lockbox.id;
        insert cEnve;
 
        
        list<MUSW__Deposit__c> depList = [Select Id, Amount__c, wadol_Program_Type__c from MUSW__Deposit__c];
        list<MUSW__Receipt__c> recList = [Select Id,MUSW__Amount_Tendered__c,MUSW__Payment_Method__c from MUSW__Receipt__c];
       // system.debug('depLst : '+depLst);
        //system.debug('recLst : '+recLst);
        
        Customer_Envelope__c custEnv = new Customer_Envelope__c();
        MUSW__License2__c obj = new MUSW__License2__c();
        
        Test.startTest();
        
             try{
             LnP_ProgramType.updateEnvelopRec('Architect', null, depList, null, null);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateEnvelopRec('Architect', recList, null, null, null);
             }catch(Exception ex){}
             try{
             LnP_ProgramType.updateDepositRec(null);
             }catch(Exception ex){}
              try{
             LnP_ProgramType.updateRecieptRec(null);
             }catch(Exception ex){}
             
        Test.stopTest();
    }
}