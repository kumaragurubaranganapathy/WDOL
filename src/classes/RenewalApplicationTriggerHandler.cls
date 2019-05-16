/**
* Name: RenewalApplicationTriggerHandler
* Type: Class
* Description: Trigger Handler for Renewal_Application__c object being called from RenewalApplicationTrigger
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
*													Initial Creation
* 08/22/2018   Srikanth Kottam/Deloitte          	Apex Sharing
**/

public class RenewalApplicationTriggerHandler  implements BGCM.ITriggerHandler  {
    public static user u;
    public RenewalApplicationTriggerHandler() {
        u = [Select Id, UserType, Is_Portal_User__c From User where Id = :UserInfo.getUserId()];
    }
    public void onAfterDelete() {}
    public void onAfterInsert() { 
        System.debug('()()()After Insert before aftermethod');
        afterMethod();
        System.debug('()()()After Insert after aftermethod');
        
    }
    public void onAfterUndelete() {}
    public void onAfterUpdate() {
        System.debug('()()()After update');
        afterMethod();
    }
    public void onBeforeDelete() {}
    public void onBeforeInsert() {
        System.debug('()()()before insert');
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.BeforeInsert);
            handler.process();
        }
        beforeMethod();
        updateAccountInfo(trigger.new);
    }
    public void onBeforeUndelete() {}
    public void onBeforeUpdate() {
        System.debug('()()()before update');
        if (u.Is_Portal_User__c == true) {
            //This method is for base validation on license details provided by the Applicant
            SObjectTriggerHandler handler = new SObjectTriggerHandler(Trigger.New,SObjectTriggerHandler.Action.beforeupdate);               
            handler.process();
        }
        beforeMethod();
        beforemethod1();
        DRESequence();
    }
    
    
    public void beforeMethod(){
        System.debug('()()() in before method');
        Set<String> setBypassStatuses = new Set<String>();
        System.debug('()()() Label.ST_Incomplete '+Label.ST_Incomplete);
        if(Label.ST_Incomplete != null){
            setBypassStatuses.addAll(Label.ST_Incomplete.split(','));
        }
        
        Map<Id, Decimal> mapLicenseTotalFee = new Map<Id, Decimal>();
        if(trigger.isUpdate){
            for(AggregateResult ar : [Select Renewal_Application__c, SUM(MUSW__Amount__c) amt, SUM(MUSW__Amount_Waived__c) wamt From MUSW__Fee__c where Renewal_Application__c IN :trigger.New group by Renewal_Application__c]){
                Decimal feeAmt = (Decimal) ar.get('amt');
                Decimal feeWaivedAmt = (Decimal) ar.get('wamt');
                if(feeAmt == null) feeAmt = 0;
                if(feeWaivedAmt == null) feeWaivedAmt = 0;
                mapLicenseTotalFee.put((Id) ar.get('Renewal_Application__c'), feeAmt - feeWaivedAmt);
            }
        }
        
        System.debug('()()() after if check on Label.ST_Incomplete ');
        List<Renewal_Application__c> lstTriggerNew = new List<Renewal_Application__c>();
        List<Renewal_Application__c> lstTriggerOld = new List<Renewal_Application__c>();
        Map<Id,Renewal_Application__c> triggerOldMap = (Map<Id,Renewal_Application__c>)trigger.OldMap;
        
        for(Renewal_Application__c renewal : (List<Renewal_Application__c>)Trigger.new){
            System.debug('renewal.CE_Hours__c '+renewal.CE_Hours__c);
            if(setBypassStatuses.contains(renewal.Renewal_Status__c) == false){
                System.debug('()()() in if setBypassStatuses.contains(renewal.Renewal_Status__c) == false ');            
                lstTriggerNew.add(renewal);
                
                if(trigger.Old != null){
                    lstTriggerOld.add(triggerOldMap.get(renewal.Id));
                }
            }
            if(renewal.Renewal_Status__c == Label.ST_Complete && renewal.Renewed_Date__c == null && (triggerOldMap == null || renewal.Renewal_Status__c != triggerOldMap.get(renewal.id).Renewal_Status__c)){
                renewal.Renewed_Date__c = Date.today();
            }
            
            //  ExpirationDatesConfigHelper.EvaluateRulesLR(trigger.New);
            System.debug('()()() before feeAmt ');            
            Decimal feeAmt = mapLicenseTotalFee.get(renewal.Id);
            if(renewal.Id != null && feeAmt != null && renewal.Total_Fees__c != feeAmt){
                renewal.Total_Fees__c = feeAmt;
                
                if(renewal.Total_Fees__c == renewal.Total_Payments__c){
                    if(renewal.Renewal_Status__c != ''){
                        renewal.Renewal_Status__c = 'Submitted';
                    }
                }
            }
        }
        /*if(renewalIds.size() > 0){
           List<Renewal_Application__c> renewalList = [SELECT ID, CE_Hours__c, license__r.CE_Hours__c, license__r.CE_Eligible__c
                                                      FROM Renewal_Application__c
                                                      WHERE ID IN :renewalIds];
                
        //if(renewal.license__r.CE_Eligible__c){
              //  renewal.CE_Hours__c = renewal.license__r.CE_Hours__c;
            //}
            
        }*/
        
        System.debug('()()() before if lstTriggerNew.size() ');            
        if(lstTriggerNew.size() > 0 &&  Trigger.isUpdate){
            System.debug('()()() before if lstTriggerNew.size() ');                    
            String actionType = (Trigger.isUpdate) ? Label.Str_Update : ((Trigger.isInsert) ? Label.Str_Insert : Label.Str_Delete);
                BGBK.TriggerManager.DREGeneric(actionType, lstTriggerNew, lstTriggerOld);
        }
        
        for(sObject sObj : trigger.New){
            Renewal_Application__c ren = (Renewal_Application__c) sObj;
            Renewal_Application__c renOld = null;
            if(trigger.Old != null){
                renOld = (Renewal_Application__c)trigger.OldMap.get(ren.Id);
            }
            if(ren.Total_Fees__c > 0 && ren.Total_Balance__c == 0 && (renOld == null || renOld.Total_Balance__c > 0)){
                if(ren.Renewal_Status__c != ''){
                    ren.Renewal_Status__c = 'Submitted';
                }            
            }
        } 
        //   LicenseRenewalAllFlowTrigger.UpdateRenewalEligibility(Trigger.new); 
    }
    Public void afterMethod(){
        Map<Id,Renewal_Application__c> RenewalSubmissionMap = new Map<Id,Renewal_Application__c>();
        Map<Id,Renewal_Application__c> ReinstatementSubmissionMap = new Map<Id,Renewal_Application__c>();
        Map<Id,Renewal_Application__c> permitRenewalSubmissionMap = new Map<Id,Renewal_Application__c>();
        Map<Id,Renewal_Application__c> permitReinstatementSubmissionMap = new Map<Id,Renewal_Application__c>();
		List<Renewal_Application__c> renewalsToUpdateList = new List<Renewal_Application__c>();
        Set<ID> renewalIds = new Set<ID>();
        System.debug('()()()()before guest check ');
        if (UserInfo.getUserType() != Label.Str_Guest) {
            System.debug('()()()()in if not guest check ');
            //if(null != true){
            //ApplicationSaveClass.recursionCheckLicenseRenewal
            Set<Id> setSubmittedIds = new Set<Id>();
            for(Renewal_Application__c renewal : (list<Renewal_Application__c>)trigger.New){
                if(trigger.isInsert){
                    System.debug('()()()()in if insert '+renewal);
                    if(renewal.Renewal_Status__c == Label.ST_Generate_Fee|| (renewal.Renewal_Status__c == Label.ST_Submitted && renewal.No_Fee_Required__c )){
                        setSubmittedIds.add(renewal.Id);
                        //ApplicationSaveClass.recursionCheckLicenseRenewal = true;
                    }
                    /*System.debug('renewal.license__r '+renewal.license__r);
                    System.debug('renewal.license__r.CE_Eligible__c '+renewal.license__r.CE_Eligible__c);
                    if(renewal.license__r.CE_Eligible__c){
                        renewal.CE_Hours__c = renewal.license__r.CE_Hours__c;
                        renewalsToUpdateList.add(renewal);
                    }                     
                    System.debug('renewalsToUpdateList - initial '+renewalsToUpdateList);
					*/
                }
                if(trigger.isUpdate){
                    System.debug('()()()()in if update ');
                    Map<Id,Renewal_Application__c> triggerOldMap = (Map<Id,Renewal_Application__c>)trigger.OldMap;
                    Renewal_Application__c licRenOld = (Renewal_Application__c) trigger.OldMap.get(renewal.Id);
                    if((triggeroldMap.get(renewal.Id)).Renewal_Status__c != renewal.Renewal_Status__c && 
                       ((renewal.Renewal_Status__c == Label.ST_Generate_Fee && renewal.Total_Balance__c <= 0)||(renewal.Renewal_Status__c == Label.ST_Submitted && renewal.No_Fee_Required__c ))){
                           setSubmittedIds.add(renewal.Id);
                           //ApplicationSaveClass.recursionCheckLicenseRenewal = true;
                       }
                    if(renewal.Renewal_Status__c == Label.ST_Submitted && (triggeroldMap.get(renewal.Id)).Renewal_Status__c != renewal.Renewal_Status__c){
                        renewalIds.add(renewal.Id);
                    	System.debug('renewalIds '+renewalIds);                        
                    }
                    
                    
                }   
            }
            if(setSubmittedIds.size() > 0){
                //ApplicationSaveClass.saveSubmittedApplications(setSubmittedIds, Label.API_License_Renewal);
            }
            //}
        }
        
        // LicenseRenewalTriggerHelper.evaluateFee((List<Renewal_Application__c>)Trigger.new, (Map<Id,Renewal_Application__c>)Trigger.oldMap);
        
        //This Method is called when already an AccountContact Record exists on an Account and Renewal records get Created. This Record will be shared with the community Plus User
        RenewalUserSharing controller = new RenewalUserSharing();
        controller.RenewalSharing_RecordInsert(Trigger.New);
        // End of RenewalUserSharing
        
        //Share the Renewal records when the Delegated Admin is the applicant
        RenewalCreatedByDelegate DelegateCOntroller = new RenewalCreatedByDelegate();
        DelegateCOntroller.shareRenewalRecords(Trigger.New);  
        
        System.debug('()()()() beofre for loop');
        for(Renewal_Application__c renewal:(list<Renewal_Application__c>)Trigger.New){
            System.debug('renewal.Renewal_Reinstatement_Type__c '+renewal.Renewal_Reinstatement_Type__c);
            if(renewal.Renewal_Reinstatement_Type__c== Label.RNT_Renewal && renewal.License__c != null && renewal.Renewal_Status__c == Label.ST_Incomplete){
                System.debug('in if for credential renewal');
                RenewalSubmissionMap.put(renewal.Id,renewal);
            }
            else if(renewal.Renewal_Reinstatement_Type__c== Label.RNT_Reinstatement && renewal.License__c != null && renewal.Renewal_Status__c == Label.ST_Incomplete){
                ReinstatementSubmissionMap.put(renewal.Id,renewal);
            }
            else if(renewal.Renewal_Reinstatement_Type__c== 'Renewal PTO' && renewal.Permit__c != null && renewal.Renewal_Status__c == Label.ST_Incomplete){
                System.debug('in if for permit renewal');
                permitrenewalSubmissionMap.put(renewal.Id,renewal);
            }
            else if(renewal.Renewal_Reinstatement_Type__c== Label.RNT_ReinstatementPTO && renewal.Permit__c != null && renewal.Renewal_Status__c == Label.ST_Incomplete){
                permitreinstatementSubmissionMap.put(renewal.Id,renewal);
            }
        } 
        System.debug('()()()() beofre isempty');
        if(!RenewalSubmissionMap.isEmpty()){
            System.debug('()()()() in isempty');
            RenewalSubmissionTriggerHandler.updateSubmissionRecords(RenewalSubmissionMap);
        } 
        
        else if(!ReinstatementSubmissionMap.isEmpty()){
            RenewalSubmissionTriggerHandler.updateSubmissionRecords(ReinstatementSubmissionMap);
            //BIZC_ReinsSubmissionUpdateTriggerHandler.updateSubmissionRecords(ReinstatementSubmissionMap);
        }
        else if(!permitrenewalSubmissionMap.isEmpty()){
            System.debug('in permitrenewalSubmissionMap');
            PermitRenewalSubmissionTriggerHandler.updateSubmissionRecords(permitrenewalSubmissionMap);
        }
        else if(!permitreinstatementSubmissionMap.isEmpty()){
            //  BIZC_ReinsSubmissionUpdateTriggerHandler.updateSubmissionRecords(permitreinstatementSubmissionMap);
        }
        if(Trigger.isinsert){
            String actionType = (Trigger.isUpdate) ? Label.Str_Update : ((Trigger.isInsert) ? Label.Str_Insert : Label.Str_Delete);
                BGBK.TriggerManager.DREGeneric(actionType, Trigger.New, Trigger.Old);
        }
        System.debug('renewalsToUpdateList '+renewalsToUpdateList);
        System.debug('renewalIds '+renewalIds);
        if(renewalIds.size() > 0){
            System.debug('renewalIds.size() > 0 ');
           List<Renewal_Application__c> renewalList = [SELECT ID, CE_Hours__c, license__r.CE_Hours__c, license__r.CE_Eligible__c
                                                      FROM Renewal_Application__c
                                                      WHERE ID IN :renewalIds
                                                      AND license__r.CE_Eligible__c = TRUE];
            System.debug('renewalList '+renewalList);
            for(Renewal_Application__c renewalRecord: renewalList){
                System.debug('renewalRecord '+renewalRecord);
                //if(renewalRecord.license__r.CE_Eligible__c){
                    renewalRecord.CE_Hours__c = renewalRecord.license__r.CE_Hours__c;
                    renewalsToUpdateList.add(renewalRecord);
                //}
            	
            
        }
        System.debug('renewalsToUpdateList --here '+renewalsToUpdateList);
        if(renewalsToUpdateList.size() > 0){
            update renewalsToUpdateList;
        }
        }
        
        
        //LicenseRenewalAllFlowTrigger.CreateComplaint(Trigger.new,(Map<Id,Renewal_Application__c>)Trigger.oldMap);
        
        //LicenseRenStatusUpdHandler.checkTotalBalance((Map<Id,Renewal_Application__c>)trigger.NewMap, (Map<Id,Renewal_Application__c>)trigger.OldMap);
    }
    
    public void beforemethod1(){
        List<Renewal_Application__c> triggerNew = Trigger.New;
        List<MUSW__Fee__c> feeList = new List<MUSW__Fee__c>();
        SET<ID> permitids = new SET<ID>();
        for(Renewal_Application__c renewal : (list<Renewal_Application__c>)trigger.New){
            if(renewal.Permit__c != null && renewal.Renewal_Status__c == 'Generate Fee'){
                System.debug('entered here');
                permitids.add(renewal.Permit__c);
            }
        }
        Map<Id,Musw__Permit2__c> permits = new  Map<Id,Musw__Permit2__c> ([Select id,Permit_Type__c,MUSW__Expiration_Date__c,Is_Late_Renewal_Eligible__c
                                                                           from Musw__Permit2__c where id=:permitIds]);
        for(Renewal_Application__c renewal : (list<Renewal_Application__c>)trigger.New){
            if(renewal.Permit__c != null && permits.containskey(renewal.Permit__c)){
                Musw__Permit2__c perm= permits.get(renewal.Permit__c);
                Integer expirationterm= system.today().year()-((date)perm.MUSW__Expiration_Date__c).Year();
                if(perm.Permit_Type__c == 'Manufactured Homes Community Permit'&& perm.Is_Late_Renewal_Eligible__c== True && expirationterm>2){
                    MUSW__Fee__c fee = new MUSW__Fee__c();
                    fee.MUSW__Type__c = 'MNF Community Late Renewal over 2 yrs';
                    fee.MUSW__Amount__c = (expirationterm/2)*80;
                    Fee.Renewal_Application__c = renewal.id;
                    feeList.add(fee);
                }
            }
        }
        if(feeList.size()>0){
            insert feeList;
        }
    }

    /*********************************************************************************
    Method Name    : DRESequence
    Description    : This method is to call Basic gov Sequence number and DRE .
    Return Type    : void
    Parameter      : Nil
    *********************************************************************************/
    Private Void DRESequence(){
        // Call Automation rules
        BGCM.TriggerManager.execute('DRE2_Renewal_Application_c', new DRETriggerHandler());
        // Call Sequence No
        Boolean isSeqNumberChangeReq = false;
                for (sObject sobj : Trigger.New) {
                    Renewal_Application__c ren = (Renewal_Application__c) sobj;
                    Renewal_Application__c oldRen = (Renewal_Application__c)Trigger.OldMap.get(ren.Id);
                    //Status was changed AND old Status is Not Active & Not Conditionally Approved
                    if (Trigger.Old != null && oldRen.Renewal_Status__c != ren.Renewal_Status__c &&  oldRen.Renewal_Status__c != 'Complete') {
                        // Update Sequence number
                        MUSW.SequenceNumber.updateNumbers(Trigger.new, trigger.old);
                        system.debug('Entered Sequence no');
                    }
                }    
    }
    
    public void updateAccountInfo(List<Renewal_Application__c> newList){
        Map<id, MUSW__License2__c> licenseMap = new Map<id, MUSW__License2__c>();
        Map<id, MUSW__Permit2__c> permitMap = new Map<id, MUSW__Permit2__c>();
        for(Renewal_Application__c re : newList){
            if(re.License__c != null){
                licenseMap.put(re.License__c, new MUSW__License2__c());
            }
            
            if(re.Permit__c != null){
                permitMap.put(re.Permit__c, new MUSW__Permit2__c());
            }
            
        }
        if(licenseMap.size() > 0){
            licenseMap = new Map<id, MUSW__License2__c>([Select id, MUSW__Primary_Licensee__c from MUSW__License2__c where id IN:licenseMap.keyset()]);
            for(Renewal_Application__c re : newList){
                re.Licensee__c = licenseMap.get(re.License__c).MUSW__Primary_Licensee__c; 
            }
        }  
        
        if(permitMap.size() > 0){
            permitMap = new Map<id, MUSW__Permit2__c>([Select id, MUSW__Account__c from MUSW__Permit2__c where id IN:permitMap.keyset()]);
            for(Renewal_Application__c re : newList){
                re.Licensee__c = permitMap.get(re.Permit__c).MUSW__Account__c; 
            }
        }  
    }
    
}