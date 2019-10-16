public class RenewalReinstatement{
  
public static Map<Id,Boolean> autoRenewReinstatement(List<Renewal_Application__c> renewReinstateList){
    Map<Id,Boolean> autoIdRenwewalMap = new Map<Id,Boolean>();
    Set<Id> setId = new Set<Id>();
    system.debug('renewReinstateList-----'+renewReinstateList);
    Set<Id> licenseSet = new Set<Id>();
    Map<Id,Date> idDateMap= new Map<Id,Date>();
    for(Renewal_Application__c renewreinstate :renewReinstateList ){
        setId.add(renewreinstate.id);
        licenseSet.add(renewreinstate.License__c);
    }
    
    for(MUSW__License2__c  msl: [select id,MUSW__Expiration_Date__c from MUSW__License2__c where id IN: licenseSet]){
        idDateMap.put(msl.id,msl.MUSW__Expiration_Date__c );
    }
    
    List<BGCK__Answer__c> ansList = [select id,Answer_Text__c,QuestionDOL__c,Renewal_Reinstatement_Application__c from BGCK__Answer__c where Renewal_Reinstatement_Application__c IN:setId AND QuestionDOL__r.Section__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'Legal Background Questions' AND QuestionDOL__r.Data_Type__c =: DOL_AppConstants.NULL_EMPTY_STRING + 'Yes_No' ];
    system.debug('ansList---'+ansList);
    
    Map<id,Boolean> reneUpdate = new Map<id,Boolean>();
    
    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
    
    if(!ansList.isEmpty()){
       for(Renewal_Application__c rene : renewReinstateList ){
            Integer numberOfQue = 0;
            Integer numberOfNo = 0;
            for(BGCK__Answer__c ans : ansList){
                if(ans.Renewal_Reinstatement_Application__c == rene.Id){
                    numberOfQue++;
                    if(ans.Answer_Text__c == 'No'){
                        numberOfNo++;
                    }
                }
            }
            system.debug('rene ---'+rene);
            system.debug('rene ---'+rene.Renewal_Status__c);
            system.debug('rene ---'+rene.License__c);
            system.debug('rene ----'+rene.License__r.MUSW__Expiration_Date__c);
            if(rene.Renewal_Status__c == 'Pending Payment' && numberOfQue != 0 && (numberOfQue == numberOfNo)){
                MUSW__License2__c license = new MUSW__License2__c(id= rene.License__c);
                license.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
                license.Application_Type__c = rene.Application_Type__c;
                license.MUSW__Issue_Date__c = System.today();
                system.debug('MUSW__Issue_Date__c ::'+license.MUSW__Issue_Date__c);
                license.MUSW__Renewal_Date__c = System.today();
                license.Renew_Reinstatement_in_progress__c = false;
                system.debug('MUSW__Renewal_Date__c i.e. Renewed/Reinstated Date::'+license.MUSW__Renewal_Date__c);
                /*if(rene.License__r.Is_Late_Renewal_Eligible__c || rene.License__r.Is_Reinstatement_Eligible__c){
                
                    license.MUSW__Issue_Date__c = System.today();
                    system.debug('MUSW__Issue_Date__c ::'+license.MUSW__Issue_Date__c);
                }else{
                    if(idDateMap.get(rene.License__c) != null){
                        license.MUSW__Issue_Date__c  = idDateMap.get(rene.License__c) + 1;
                        system.debug('MUSW__Issue_Date__c ::'+license.MUSW__Issue_Date__c);
                    }
                } */   
                
                licenseList.add(license);  
                system.debug('licenseList---'+licenseList);
                autoIdRenwewalMap.put(rene.Id,true);
            }   
        } 
    }
        
        
        if(!licenseList.isEmpty()){
           update licenseList;
        }
        
        return autoIdRenwewalMap;
    }
    
    @future
    public static void createReviewOnRenewal(List<Id> renewalIdList){
       try{ 
           system.debug('renewalIdList::'+ renewalIdList);
           Map<Id,Boolean> autoReneMap = new Map<Id,Boolean>();
           List<MUSW__Review__c> revList = new List<MUSW__Review__c>();
           Set<MUSW__Review__c> setReview = new Set<MUSW__Review__c>();
           List<MUSW__Review__c> resultRevList = new List<MUSW__Review__c>();
           List<Renewal_Application__c> renewList = new List<Renewal_Application__c>();
           List<Renewal_Application__c> renewToUpdate = new List<Renewal_Application__c>();
           List<String> LicensetoRenew =  new List<String>();
           List<String> LicensetoReinstate = new List<String>();
           List<Auto_Renew_Reinstate__mdt> renewMdt = [select Id,DeveloperName,License_Type__c  from Auto_Renew_Reinstate__mdt where DeveloperName =: DOL_AppConstants.NULL_EMPTY_STRING + 'Auto_Renewal' and DeveloperName != null limit 1];
           LicensetoRenew = (!renewMdt.isEmpty()) ? renewMdt[0].License_Type__c.split(',') : null;
           system.debug('LicensetoRenew::'+ LicensetoRenew);
           List<Auto_Renew_Reinstate__mdt> reinstateMdt = [select Id,DeveloperName,License_Type__c  from Auto_Renew_Reinstate__mdt where DeveloperName =: DOL_AppConstants.NULL_EMPTY_STRING + 'Auto_Reinstate' and DeveloperName != null limit 1];
           LicensetoReinstate = (!reinstateMdt.isEmpty())?reinstateMdt[0].License_Type__c.split(',') : null;
           system.debug('LicensetoReinstate::'+ LicensetoReinstate);
           List<Renewal_Application__c> getRenewRecords = [select id,Name,License__r.MUSW__Expiration_Date__c,Renewal_Status__c,licenserecordtype__c,AccountStatus__c,Physical_Address_Modified__c,renewal_reinstatement_type__c,license_business_name__c,license_number__c,applicant_full_name__c,License__c,application_type__c,Credential_Type__c from Renewal_Application__c where id IN:renewalIdList];
           system.debug('inside renewal');
           for(Renewal_Application__c renewal : getRenewRecords){
               System.debug('renewal:: '+renewal.Renewal_Status__c );
               system.debug('renewal.License__r.MUSW__Primary_Licensee__r.AccountStatus__c ');
               if(renewal.Renewal_Status__c == 'Pending Payment' && renewal.LicenseRecordType__c == DOL_AppConstants.BUSINESS && renewal.AccountStatus__c == DOL_AppConstants.ACTIVE){
                   system.debug('accc'+LicensetoRenew);
                   if(renewal.Renewal_Reinstatement_Type__c == 'Renewal' && LicensetoRenew!= null && LicensetoRenew.contains(renewal.Credential_Type__c) && (renewal.Physical_Address_Modified__c != true)){
                       system.debug('acc2Insidetext');
                       renewList.add(renewal);
                   }else if(renewal.Renewal_Reinstatement_Type__c == 'Reinstatement' && LicensetoReinstate !=null && LicensetoReinstate.contains(renewal.Credential_Type__c) && (renewal.Physical_Address_Modified__c != true)){
                       renewList.add(renewal);
                   }
               }
               else if(renewal.Renewal_Status__c == 'Pending Payment' && renewal.LicenseRecordType__c != DOL_AppConstants.BUSINESS ){
                   system.debug('inside inreview'+LicensetoRenew);
                   if(renewal.Renewal_Reinstatement_Type__c == 'Renewal' && LicensetoRenew!= null && LicensetoRenew.contains(renewal.Credential_Type__c) && renewal.Physical_Address_Modified__c != true){
                       system.debug('acc2');
                       renewList.add(renewal);
                   }else if(renewal.Renewal_Reinstatement_Type__c == 'Reinstatement' && LicensetoReinstate !=null && LicensetoReinstate.contains(renewal.Credential_Type__c) && (renewal.Physical_Address_Modified__c != true)){
                       renewList.add(renewal);
                   }
                   
               }
           }
           if(!renewList.isEmpty()){
               autoReneMap = autoRenewReinstatement(renewList);
           }
           for(Renewal_Application__c ren : getRenewRecords){
                MUSW__Review__c rev = new MUSW__Review__c();
                rev.name = (ren.licenserecordtype__c == 'Business' || ren.licenserecordtype__c == 'Course') ? (ren.renewal_reinstatement_type__c + ' Review - '+ ren.license_business_name__c + '/'+ ren.license_number__c) : (ren.renewal_reinstatement_type__c + ' Review - '+ ren.applicant_full_name__c + '/'+ ren.license_number__c) ;
                rev.MUSW__Status__c = (autoReneMap.keyset().contains(ren.id)) ? 'Approved' : 'Pending';
                rev.Application_Type__c = ren.application_type__c;
                rev.License_Type__c = ren.Credential_Type__c;
                rev.Review_Type__c = ren.renewal_reinstatement_type__c;
                rev.License__c = ren.License__c;
                rev.Renewal_Application__c = ren.id;
                revList.add(rev);
                if(autoReneMap.keyset().contains(ren.id)){
                   ren.Auto_Renew__c = autoReneMap.get(ren.id);
                   ren.Renewal_Status__c = DOL_AppConstants.COMPLETE;
                   
                }else{
                    ren.Renewal_Status__c = DOL_AppConstants.IN_REVIEW;
                }
                renewToUpdate.add(ren);
           
           }
           setReview.addAll(revList);
           resultRevList.addAll(setReview);
           if(!resultRevList.isEmpty()){
                insert resultRevList;
           }
           if(!renewToUpdate.isEmpty()){
                update renewToUpdate;
            } 
          }catch(Exception ex){
                DOL_CreateErrorLog_Exception.logApplicationError(ex);
          }
    }
}