/**
* Name: ApplyForSObjectInstructions_CC
* Type: Class
* Description: Controller Class for ApplyForSObjectInstructions
* Date:        Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 06/13/2018   Sharad Maheshwari/Deloitte           Initial Creation
**/

public class ApplyForSObjectInstructions_CC {

    public Newsfeed__c instructions {get; set;}
    public List<Question__c> questionList {get; set;}
    public String questionsJson {get; set;}
    public String documentId {get; set;}
    
    // Page parameters
    public String credentialType {get;set;}
    public String appType {get;set;}
    public String credential {get;set;}
    public String permitType {get;set;}
    public String programArea {get;set;}
    public String applicationMethod {get;set;}
    public String applicationType {get;set;}
    public String renewalOrReinstatement {get;set;}
    
    public String parentId = '';
    public String existingRecId = '';
    public String certificationId = '';
    public String accountId = '';

    public ApplyForSObjectInstructions_CC() {
        
        instructions = new Newsfeed__c();
        getURLParameters();
        getInstructions();
    }

    /**
     * Get url parameters in page
     */
    public void getURLParameters() {
        try{
            credentialType = ApexPages.currentPage().getParameters().get('credentialType');
            credential = ApexPages.currentPage().getParameters().get('credential');
            permitType = ApexPages.currentPage().getParameters().get('permitType');
            programArea = ApexPages.currentPage().getParameters().get('programArea');
            applicationType = ApexPages.currentPage().getParameters().get('applicationType');
            renewalOrReinstatement = ApexPages.currentPage().getParameters().get('renewalOrReinstatement'); //Credential Renewal/Reinstatement; Permit Renewal/Reinstatement
            applicationMethod = ApexPages.currentPage().getParameters().get('applicationMethod');
            parentId = ApexPages.currentPage().getParameters().get('parentId'); // the parent of the record         
            accountId = ApexPages.currentPage().getParameters().get('accountId');  // individual or business - only populated if applied for business 
            existingRecId = ApexPages.currentPage().getParameters().get('pid');
            
            System.debug('plist credentialType'+credentialType);
            System.debug('plist credential'+credential);
            System.debug('plist applicationType'+applicationType);
            System.debug('plist renewalOrReinstatement'+renewalOrReinstatement);
            System.debug('plist applicationMethod'+applicationMethod);
            System.debug('plist apptype'+apptype);
            
            //Eligibility questions for renewal/reinstatement depending on the credential/permit/plan review
            if(applicationType == label.Str_Trades_Credential || applicationType == 'Manufactured Homes' || applicationType == 'Delegated Municipality' || applicationType =='Notary Public' || applicationType == 'Landscape Architects' || applicationType == 'Appraisal Management Companies' || applicationType == 'Appraisers - Real Estate' || applicationType == 'Timeshares' || applicationType == 'Camping Resorts' || applicationType == 'Appraisal Management Companies' || applicationType == 'Geologists' || applicationType == 'Architects' || applicationType == 'Land Surveyors' || applicationType == 'Engineers' || applicationType == 'Funerals' || applicationType == 'On-site Wastewater' ){
                if(renewalOrReinstatement == 'Renewal'){
                apptype = 'Credential Renewal';
            }else if(renewalOrReinstatement == 'Reinstatement'){
                apptype = 'Credential Reinstatement';
            }
                System.debug('plist apptype'+apptype);
            String query = 'SELECT Id, Show_For__c,Qualifying_Response__c,Question_Body__c FROM Question__c where Credential_Type__c=\'';
            query+= String.escapeSingleQuotes(credentialType)+'\' and Credential__c=\'';
            query+= String.escapeSingleQuotes(credential)+'\'';
            query+= ' and show_for__c INCLUDES (\'';
            query+= String.escapeSingleQuotes(apptype)+ '\'';
            query+= ') and record_type_name__c= ' ;
            query+='\'Eligibility questions\' and Status__c = ' ;
            query+='\'Active\' ORDER BY Order_Number__c'; 
            System.debug('plist query'+query);
            questionList= database.query(query);
            System.debug('plist questionList'+questionList.size());    
            questionsJson = JSON.serialize(questionList);
                }else if(applicationType == 'Plan Review' || applicationType == 'Permit to Operate' || applicationType == 'Manufactured Homes Communities' ){
                if(renewalOrReinstatement == 'Renewal'){
                apptype = 'Permit Renewal';
            }else if(renewalOrReinstatement == 'Reinstatement'){
                apptype = 'Permit Reinstatement';
            }
            String query = 'SELECT Id, Show_For__c,Qualifying_Response__c,Question_Body__c FROM Question__c where Program_Area__c=\'';
            query+= String.escapeSingleQuotes(programArea)+'\' and Permit_Type__c=\'';
            query+= String.escapeSingleQuotes(permitType)+'\'';
            query+= ' and show_for__c INCLUDES (\'';
            query+= String.escapeSingleQuotes(apptype)+ '\'';
            query+= ') and record_type_name__c= ' ;
            query+='\'Eligibility questions\' and Status__c = ' ;
            query+='\'Active\' ORDER BY Order_Number__c'; 
            
            questionList= database.query(query);
            questionsJson = JSON.serialize(questionList);
                }
            }catch(Exception e) {
                ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectInstructions_CC', null, 'getURLParameters', 'ApplyForSObjectInstructions_CC', 'High');
                system.debug(e.getMessage());
            }
    }

    /**
     * Get application instructions
     */
    public void getInstructions() {
        
      
            try {

                if(applicationType == label.Str_Trades_Credential || applicationType == 'Manufactured Homes' || applicationType == 'Delegated Municipality' || applicationType =='Notary Public' || applicationType == 'Landscape Architects' || applicationType == 'Appraisal Management Companies' || applicationType == 'Appraisers - Real Estate' || applicationType == 'Timeshares' || applicationType == 'Camping Resorts' || applicationType == 'Appraisal Management Companies' || applicationType == 'Geologists' || applicationType == 'Architects' || applicationType == 'Land Surveyors' || applicationType == 'Engineers' || applicationType == 'Funerals' || applicationType == 'On-site Wastewater'){
                    instructions = [SELECT Id, Name, Type__c, Instructions__c, Document_API_Name__c, Answer__c
                            FROM Newsfeed__c 
                            WHERE Credential_Type__c = :credentialType
                            AND Credential__c = :credential
                            AND Show_For__c INCLUDES (:appType)
                            AND RecordType.Name = 'Page Instructions'
                            LIMIT 1];
                }
                else if(applicationType == 'Plan Review' || applicationType == 'Permit to Operate' || applicationType == 'Manufactured Homes Communities') {
                    instructions = [SELECT Id, Name, Type__c, Instructions__c, Document_API_Name__c, Answer__c
                            FROM Newsfeed__c 
                            WHERE Program_Area__c = :programArea
                            AND Permit_Type__c =:permitType
                            AND Show_For__c INCLUDES (:appType)
                            AND RecordType.Name = 'Page Instructions'
                            LIMIT 1];
                }
                
                if(instructions.Document_API_Name__c != ''){
                    for(Document doc : [Select id from Document where DeveloperName = :instructions.Document_API_Name__c limit 1]){
                        documentId = doc.Id;
                    }
                 }
            }
            catch(Exception e) {
                //ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectInstructions_CC', null, 'getInstructions', 'ApplyForSObjectInstructions_CC', 'High');
                system.debug(e.getMessage());
            }
        
    }

    /**
     * navigate to the Application Selection page
     */
    public PageReference proceedToApplication() {
        system.debug('Method called');
        try{
            // Page reference object
            PageReference next;

            // Page
            next = Page.Application;

            // Add parameters
            // Todo
            next.getParameters().put('renewalOrReinstatement', renewalOrReinstatement);
            if(applicationType == 'Trades Credential' || applicationType == 'Manufactured Homes' || applicationType == 'Delegated Municipality' || applicationType =='Notary Public' || applicationType == 'Landscape Architects' || applicationType == 'Appraisal Management Companies' || applicationType == 'Appraisers - Real Estate' || applicationType == 'Timeshares' || applicationType == 'Camping Resorts' || applicationType == 'Appraisal Management Companies' || applicationType == 'Geologists' || applicationType == 'Architects' || applicationType == 'Land Surveyors' || applicationType == 'Engineers' || applicationType == 'Funerals' || applicationType == 'On-site Wastewater'){
            next.getParameters().put('applicationType', renewalOrReinstatement);
            next.getParameters().put('appType', applicationType);
            next.getParameters().put('credentialType', credentialType);
            next.getParameters().put('credential', credential);
            next.getParameters().put('applicationMethod', applicationMethod);
            }else{
                next.getParameters().put('programArea', programArea);
                next.getParameters().put('permitType', permitType);
                if(applicationType == 'Plan Review') {
                    //there are now renewals/reinstatements for plan review-- sending a dummy value for future purpose
                    next.getParameters().put('applicationType', Label.RNT_RenewalPlanReview);                            
                }else if(applicationType == 'Permit to Operate'){
                    //there are now renewals/reinstatements for PTO-- sending a dummy value for future purpose
                    next.getParameters().put('applicationType', Label.RNT_RenewalPTO);    
                }else if(applicationType == 'Manufactured Homes Communities'){
                    //there are now REINSTATEMENTS--sending only renewal
                    next.getParameters().put('applicationType', Label.Str_ManufacturedHomesRenewal);
                }
            }
         
            
            if(accountId != null) {
                next.getParameters().put('accountId', accountId);
            }
            
              if(parentId != null) {
                next.getParameters().put('parentId', parentId);
            }
            if(existingRecId != null) {
                next.getParameters().put('pid', existingRecId);
            }

            // Return
            return next;
            }catch(Exception e) {
              //  ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'ApplyForSObjectInstructions_CC', null, 'getURLParameters', 'ApplyForSObjectInstructions_CC', 'High');
                return null;
            }
        
    }

    /**
    * Get Application Instruction content
    **/
    public Component.Apex.OutputText getAppInstructionContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        oppText.value = instructions.Instructions__c; 
        return oppText;
    }
}