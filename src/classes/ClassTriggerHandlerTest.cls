@istest
public class ClassTriggerHandlerTest {

static testmethod void onbeforemethodWithApplications_Test()
    {
        MUSW__License2__c license=new MUSW__License2__c(
        	MUSW__Expiration_Date__c=Date.today(),
            CE_Hours__c=3.321,
            Name='Test License1',
            Credential__c='Dwelling Contractor',
            Credential_Type__c='Dwelling Contractor',
            Application_Type__c='Trades Credential'
        );
        
        insert license;
        
        Account acc=new Account(
        Name='Koko enterprises');
        insert acc;
        
              
        Renewal_Application__c app=new Renewal_Application__c(
        	License__c=License.Id,
            Licensee__c=acc.Id,
        	CE_Hours__c=4.453,
            Renewal_Status__c = Label.ST_Submitted
        );
        
        insert app;
        
        Classes__c a = new Classes__c(
        	CE_Status__c='New',
            Hours__c=3.454,
            End_Date_Time__c=Date.newInstance(2018,01,24),
            Credential__c=license.Id);
        insert a;
		
        try{
        Classes__c b = new Classes__c(
        	CE_Status__c='Applied',
            Hours__c=3.454,
            End_Date_Time__c=Date.newInstance(2018,01,24),
            Credential__c=license.Id);
        insert b;
        }catch(Exception e){
            System.debug(e);
            
        }
		Classes__c curr=[SELECT Id, CE_Status__C FROM Classes__c WHERE Id=:a.Id];
        
        System.assertEquals(curr.CE_Status__c, 'Applied');    
    }
    
    static testmethod void onbeforemethodWithoutApplications_Test()
    {      
        MUSW__License2__c license=new MUSW__License2__c(
        	MUSW__Expiration_Date__c=Date.today(),
            CE_Hours__c=3.321,
            Name='Test License1',
            Credential__c='Dwelling Contractor',
            Credential_Type__c='Dwelling Contractor',
            Application_Type__c='Trades Credential'
        );
        
        insert license;
        
        Classes__c a = new Classes__c(
        	CE_Status__c='New',
            Hours__c=3.454,
            End_Date_Time__c=Date.newInstance(2018,01,26),
            Credential__c=license.Id);
        insert a;
        try{
        Classes__c b = new Classes__c(
        	CE_Status__c='Applied',
            Hours__c=3.454,
            End_Date_Time__c=Date.newInstance(2018,01,24),
            Credential__c=license.Id);
        insert b;
        }catch(Exception e){
            System.debug(e);
            
        }
		Classes__c curr=[SELECT Id, CE_Status__C FROM Classes__c WHERE Id=:a.Id];
        
        System.assertEquals(curr.CE_Status__c, 'Applied');
    }

}