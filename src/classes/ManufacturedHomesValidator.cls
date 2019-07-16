/**
* User Story: 
* Class Name: ManufacturedHomesValidator
* Test Class Name: 
* Description: This class represents ManufacturedHomesValidator to be performed on the MUSW__License2__c object
*
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/14/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/
public class ManufacturedHomesValidator extends BaseValidator {

    // constructor
    public ManufacturedHomesValidator() {
        System.debug('===> in constructor ManufacturedHomesValidator');
    }

    public override void validate(AllSections sec, SObject newRec, SObject oldRec ){ 
       MUSW__License2__c license = (MUSW__License2__c)newRec;
        
        if(license.credential__c == Label.CR_Manufactured_Homes_Dealer){
            if(license.Trade_Name__c == null || license.Trade_Name__c == ''){
                e.addError ('Trade_Name__c', 'You must specify the Trade Name');
            }
            if(license.Sales_Tax_Seller_Permit_Number__c == null || license.Sales_Tax_Seller_Permit_Number__c == ''){
                e.addError ('Sales_Tax_Seller_Permit_Number__c', 'You must specify Sales Tax Seller Permit Number');
            }
            if(license.Makes_of_Homes_to_be_Sold__c == null || license.Makes_of_Homes_to_be_Sold__c == ''){
                e.addError ('Makes_of_Homes_to_be_Sold__c', 'You must specify the Makes of Homes to be Sold');
            }
            if(license.Date_Facilities_will_be_ready__c == null){
                e.addError ('Date_Facilities_will_be_ready__c', 'You must specify the Date Facilities will be ready');
            }
            /*if(license.Additional_Address__c == null || license.Additional_Address__c == ''){
                e.addError ('Additional_Address__c', 'You must specify Branch Office Address');
            }
            if(license == null || license == ''){
                e.addError ('', 'You must specify ');
            }*/
        }else if(license.credential__c == Label.CR_Manufactured_Homes_Certificate_of_Title){
            if(license.Manufactured_Homes_Serial_Number__c == null || license.Manufactured_Homes_Serial_Number__c == ''){
                e.addError ('Manufactured_Homes_Serial_Number__c', 'You must specify Manufactured Home (Serial) Identification Number');
            }
            if(license.Model_Year__c == null){
                e.addError ('Model_Year__c', 'You must specify the Model Year');
            }
            /*if(license.Trade_Name__c == null || license.Trade_Name__c == ''){
                e.addError ('Trade_Name__c', 'You must specify the Trade Name');
            }*/
            if(license.Body_Length_with_hitch__c == null || license.Body_Length_with_hitch__c == 0.0){
                e.addError ('Body_Length_with_hitch__c', 'You must specify the Body Length (with hitch)');
            }
            if(license.Body_Width_with_hitch__c == null || license.Body_Width_with_hitch__c == 0.0){
                e.addError ('Body_Width_with_hitch__c', 'You must specify the Body Width (with hitch)');
            }
           /* if(license.Additional_Address__c == null || license.Additional_Address__c == ''){
                e.addError ('Additional_Address__c', 'You must specify the Address for Location of Manufactured Home');
            }
            if(license == null || license == ''){
                e.addError ('', 'You must specify the ');
            }*/
        }        
         
          
  }     
 }