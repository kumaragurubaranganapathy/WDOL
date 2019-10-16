public class FeeExtractController {
    
     
        public static void getAllFeeRecords()
        {
            
            try
            {
               
                    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
                    List<String> ApplicationType = new List<String>{'Appraisal Management Companies','Appraisers - Real Estate','Architects','Camping Resorts', 'Cemeteries','Engineers','Funerals','Geologist','Landscape Architects','Land Surveyors','Notary Public','On-site Wastewater','Timeshares'};
                    
                    Map<String,List<String>> mapAppLicenseType = new Map<String,List<String>>{'Appraisal Management Companies' => new list<String> {'Appraisal Management Company'},'Appraisers - Real Estate' => new list<String> {'Appraiser Trainee','Temporary Certified Residential','Temporary State Licensed','Certified General Appraiser','State Licensed Appraiser','Temporary Certified General','Appraiser Course'}, 'Architects' => new list<String> {'Architect'}, 'Camping Resorts' => new list<String> {'Camping Resort Salesperson','Camping Resort Company'}, 'Cemeteries' => new list<String>{'Crematory','Cremated Remains Disposition Permit','Cemetery'}, 'Engineers' => new list<String>{'Engineer in Training','Professional Engineer','Engineering/Land Surveying Company'}, 'Funerals' => new list<String>{'Funeral Director','Embalmer','Embalmer Intern','Funeral Director Intern','Funeral Establishment','Prearrangement Funeral Services','Certificate of Removal Registration','Academic Intern'}, 'Geologist' => new list<String>{'Geologist in Training','Geologist'},'Landscape Architects' =>new list<String>{'Landscape Architect'}, 'Land Surveyors' =>new list<String> {'Land Surveyor in Training','Professional Land Surveyor','Engineering/Land Surveying Company'},'Notary Public' =>new list<String> {'Notary Public'},'On-site Wastewater' => new list<String>{'On-site Wastewater Designer','On-site Wastewater Inspector'},'Timeshares' => new list<String>{'Timeshare Salesperson','Timeshare Company'}};
        
                    for (Integer i= 0 ;i < ApplicationType.size();i++)
                    {
                        List<String> licenseType = mapAppLicenseType.get(ApplicationType[i]);
                        //System.debug('licenseType::'+licenseType);
                        //System.debug('licenseType.size()::'+licenseType.size());
                        for(integer j = 0 ; j < licenseType.size(); j++){
                            MUSW__License2__c a = new MUSW__License2__c();
                            a.Application_Type__c = ApplicationType[i];       
                            a.Credential_Type__c = licenseType[j];
                            a.MUSW__Status__c = 'Generate Fee';
                            a.Application_Method__c = 'General Application';
                            a.MUSW__Applicant__c = '003r000000H0GHH';
                           // a.OwnerId = '005r00000037AX3';
                            a.Name = 'System Number';
                            //System.debug('a::'+a);
                            licenseList.add(a);
                            //insert a;
                        }
                    }
                    
                    if(!licenseList.isEmpty()){
                        batchinsertApplication biA = new batchinsertApplication(licenseList);
                        Database.executeBatch(biA,2);
                    }       
                   
                
            }catch(Exception e)
            {
                //System.debug('exception '+e.getMessage());
                //System.debug('exception '+e.getStackTraceString());
            }
            
            
        }
        
        public static void updateLicenses(Boolean deleteLicenses){
          FeeExtractUpdateLicenseBatch batch = new FeeExtractUpdateLicenseBatch(deleteLicenses);
          Id batchJobId = Database.executeBatch(batch, 10);
            
        }
        
        public static void getAllLicenseRenewalFeeRecords(){
            
            List<MUSW__License2__c> listLicense = new List<MUSW__License2__c>();
            List<Renewal_Application__c> renewList = new List<Renewal_Application__c>();
            
            listLicense = [Select Id,Application_Type__c,Credential_Type__c,MUSW__Status__c, MUSW__Applicant__c from MUSW__License2__c where MUSW__Applicant__c = '003r000000H0GHH' Limit 36];     
                  
                        for(integer j = 0 ; j < listLicense.size(); j++){
                            Renewal_Application__c ren = new Renewal_Application__c();
                            ren.Application_Type__c = listLicense[j].Application_Type__c;       
                            ren.Credential_Type__c = listLicense[j].Credential_Type__c;
                            ren.Renewal_Status__c = 'Generate Fee';
                            ren.Renewal_Reinstatement_Type__c = 'Renewal';
                            ren.License__c = listLicense[j].id;
                            ren.Applicant__c = '003r000000H0GHH';
                            renewList.add(ren);
                        }
              if(!renewList.isEmpty()){
                //System.debug('size::'+ renewList.size());
                        batchinsertRenewal biA = new batchinsertRenewal(renewList);
                        Database.executeBatch(biA);
              }      
        }
        
        public static void generatefile(Boolean feeDelete, String queryType){
             Set<Id> licenseIDset = new Set<ID>();
            String query = '';
            
            if(queryType == 'License')
            query = 'SELECT id,Name,Application_Type__c,MUSW__License2__r.Name,Profession_Code__c,portal_name__c,Revenue_Code__c,Fee_Name__c,MUSW__License2__c,Application_Method__c,Renewal_Application__c,Renewal_Application__r.Name,MUSW__Type__c,MUSW__Amount__c FROM MUSW__Fee__c  Where MUSW__License2__r.MUSW__Applicant__c = \'003r000000H0GHH\'';
            else if(queryType == 'Renewal')
            query = 'SELECT id,Name,Application_Type__c,MUSW__License2__r.Name,Profession_Code__c,portal_name__c,Revenue_Code__c,Fee_Name__c,MUSW__License2__c,Application_Method__c,Renewal_Application__c,Renewal_Application__r.Name,MUSW__Type__c,MUSW__Amount__c FROM MUSW__Fee__c  Where Renewal_Application__r.Applicant__c = \'003r000000H0GHH\'';
            //System.debug('query in batch '+query);
            FeeExtractBatch batch = new FeeExtractBatch( feeDelete,  query);
            Id batchJobId = Database.executeBatch(batch, 15);
            
        }
        
        
}