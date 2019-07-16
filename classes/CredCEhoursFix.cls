/**
* Name: CredCEhoursFix
* Type: Class
* Description: Report Class to identify Credential CE hours
* Date:        Developer/Company                   Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 02/05/2018   Srikanth Kottam/Deloitte          Initial Creation
**/
global class CredCEhoursFix implements Database.Batchable<sObject>, Database.stateful {
    
    global Map<Id, Decimal> classTotalHrs= new Map<Id, Decimal>();
    global Map<Id, Decimal> credCeHrsMap= new Map<Id, Decimal>();
    global final String query;
    global String csvColumnHeader;
    global List<String> csvRowValues = new List<String>();
    global Map<Id, String> csvValues = new Map<Id, String>();
    
    global CredCEhoursFix(String q){        
        query=q;        
       // System.debug('query>>>'+ query);
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<MUSW__License2__c> scope){
        List<Classes__c> classList = new List<Classes__c>();
        decimal addHours = 0.0;
       // System.debug('scope>>>'+scope);
        if(scope.size()>0){
            classList = [Select id, name, End_Date_Time__c, Hours__c, CE_Status__c, CreatedBy.name, Credential__c from Classes__c 
                         where Credential__c in: scope 
                         Order By End_Date_Time__c Desc];
            for(MUSW__License2__c cred : scope){
                credCeHrsMap.put(cred.Id, cred.CE_Hours__c);
                if(cred.MUSW__Expiration_Date__c != null){
                    Date credentialExpirationDate = cred.MUSW__Expiration_Date__c;
                    integer newYear = credentialExpirationDate.year() - (Integer)cred.Renewal_window__c;
                    Date previousReviewCycleDate = date.newinstance(newYear, 
                                                                    credentialExpirationDate.month(), 
                                                                    credentialExpirationDate.day());
                    for(Classes__c classRec : classList){
                        if(cred.Id == classRec.Credential__c){
                            if(classRec.End_Date_Time__c > previousReviewCycleDate && classRec.End_Date_Time__c <=  cred.Renewal_Cycle_End_Date__c){
                                addHours = addHours + classRec.Hours__c;
                            }
                        }
                    }
                    classTotalHrs.put(cred.Id,addHours);
                    addHours = 0.0;
                } 
            }
        }
        
        // Create CSV file
        decimal actualHrs;
        decimal credHrs;
        decimal ceHrsdiff;
        if(credCeHrsMap.size() > 0){
            for(id credId : credCeHrsMap.keyset()){
                actualHrs = classTotalHrs.get(credId);
                credHrs = credCeHrsMap.get(credId);
                if(actualHrs == null){
                    actualHrs = 0.0;
                }
                if(credHrs == null){
                    credHrs = 0.0;
                }
                ceHrsdiff = credHrs - actualHrs;
           
                String rowStr = credId + ',' + credHrs + ',' + actualHrs + ',' + ceHrsdiff;
                csvValues.put(credId, rowStr);
               
            }
        }
      //  system.debug('csvRowValues>>>'+csvRowValues);
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        
      if(csvValues.size() > 0){
            for(id credId : csvValues.keyset()){
                string str = csvValues.get(credId);
                csvRowValues.add(str);
            }
        }
       // system.debug('csvValues>>>'+csvValues);
        if(csvRowValues.size()>0){
            String documentName = 'CEhourreport-'+ Datetime.now().format('MMM') + Datetime.now().year() + '.csv';
            csvColumnHeader = 'Id, Credential CE hours, Actual CE hours, CE Difference\n';
            String csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
            Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
            Blob csvBlob = blob.valueOf(csvFile);
            csvAttachment.setFileName(documentName);
            csvAttachment.setBody(csvBlob);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{'skottam@deloitte.com'};
           // String[] ccAddresses = new String[]{'anamathur@deloitte.com'};
            String subject = 'CE Hours Report';
            email.setSubject(subject);
            email.setToAddresses(toAddresses);
          //  email.setccAddresses(ccAddresses);
            email.setPlainTextBody('CE Hours details');
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
            //system.debug('email>>>'+email);
            Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});  
		}        
    }
    
}