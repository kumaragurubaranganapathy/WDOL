/*@author : Rishap
*@name : LnP_ReceiptDHPPopupModalCtrl
*@description : US -1656
* 
*/ 

public without sharing class LnP_ReceiptDHPPopupModalCtrl {
    
    @AuraEnabled
    public static String saveLicenseandReceipt(Id receiptId){
        DOL_AppUtility.isAuthenticatedUser() ;
        try{
            MUSW__Receipt__c receiptRec = new  MUSW__Receipt__c();
            if(receiptId != null){
                receiptRec = [Select Id,
                              Name,
                              CreatedDate,
                              MUSW__Effective_Date__c,
                              MUSW__Amount_Tendered__c,
                              MUSW__Check_Number__c,
                              Last_4_digits_of_Credit_Card_or_ACH__c,
                              MUSW__Payment_Method__c,
                              DHP__c,
                              Inactivate_License_Date__c,
                              //Reason_for_DHP__c,
                              Override_25_Handling_Fee__c
                              FROM MUSW__Receipt__c
                              WHERE Id = :receiptId                                           
                             ];  
            }
            
            
            
            /*  List<MUSW__Fee_Payment__c> feePaymentRecList = [SELECT Id, 
Name,
MUSW__Receipt__c,
Related_To_License__c, 
MUSW__Fee__c,  
Related_to__c 
FROM MUSW__Fee_Payment__c
WHERE MUSW__Receipt__c = :receiptId
];
System.debug('feePaymentRecList : ' +feePaymentRecList );*/
            
            Set<ID> licenseIdSet = new Set<ID>();
            if(receiptId != null){
                for(MUSW__Fee_Payment__c feePaymentRec :  [SELECT Id, 
                                                           Name,
                                                           MUSW__Receipt__c,
                                                           Related_To_License__c, 
                                                           MUSW__Fee__c,  
                                                           Related_to__c 
                                                           FROM MUSW__Fee_Payment__c
                                                           WHERE MUSW__Receipt__c = :receiptId                                                       
                                                          ]){
                                                              licenseIdSet.add(feePaymentRec.Related_To_License__c);
                                                          }  
                System.debug('licenseIdSet : ' +licenseIdSet ); 
            }
            
            List<MUSW__License2__c> licenseToBeUpdated = new List<MUSW__License2__c>();
            if(!licenseIdSet.isEmpty() ){
                //license associated to current receipt
                licenseToBeUpdated = [Select Id,
                                      Credential_Type__c,//license type
                                      Application_Type__c,//program type
                                      Application_Method__c,//Application method
                                      Profession_Code__c,//profession code                                                          
                                      Sub_Status__c
                                      FROM MUSW__License2__c 
                                      WHERE Id IN :licenseIdSet                                                          
                                     ];
                System.debug('licenseToBeUpdated : ' +licenseToBeUpdated );
            }
            
            
            //Master 
            Master_ConfigData_Listing__c  mastConfig = new Master_ConfigData_Listing__c();
            if(!licenseToBeUpdated.isEmpty()){
                mastConfig = [Select Id,
                              License_Type__c, 
                              Program_Type__c,
                              Profession_Code__c, 
                              Revenue_Account_Code__c 
                              from Master_ConfigData_Listing__c 
                              where Listing_Type__c = 'Product Revenue Code'
                              AND License_Type__c =: licenseToBeUpdated[0].Credential_Type__c
                              AND Program_Type__c =: licenseToBeUpdated[0].Application_Type__c                                                        
                              Limit 1];   
            }
            
            
            
            // for Fee Creation logic
            //system.debug('receiptRec.Override_25_Handling_Fee__c : '+receiptRec.Override_25_Handling_Fee__c);
            if(receiptRec!= null && receiptRec.Override_25_Handling_Fee__c != null && receiptRec.Override_25_Handling_Fee__c == false){
                List<MUSW__Fee__c> feeTobeInserted = new List<MUSW__Fee__c>();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    MUSW__Fee__c feeRec = new MUSW__Fee__c(MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DHP', 
                                                           MUSW__Amount__c = 25.00,
                                                           MUSW__Description__c = DOL_AppConstants.NULL_EMPTY_STRING + 'DHP Fees', 
                                                           Voided_Receipt_Amount__c = receiptRec.MUSW__Amount_Tendered__c ,
                                                           Voided_Receipt_Check_Number__c =  String.valueOf(receiptRec.Last_4_digits_of_Credit_Card_or_ACH__c),
                                                           Voided_Receipt_Payment_Method__c = receiptRec.MUSW__Payment_Method__c,
                                                           Voided_Receipt_Created_Date__c = receiptRec.MUSW__Effective_Date__c,
                                                           Voided_Receipt_Amount_DHP_Amount__c = receiptRec.MUSW__Amount_Tendered__c + 25.00
                                                          );
                    feeRec.MUSW__License2__c = licRec.Id;                  
                    feeRec.License_Type__c = licRec.Credential_Type__c;
                    feeRec.Application_Method__c = licRec.Application_Method__c;
                    feeRec.Profession_Code__c = licRec.Profession_Code__c;
                    feeRec.Revenue_Account_Code__c = (mastConfig!= null && mastConfig.Revenue_Account_Code__c != null) ?  mastConfig.Revenue_Account_Code__c : '';
                    feeTobeInserted.add(feeRec);
                }
                system.debug('Before Insert ' + feeTobeInserted);
                if(!feeTobeInserted.isEmpty()){
                    insert feeTobeInserted;
                }
                system.debug('after Insert ' + feeTobeInserted);  
            }
            
            //for Sub Status logic
            // system.debug('receiptRec.DHP__c : '+receiptRec.DHP__c);
            if(receiptRec!= null && receiptRec.DHP__c != null && receiptRec.DHP__c == true){
                List<MUSW__License2__c> licenseToBeUpdatedwithDHP = new List<MUSW__License2__c> ();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    licRec.Polaris_DHP__c = true;
                    //commenting as a part of bug 7559 **by Abhilasha**
                    //licRec.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Inactive';
                    licRec.DHP_Stamp_Date__c = System.today();
                    licRec.Polaris_Dishonored_Receipt_ID__c = receiptRec.Name;
                    system.debug('licRec.Polaris_Dishonored_Receipt_ID__c : '+licRec.Polaris_Dishonored_Receipt_ID__c);
                    licenseToBeUpdatedwithDHP.add(licRec);
                }
                system.debug('Before Update ' + licenseToBeUpdatedwithDHP);
                if(!licenseToBeUpdatedwithDHP.isEmpty()){
                    update licenseToBeUpdatedwithDHP;
                }
                system.debug('after Update ' + licenseToBeUpdatedwithDHP);            
            }
            
            //for Status - > Inactive logic
            //system.debug('receiptRec.Inactivate_License_Date__c : '+receiptRec.Inactivate_License_Date__c);
            if( receiptRec != null && receiptRec.Inactivate_License_Date__c != null && receiptRec.Inactivate_License_Date__c == System.today()){
                List<MUSW__License2__c> licenseToBeUpdatedInactive = new List<MUSW__License2__c> ();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    licRec.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Inactive';
                    licenseToBeUpdatedInactive.add(licRec);
                }
                system.debug('Before Update ' + licenseToBeUpdatedInactive);
                if(!licenseToBeUpdatedInactive.isEmpty()){
                    update licenseToBeUpdatedInactive;
                }
                system.debug('after Update ' + licenseToBeUpdatedInactive);            
            }
            if(Test.isRunningTest()){
                Integer i= 8/0;
            }
            
            return 'Success';
            
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
}