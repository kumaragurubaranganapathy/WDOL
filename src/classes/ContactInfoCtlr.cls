/* User Story: 148: Create ContactUS Page
/**************************************************************************************************************
** Name                : ContactInfoCtlr
** Description         : This is the controller for ContactUs
** Version             : 1.0
** Built By            : Aishwaria Rangineni
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                         Date                    Version                      Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** 
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/

public class ContactInfoCtlr 
{
    public List<ContactUs__mdt> contactInfoItems {get; set;}
    public List<ContactUs__mdt> manufacturedHomes {get; set;}
    public List<ContactUs__mdt> trades {get; set;}
    public List<ContactUs__mdt> planreviewPowts {get; set;}
    public boolean isGuestUser {get;set;} 
    
    /***************************************************************************************************
	* @Description : This is the constructor for ContactInfoCtlr
	* @Param       : null
	* @Return      : void
	****************************************************************************************************/   
    public ContactInfoCtlr() 
    {
        manufacturedHomes = new List<ContactUs__mdt>();
        trades = new List<ContactUs__mdt>();
        planreviewPowts = new List<ContactUs__mdt>();
        contactInfoItems  = [SELECT Id, Credential_Permit_Type__c, Website__c, Fax__c, Contact_Email__c FROM ContactUs__mdt where Credential_Permit_Type__c != null ORDER BY Credential_Permit_Type__c limit 100];
        system.debug('contactInfoItems>>>>'+contactInfoItems);
        if(contactInfoItems.size() > 0){
            for(ContactUs__mdt contactUs : contactInfoItems){
                switch on contactUs.Credential_Permit_Type__c{
                    when 'Plan Review', 'POWTS'{
                        planreviewPowts.add(contactUs);
                    } 
                    when 'Manufactured Homes'{
                        manufacturedHomes.add(contactUs);
                    }
                    when 'Trades'{
                        trades.add(contactUs);
                    }
                    when else{
                        //  Do nothing
                        }
                }
            }
        }
        system.debug('planreviewPowts>>>>'+planreviewPowts);
        system.debug('manufacturedHomes>>>>'+manufacturedHomes);
        system.debug('trades>>>>>'+trades);
        isGuestUser = Utilities.isGuestUserLoggedIn(); 
    }
    
}