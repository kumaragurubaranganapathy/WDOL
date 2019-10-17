/**
* User Story: 
* Class Name: ManufacturedHomesCommunityValidator
* Test Class Name: 
* Description: This class represents ManufacturedHomesCommunityValidator to be performed on the MUSW__Permit2__c object
*
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/14/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public class ManufacturedHomesCommunityValidator extends BaseValidator {

    // constructor
    public ManufacturedHomesCommunityValidator() {
  //      System.debug('===> in constructor ManufacturedHomesCommunityValidator');
    }

    public override void validate(AllSections sec, SObject newRec, SObject oldRec ){ 
       MUSW__Permit2__c permit = (MUSW__Permit2__c)newRec;
        
        if(permit.Permit_Type__c == Label.PT_Manufactured_Homes_Community_Permit){
            if(permit.Community_Owner__c == null || permit.Community_Owner__c == ''){
                e.addError ('Community_Owner__c', 'You must specify the Name of Owner');
            }
            if(permit.Community_Name__c == null || permit.Community_Name__c == ''){
                e.addError ('Community_Name__c', 'You must specify Name of Community');
            }
            /*if(permit.Community_ID_Number__c == null || permit.Community_ID_Number__c == ''){
                e.addError ('Community_ID_Number__c', 'You must specify the Community ID Number');
            }
            if(permit.Community_Address__c == null || permit.Community_Address__c == ''){
                e.addError ('Community_Address__c', 'You must specify the Community Address');
            }*/
            if(permit.County__c == null || permit.County__c == ''){
                e.addError ('County__c', 'You must specify the County');
            }
            /*if(permit == null || permit == ''){
                e.addError ('', 'You must specify the ');
            }*/
        }        
         
          
  }     
 }