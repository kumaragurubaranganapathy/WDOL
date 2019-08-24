/*
Name: LnP_generateFeeRecords_Class
Description: LnP_generateFeeRecords_Class is used to generate the fee records for License.
Created By:Chiranrh Aradhya 
Created Date: 08/20/2019
*/
public with sharing class LnP_generateFeeRecords_Class {
 @AuraEnabled
    public static String generateFeeRecords(Id licenseId) {
        try{
            
            MUSW__License2__c license_Rec = new MUSW__License2__c();
            license_Rec = [Select Id,MUSW__Status__c,Manual_Fee_Generation__c,MUSW__Primary_Licensee__r.business_structure__c,Credential_Type__c,Initial_Contracts__c,Application_Type__c,Application_Method__c,Is_Reinstatement_Eligible__c,Application__c,Number_of_Units__c,Is_Renewal_Eligible__c FROM MUSW__License2__c  where Id =:licenseId ];
                    
            String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
            String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status;
            String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
            
            if(license_Rec.MUSW__Status__c != FeeGenartionCheckStatus){
                return FeeGenarationStatusError;
            }else{
                license_Rec.Manual_Fee_Generation__c = True;
                update license_Rec;
                return 'true';
            }          
            /*
            
                    List<MUSW__Master_Fee_List__c> MasterFeelist = new List <MUSW__Master_Fee_List__c>();
                    List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
                    List<MUSW__Fee__c> InsertedfeeList = new List<MUSW__Fee__c>();
                    MUSW__License2__c license_Rec = new MUSW__License2__c();
                   
                    String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
                    String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status;
                    String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
                    
                    license_Rec = [Select Id,MUSW__Status__c,MUSW__Primary_Licensee__r.business_structure__c,Credential_Type__c,Initial_Contracts__c,Application_Type__c,Application_Method__c,Is_Reinstatement_Eligible__c,Application__c,Number_of_Units__c,Is_Renewal_Eligible__c FROM MUSW__License2__c  where Id =:licenseId ];
                    
                    String licenseApplicationMethod = license_Rec.Application_Method__c;
                    String licenseCredentialType = license_Rec.Credential_Type__c;
                    String licenseApplicationType = license_Rec.Application_Type__c;
                    
                    if(license_Rec.MUSW__Status__c != FeeGenartionCheckStatus){
                        return FeeGenarationStatusError;
                    }else{
                    
                            String Query ='Select Name,Id,Active__c,Agency__c,License_Type__c,Credential_Type__c,Profession_Code__c,Revenue_Code__c,Fee_Calculation_Type__c,Fee_Type__c,Base__c,Business_Structure__c,Fee_Formula_Amount__c,Is_Endorsement__c,Application_Type__c,Portal_Name__c,Agency_Number__c,Credential__c,Application_Method__c from MUSW__Master_Fee_List__c where Active__c = True AND Base__c != null AND Is_Endorsement__c = False AND Application_Method__c =: licenseApplicationMethod AND Credential_Type__c =: licenseCredentialType AND Application_Type__c =: licenseApplicationType';
                        
                            MasterFeelist= Database.Query(Query);
                        
                            for(MUSW__Master_Fee_List__c msFeeRec:MasterFeelist){
                                
                                 if(msFeeRec.Application_Method__c == license_Rec.Application_Method__c && license_Rec.Credential_Type__c == msFeeRec.Credential_Type__c && msFeeRec.Application_Type__c == license_Rec.Application_Type__c && license_Rec.MUSW__Primary_Licensee__r.business_structure__c != null && license_Rec.MUSW__Primary_Licensee__r.business_structure__c == msFeeRec.Business_Structure__c ){
                                                                                
                                            MUSW__Fee__c Fee_record = new MUSW__Fee__c();
                                            Fee_record.MUSW__Type__c = msFeeRec.Fee_Type__c;
                                            //Fee_record.MUSW__Amount__c = Amt;
                                            Fee_record.MUSW__Amount__c = msFeeRec.Base__c;
                                            Fee_record.Agency__c =msFeeRec.Agency__c;
                                            Fee_record.Revenue_Code__c =msFeeRec.Revenue_Code__c;
                                            Fee_record.Application_Type__c =msFeeRec.Application_Type__c;
                                            Fee_record.portal_name__c =msFeeRec.Portal_Name__c;
                                            Fee_record.Agency_Number__c =msFeeRec.Agency_Number__c;
                                            Fee_record.Profession_Code__c =msFeeRec.Profession_Code__c;
                                            Fee_record.Application_Method__c =msFeeRec.Application_Method__c;
                                            Fee_record.License_Type__c =msFeeRec.License_Type__c;
                                            Fee_record.Fee_Name__c= msFeeRec.Name;
                                            Fee_record.MUSW__License2__c = license_Rec.Id;
                                            feeList.add(Fee_record);
                                            
                                        }else if(msFeeRec.Application_Method__c == license_Rec.Application_Method__c && license_Rec.Credential_Type__c == msFeeRec.Credential_Type__c && msFeeRec.Application_Type__c == license_Rec.Application_Type__c && license_Rec.MUSW__Primary_Licensee__r.business_structure__c == null){
                                            
                                            MUSW__Fee__c Fee_record = new MUSW__Fee__c();
                                            Fee_record.MUSW__Type__c = msFeeRec.Fee_Type__c;
                                            //Fee_record.MUSW__Amount__c = Amt;
                                            Fee_record.MUSW__Amount__c = msFeeRec.Base__c;
                                            Fee_record.Agency__c =msFeeRec.Agency__c;
                                            Fee_record.Revenue_Code__c =msFeeRec.Revenue_Code__c;
                                            Fee_record.Application_Type__c =msFeeRec.Application_Type__c;
                                            Fee_record.portal_name__c =msFeeRec.Portal_Name__c;
                                            Fee_record.Agency_Number__c =msFeeRec.Agency_Number__c;
                                            Fee_record.Profession_Code__c =msFeeRec.Profession_Code__c;
                                            Fee_record.Application_Method__c =msFeeRec.Application_Method__c;
                                            Fee_record.License_Type__c =msFeeRec.License_Type__c;
                                            Fee_record.Fee_Name__c= msFeeRec.Name;
                                            Fee_record.MUSW__License2__c = license_Rec.Id;
                                            feeList.add(Fee_record);
                                        }
                                        
                            }
                        
                            if(!feeList.isEmpty()){
                                InsertedfeeList = Utilityclass_withsharing.insertList(feeList);
                                if(!InsertedfeeList.isEmpty()){
                                    license_Rec.MUSW__Status__c =FeeGenartionCompletedStatus;
                                    update license_Rec;
                                    return 'True';
                                }
                            }
                        
                            
                            license_Rec.MUSW__Status__c =FeeGenartionCompletedStatus;
                            update license_Rec;
                        
                        }
                    
                    return 'False';
             
            */
             
        }catch(Exception e){
            DOL_CreateErrorLog_Exception.logApplicationError(e,'LnP_generateFeeRecords_Class','generateFeeRecords');return 'False';}
        
    }
    
    @AuraEnabled
    public static String generateFeeRecords_Renewals(Id renewalId) {
        try{
                   

            String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
            String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status_Renewal;
            String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
            
            Renewal_Application__c renewal_Rec = new Renewal_Application__c();
            
            renewal_Rec =[Select Id,Renewal_Status__c,Manual_Fee_Generation__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where Id =:renewalId];
            
            if(renewal_Rec.Renewal_Status__c != FeeGenartionCheckStatus){
                return FeeGenarationStatusError;
            }else{
                renewal_Rec.Manual_Fee_Generation__c=True;
                update renewal_Rec;
                return 'True';
            }

            /*
                       
            List<MUSW__Master_Fee_List__c> MasterFeelist = new List <MUSW__Master_Fee_List__c>();
            List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
            List<MUSW__Fee__c> InsertedfeeList = new List<MUSW__Fee__c>();
            
            String FeeGenartionCheckStatus = Label.Fee_Generation_Check_Status;
            String FeeGenartionCompletedStatus = Label.Fee_Generation_Completed_Status_Renewal;
            String FeeGenarationStatusError =Label.Fee_Generation_Status_Error;
            
            Renewal_Application__c renewal_Rec = new Renewal_Application__c();
            
            renewal_Rec =[Select Id,Renewal_Status__c,Manual_Fee_Generation__c,Renewal_Reinstatement_Type__c,Credential_Type__c,Application_Type__c,Applicant__c,License_Account__c,License__c,License__r.Is_Late_Renewal_Eligible__c, License__r.Deployed__c from Renewal_Application__c where License__c != null AND License__r.Deployed__c = False AND License_Account__c = null AND Application_Type__c != null AND Id =:renewalId];
            
            
            String renewalApplicationMethod = renewal_Rec.Renewal_Reinstatement_Type__c;
            String renewalCredentialType = renewal_Rec.Credential_Type__c;
            String renewalApplicationType = renewal_Rec.Application_Type__c;
           
            if(renewal_Rec.Renewal_Status__c != FeeGenartionCheckStatus){
                return FeeGenarationStatusError;
            
            }else{
              String Query;
              if(renewal_Rec.License__r.Is_Late_Renewal_Eligible__c == False ){
            
                Query ='Select Name,Id,Active__c,Agency__c,is_Late_Renewal__c,License_Type__c,Credential_Type__c,Profession_Code__c,Revenue_Code__c,Fee_Calculation_Type__c,Fee_Type__c,Base__c,Business_Structure__c,Fee_Formula_Amount__c,Is_Endorsement__c,Application_Type__c,Portal_Name__c,Agency_Number__c,Credential__c,Application_Method__c from MUSW__Master_Fee_List__c where Active__c = True AND Base__c != null AND Is_Endorsement__c = False AND is_Late_Renewal__c = False AND Application_Method__c =: renewalApplicationMethod AND Credential_Type__c =: renewalCredentialType AND Application_Type__c =: renewalApplicationType';
                
                }else if(renewal_Rec.License__r.Is_Late_Renewal_Eligible__c == True ){
                    Query ='Select Name,Id,Active__c,Agency__c,is_Late_Renewal__c,License_Type__c,Credential_Type__c,Profession_Code__c,Revenue_Code__c,Fee_Calculation_Type__c,Fee_Type__c,Base__c,Business_Structure__c,Fee_Formula_Amount__c,Is_Endorsement__c,Application_Type__c,Portal_Name__c,Agency_Number__c,Credential__c,Application_Method__c from MUSW__Master_Fee_List__c where Active__c = True AND Base__c != null AND Is_Endorsement__c = False AND Application_Method__c =: renewalApplicationMethod AND Credential_Type__c =: renewalCredentialType AND Application_Type__c =: renewalApplicationType';
                }
                
            
                MasterFeelist= Database.Query(Query);
                
                for(MUSW__Master_Fee_List__c msFeeRec:MasterFeelist){
                    
                     if(msFeeRec.Application_Method__c == renewal_Rec.Renewal_Reinstatement_Type__c && renewal_Rec.Credential_Type__c == msFeeRec.Credential_Type__c && msFeeRec.Application_Type__c == renewal_Rec.Application_Type__c ){
                            
                               
                                MUSW__Fee__c Fee_record = new MUSW__Fee__c();
                                Fee_record.MUSW__Type__c = msFeeRec.Fee_Type__c;
                                //Fee_record.MUSW__Amount__c =Decimal.valueOf(msFeeRec.Fee_Formula_Amount__c);
                                Fee_record.MUSW__Amount__c = msFeeRec.Base__c;
                                Fee_record.Agency__c =msFeeRec.Agency__c;
                                Fee_record.Revenue_Code__c =msFeeRec.Revenue_Code__c;
                                Fee_record.Application_Type__c =msFeeRec.Application_Type__c;
                                Fee_record.portal_name__c =msFeeRec.Portal_Name__c;
                                Fee_record.Agency_Number__c =msFeeRec.Agency_Number__c;
                                Fee_record.Profession_Code__c =msFeeRec.Profession_Code__c;
                                Fee_record.Application_Method__c =msFeeRec.Application_Method__c;
                                Fee_record.License_Type__c =msFeeRec.License_Type__c;
                                Fee_record.Fee_Name__c= msFeeRec.Name;
                                Fee_record.Renewal_Application__c = renewal_Rec.Id;
                                feeList.add(Fee_record);
                                
                            }
                }
                
                if(!feeList.isEmpty()){
                    InsertedfeeList = Utilityclass_withsharing.insertList(feeList);
                    if(!InsertedfeeList.isEmpty()){
                        renewal_Rec.Renewal_Status__c =FeeGenartionCompletedStatus;
                        update renewal_Rec;
                        return 'True';
                    }
                }
            }
            return 'False';
            */
            
        }catch(Exception e){DOL_CreateErrorLog_Exception.logApplicationError(e,'LnP_generateFeeRecords_Class','generateFeeRecords_Renewals');return 'False';}
        
    }
}