public class LnP_ReceiptDHPPopupModalCtrl {
    
    @AuraEnabled
    public static String saveLicenseandReceipt(Id receiptId){
        try{
            MUSW__Receipt__c receiptRec = [Select Id,
                                           MUSW__Amount_Tendered__c,
                                           MUSW__Check_Number__c,
                                           MUSW__Payment_Method__c,
                                           DHP__c,
                                           Inactivate_License_Date__c,
                                           Override_25_Handling_Fee__c,
                                           Sent_to_Collections__c,
                                           Reason_for_DHP__c 
                                           FROM MUSW__Receipt__c
                                           WHERE Id = :receiptId
                                          ];
            
            
            List<MUSW__Fee_Payment__c> feePaymentRecList = [SELECT Id, 
                                                            Name,
                                                            MUSW__Receipt__c,
                                                            Related_To_License__c, 
                                                            MUSW__Fee__c,  
                                                            Related_to__c 
                                                            FROM MUSW__Fee_Payment__c
                                                            WHERE MUSW__Receipt__c = :receiptId
                                                           ];
            System.debug('feePaymentRecList : ' +feePaymentRecList );
            
            Set<ID> licenseIdSet = new Set<ID>();
            for(MUSW__Fee_Payment__c feePaymentRec : feePaymentRecList){
                licenseIdSet.add(feePaymentRec.Related_To_License__c);
            }  
            System.debug('licenseIdSet : ' +licenseIdSet );
            
            //license associated to current receipt
            List<MUSW__License2__c> licenseToBeUpdated = [Select Id,
                                                          Sub_Status__c
                                                          FROM MUSW__License2__c 
                                                          WHERE Id IN :licenseIdSet
                                                         ];
            System.debug('licenseToBeUpdated : ' +licenseToBeUpdated );
            
            
            // for Fee Creation logic
            system.debug('receiptRec.Override_25_Handling_Fee__c : '+receiptRec.Override_25_Handling_Fee__c);
            if(receiptRec.Override_25_Handling_Fee__c == false){
                List<MUSW__Fee__c> feeTobeInserted = new List<MUSW__Fee__c>();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    MUSW__Fee__c feeRec = new MUSW__Fee__c(MUSW__Type__c = 'DHP', 
                                                           MUSW__Amount__c = 25.00,
                                                           MUSW__Description__c = 'DHP Fees', 
                                                           Voided_Receipt_Amount__c = receiptRec.MUSW__Amount_Tendered__c ,
                                                           Voided_Receipt_Check_Number__c =  receiptRec.MUSW__Check_Number__c,
                                                           Voided_Receipt_Payment_Method__c = receiptRec.MUSW__Payment_Method__c,
                                                           Voided_Receipt_Amount_DHP_Amount__c = receiptRec.MUSW__Amount_Tendered__c + 25.00
                                                          );
                    feeRec.MUSW__License2__c = licRec.Id;
                    feeTobeInserted.add(feeRec);
                }
                system.debug('Before Insert ' + feeTobeInserted);
                if(!feeTobeInserted.isEmpty()){
                    insert feeTobeInserted;
                }
                system.debug('after Insert ' + feeTobeInserted);  
            }
            
            //for Sub Status logic
            system.debug('receiptRec.DHP__c : '+receiptRec.DHP__c);
            if(receiptRec.DHP__c == true){
                List<MUSW__License2__c> licenseToBeUpdatedwithDHP = new List<MUSW__License2__c> ();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    licRec.Sub_Status__c = 'DHP';
                    licRec.DHP_Stamp_Date__c = System.today();
                    licenseToBeUpdatedwithDHP.add(licRec);
                }
                system.debug('Before Update ' + licenseToBeUpdatedwithDHP);
                if(!licenseToBeUpdatedwithDHP.isEmpty()){
                    update licenseToBeUpdatedwithDHP;
                }
                system.debug('after Update ' + licenseToBeUpdatedwithDHP);            
            }
            
    //for Status - > Inactive logic
            system.debug('receiptRec.Inactivate_License_Date__c : '+receiptRec.Inactivate_License_Date__c);
            if(receiptRec.Inactivate_License_Date__c == System.today()){
                List<MUSW__License2__c> licenseToBeUpdatedInactive = new List<MUSW__License2__c> ();
                for(MUSW__License2__c licRec : licenseToBeUpdated){
                    licRec.MUSW__Status__c = 'Inactive';
                    licenseToBeUpdatedInactive.add(licRec);
                }
                system.debug('Before Update ' + licenseToBeUpdatedInactive);
                if(!licenseToBeUpdatedInactive.isEmpty()){
                    update licenseToBeUpdatedInactive;
                }
                system.debug('after Update ' + licenseToBeUpdatedInactive);            
            }
            
            return 'Success';
            
        }catch(Exception e){
            system.debug('***EXCEPTION***' + e.getMessage());
            system.debug('***STACK TRACE***' + e.getStackTraceString());
            return 'Failure';
        }
        
    }
}