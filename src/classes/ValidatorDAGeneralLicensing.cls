/*************************************************************************************************************
**  
**************************************************************************************************************
** Class Name    : ValidatorDAGeneralLicensing
** Description   : This class represents ValidatorDAGeneralLicensing to be performed on the 
**                 MUSW__License2__c object
** Version       : 1.0
** Built By      : Akosa Okwudiafor
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**************************************************************************************************************/
public class ValidatorDAGeneralLicensing extends BaseValidator {

    // constructor
    public ValidatorDAGeneralLicensing() {
        System.debug('===> in constructor ValidatorDAGeneralLicensing');
    }

    public override void validate(AllSections sec, SObject newRec, SObject oldRec ){ 
       MUSW__License2__c l = (MUSW__License2__c)newRec;
        System.debug( '===> ValidatorDAGeneralLicensing.allSections');
         Affiliation__c dacaffHistObject= new Affiliation__c();
        dacaffHistObject.RecordTypeId=Utilities.getRecordTypeForName(Label.API_Affiliation,'Delegated Agent Affiliation'); 
        List<Affiliation__c> affiliations = [SELECT Permit_Plan_Review__c,Credential__c,Type__c FROM Affiliation__c where credential__c=:newRec.Id  and recordtypeId=:dacaffHistObject.recordtypeId and Type__c=:Label.Str_Primary_Enforcement_Contact Limit 1];
        Boolean isAffiliation = (affiliations.isEmpty())? true : false;
        
        if(isAffiliation){
             e.addError ('DelegatedAgentComponent', 'You Must have atleast one affiliation with  type Primary Enforcement Contact');
        }   
          
  }     
 }