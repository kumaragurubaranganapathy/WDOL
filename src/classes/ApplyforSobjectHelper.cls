public class ApplyforSobjectHelper {
    
    public ApplyforSobjectHelper(){
        
    }
    public static Component.c.PageSubSectionPrintComp printFieldSetComponentCreator(PageDefService.SubSectionObj subSectionObj,Account accountObj, Contact contactObj,Sobject lic,String Applicationtype,String existingRecId){    
        // List of fields as LicensePage1_SubSection component is not taking in FieldObj class as parameter
        List<Application_Field__c> fieldList = new List<Application_Field__c>();
        for (PageDefService.FieldObj fieldObj : subSectionObj.fieldObjMap.values()) {
            if(fieldObj.name != 'Birthdate' && fieldObj.name != 'Social Security Number Encrypted' && fieldObj.name != 'Ethnicity'){
                system.debug('Entered If loop with name:'+fieldObj.name);
                Application_Field__c fldObj = new Application_Field__c();
                fldObj.Name = fieldObj.name;
                fldObj.Label__c = fieldObj.label;
                fldObj.Type__c = fieldObj.sType;
                fldObj.Parent__c = fieldObj.parent;
                fldObj.Class_Name__c = fieldObj.className;
                fldObj.Required__c = fieldObj.required;
                fldObj.Validator__c = fieldObj.validator;
                fldObj.Object_Name__c = fieldObj.objectName;
                fieldList.add(fldObj);
            }
        }
        system.debug('fieldList>>>>>'+fieldList);
        // Initialize component
        Component.c.PageSubSectionPrintComp customComp = new Component.c.PageSubSectionPrintComp();
        customComp.subSectionName = subSectionObj.name;
        if (subSectionObj.description != null) {
            customComp.subSectionDesc = subSectionObj.description.stripHtmlTags();
        }
        Contact blankcontact = new Contact();
        system.debug('contactObj>>>>>>>>>'+contactObj);
        if (contactObj != blankcontact) {
            customComp.contactRecord = contactObj;
        } else {
            //This enables the the License to be able to be printed when the fee is paid from the backend.
            //It uses the fields from the contact at the time the fee is paid.
            if (applicationType == 'License' || applicationType == 'Renewal' || applicationType == 'Reinstatement') {
                String  QueryLicense = '';
                Musw__license2__c license = new Musw__license2__c();
                // License_Renewal__c licenserenewal = new License_Renewal__c();
                Musw__Permit2__c licenserenewal = new Musw__Permit2__c();
                if (applicationType == 'License') {
                    QueryLicense = 'Select id,MUSW__Applicant__c     from Musw__license2__c where id= \'' + existingRecId + '\'';
                    license = database.query(QueryLicense);
                } else {
                    //  QueryLicense = 'Select id,Applicant__c   from License_Renewal__c where id= \'' + existingRecId + '\'';
                    //todo licenserenewal = database.query(QueryLicense);
                }
                
                String QueryContact = 'SELECT Id ';
                for (Application_Field__c fld : fieldList) {
                    if (fld.Object_Name__c == 'Contact') {
                        QueryContact += ', ' + fld.name;
                    }
                }
                if (!QueryContact.contains(label.Str_FirstName)) {
                    QueryContact += ', FirstName';
                }
                if (!QueryContact.contains(label.Str_LastName)) {
                    QueryContact += ', LastName';
                }
                if (applicationType == label.API_License2) {
                    QueryContact += ' from Contact where id= \'' + license.MUSW__Applicant__c + '\'';
                } else {
                    // QueryContact += ' from Contact where id= \'' + licenserenewal.Applicant__c + '\'';
                }
                System.debug('QueryContact :: '+QueryContact);
                Contact contactfrombackend = database.query(QueryContact);
                customComp.contactRecord = contactfrombackend ;
            } 
        }
        customComp.fieldList = fieldList;
        customComp.currRecord = lic;
        
        customComp.accountRecord = accountObj;
        return customComp;
    }
    
    public static Component.c.PageComponentPrintComp printComponentCreator(List<Sobject> listofitems,PageDefService.SubSectionObj subSectionObj,PortalAttachmentSection attservice){    
        
        // Create subsection container
        Component.c.PageComponentPrintComp printComp = new Component.c.PageComponentPrintComp();
        printComp.compName = subSectionObj.name;
        if (subSectionObj.description != null) {
            printComp.compDesc = subSectionObj.description.stripHtmlTags();
        }
        // For educational qualifications component
        if (subSectionObj.componentName == 'EducationHistoryComp') {
            List<Education_History__c> edulist =(List<Education_History__c>) listofitems;
            if (edulist != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                for (Education_History__c eduObj : edulist) {
                    // Add field
                     Component.Apex.OutputText  opText = createprintcomponenttext('Degree',eduObj.Degree__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    if(eduObj.Educational_Institution__c!=null){
                     opText = createprintcomponenttext('Educational Institution',eduObj.Educational_Institution__r.Name,true)  ;             
                    subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Program',eduObj.Education_Program__r.Name,false)  ;             
                    subDetail2.childComponents.add(opText);
                    }
                    
                   
                    opText=createprintcomponentdate('Start Date',eduObj.Start_Date__c);
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('End Date',eduObj.End_date__c);
                    subDetail2.childComponents.add(opText);
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else  if (subSectionObj.componentName == 'LicenseVerificationComp') {
            List<License_Verification__c> lvflist =(List<License_Verification__c>) listofitems;
            if (lvflist != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                for (License_Verification__c eduObj : lvflist) {
                    // Add field
                    Component.Apex.OutputText opText = createprintcomponenttext('Credential',eduObj.Credential__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Credential Type',eduObj.Credential_Type__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Credential Number',eduObj.Credential_Number__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Credential Status',eduObj.Status__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Country',eduObj.Country__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',eduObj.State__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('Expiration Date',eduObj.Expiration_Date__c);
                    subDetail2.childComponents.add(opText);
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else if (subSectionObj.componentName == 'EmploymentHistoryComp') {
            List<Employment_History__c> listed =(List<Employment_History__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                for (Employment_History__c empObj : listed) {
                    Component.Apex.OutputText opText = createprintcomponenttext('Employer',empObj.Employer__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Job Title',empObj.Job_Title__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Supervisor Name',empObj.Supervisor_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Supervisor Number',empObj.Supervisor_Phone_Number__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Address',empObj.Street_Address__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('City',empObj.City__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',empObj.State__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Country',empObj.Country__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Zip Code',empObj.Zip_code__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('Start Date',empObj.Start_Date__c );
                    subDetail2.childComponents.add(opText);
                    if(empObj.End_date__c!=null){
                        opText=createprintcomponentdate('End Date',empObj.End_date__c);
                        subDetail2.childComponents.add(opText);
                    } else{
                        opText=createprintcomponenttext('Current','True',false);
                        subDetail2.childComponents.add(opText);
                    }
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else if (subSectionObj.componentName == 'TrainingHistoryComp') {
            List<Employment_History__c> listed =(List<Employment_History__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                for (Employment_History__c empObj : listed) {
                    Component.Apex.OutputText opText = createprintcomponenttext('Employer',empObj.Employer__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Job Title',empObj.Job_Title__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Supervisor Name',empObj.Supervisor_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Supervisor Number',empObj.Supervisor_Phone_Number__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Address',empObj.Street_Address__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('City',empObj.City__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',empObj.State__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Country',empObj.Country__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Zip Code',empObj.Zip_code__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('Start Date',empObj.Start_Date__c );
                    subDetail2.childComponents.add(opText);
                    if(empObj.End_date__c!=null){
                        opText=createprintcomponentdate('End Date',empObj.End_date__c);
                        subDetail2.childComponents.add(opText);
                    } else{
                        opText=createprintcomponenttext('Current','True',false);
                        subDetail2.childComponents.add(opText);
                    }
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else if(subSectionObj.componentName == 'AttachmentsComp'){
            if (attService != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                
                // Loop through the list
                for (PortalAttachmentSection.SubmissionRecord aObj : attService.attachmentList) {
                    
                    // Add field
                    Component.Apex.OutputText opText = new Component.Apex.OutputText();
                    opText.value = 'Title - ' + aObj.name + '<br/>';
                    opText.escape = false;
                    subDetail2.childComponents.add(opText);
                    
                    // Add field
                    opText = new Component.Apex.OutputText();
                    opText.value = 'Description - ' + (!String.isBlank(aObj.description) ? aObj.description.stripHtmlTags() : ' ') + '<br/>';
                    opText.escape = false;
                    subDetail2.childComponents.add(opText);
                    
                    opText = new Component.Apex.OutputText();
                    if (aObj.isAttested) {
                        opText.value = 'Attested - Attestation complete'  + '<br/>';
                        opText.escape = false;
                        subDetail2.childComponents.add(opText);
                    }
                    
                    opText = new Component.Apex.OutputText();
                    opText.value = '<br/>'  + '<br/>';
                    opText.escape = false;
                    subDetail2.childComponents.add(opText);
                    
                    for (Attachment aObj1 : aObj.attachmentList) {
                        
                        
                        // Add field
                        opText = new Component.Apex.OutputText();
                        opText.value = 'Attached file - ' + aObj1.Name + '<br/><br/>';
                        opText.escape = false;
                        subDetail2.childComponents.add(opText);
                        
                    }
                }
                
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
            
        }
        else if(subSectionObj.componentName == 'POWTSOwnerDesigner'){
            List<Affiliation__c> listed =(List<Affiliation__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                for (Affiliation__c affObj : listed) {
                    Component.Apex.OutputText opText = createprintcomponenttext('Type of Affiliation',affObj.Type__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Last Name',affObj.Contact_s_Last_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('First Name',affObj.Contact_s_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Company',affObj.Company__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Address',affObj.Contact_s_Street_Address__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('City',affObj.Contact_s_City__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',affObj.Contact_s_state__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Zip Code',affObj.Contact_s_Zip_code__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('Start Date',affObj.Start_Date__c );
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Email',affObj.Contact_s_Email__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Phone Number',affObj.Contact_s_Phone__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    if(affObj.End_date__c!=null){
                        opText=createprintcomponentdate('End Date',affObj.End_date__c);
                        subDetail2.childComponents.add(opText);
                    } else{
                        opText=createprintcomponenttext('Current','True',false);
                        subDetail2.childComponents.add(opText);
                    }
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else if(subSectionObj.componentName == 'CoownershipComponent'){
                       List<Affiliation__c> listed =(List<Affiliation__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                for (Affiliation__c affObj : listed) {

                    Component.Apex.OutputText opText = createprintcomponenttext('Last Name',affObj.Contact_s_Last_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Middle Name',affObj.Contact_s_Middle_Name__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('First Name',affObj.Contact_s_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Address',affObj.Contact_s_Street_Address__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('City',affObj.Contact_s_City__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',affObj.Contact_s_state__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Zip Code',affObj.Contact_s_Zip_code__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Email',affObj.Contact_s_Email__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Phone Number',affObj.Contact_s_Phone__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
            
        }
        else if(subSectionObj.componentName == 'DelegatedAgentComponent'){
            List<Affiliation__c> listed =(List<Affiliation__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                for (Affiliation__c affObj : listed) {
                    Component.Apex.OutputText opText = createprintcomponenttext('Credential Number',affObj.Contact_s_Credential_Number__c,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Last Name',affObj.Contact_s_Last_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('First Name',affObj.Contact_s_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Address',affObj.Contact_s_Street_Address__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('City',affObj.Contact_s_City__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('State',affObj.Contact_s_state__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Zip Code',affObj.Contact_s_Zip_code__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText=createprintcomponentdate('Start Date',affObj.Start_Date__c );
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Email',affObj.Contact_s_Email__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Phone Number',affObj.Contact_s_Phone__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    if(affObj.End_date__c!=null){
                        opText=createprintcomponentdate('End Date',affObj.End_date__c);
                        subDetail2.childComponents.add(opText);
                    } else{
                        opText=createprintcomponenttext('Current','True',false);
                        subDetail2.childComponents.add(opText);
                    }
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        else if(subSectionObj.componentName == 'ProjectInformationComponent'){
            List<MUSW__Project_Parcel__c> listed =(List<MUSW__Project_Parcel__c>) listofitems;
            if (listed != null) {
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                for (MUSW__Project_Parcel__c parcObj : listed) {
                    Component.Apex.OutputText opText = createprintcomponenttext('Project/Site Name',parcObj.MUSW__Project2__r.Name,true)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Location, Number and Street of Project',parcObj.MUSW__Parcel__r.MUSW__Street2__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Legal Description',parcObj.MUSW__Project2__r.MUSW__Description__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('County',parcObj.MUSW__Project2__r.County_Name__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Municipality',parcObj.MUSW__Project2__r.Municipality_Type__c,false)  ;             
                    subDetail2.childComponents.add(opText);
                    opText = createprintcomponenttext('Municipality Name',parcObj.MUSW__Project2__r.Municipality_Name__c,false)  ; 
                    subDetail2.childComponents.add(opText);
                }
                // Add to subsection container
                printComp.childComponents.add(subDetail2);
            }
        }
        return printComp;
    }
    
    public static Component.c.PageComponentPrintComp printAddressComponentCreator(List<Sobject> listofitems, PageDefService.SubSectionObj subSectionObj, String credentialOrPermit){    
        
        // Create subsection container
        Component.c.PageComponentPrintComp printComp = new Component.c.PageComponentPrintComp();
        printComp.compName = subSectionObj.name;
        if (subSectionObj.description != null) {
            printComp.compDesc = subSectionObj.description.stripHtmlTags();
        }
        
        // For address component
        if (subSectionObj.componentName == 'BusinessAddress') {
            
            if(credentialOrPermit == Label.Str_Credential){
                List<MUSW__License_Parcel__c> addressList =(List<MUSW__License_Parcel__c>) listofitems;
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                if (addressList != null){
                    for (MUSW__License_Parcel__c licParcelObj : addressList) {
                        // Add field
                        Component.Apex.OutputText opText = createprintcomponenttext('Address', '', true)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Street', licParcelObj.MUSW__Parcel__r.MUSW__Street__c, false)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('City', licParcelObj.MUSW__Parcel__r.MUSW__City__c, false)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('State', licParcelObj.MUSW__Parcel__r.MUSW__State__c, false);
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Postal Code', licParcelObj.MUSW__Parcel__r.MUSW__Post_Zip_Code__c, false);
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Country', licParcelObj.MUSW__Parcel__r.Country__c, false);
                        subDetail2.childComponents.add(opText);
                    }
                    // Add to subsection container
                    printComp.childComponents.add(subDetail2);
                }
            }else{
                List<MUSW__Permit_Parcel__c> addressList =(List<MUSW__Permit_Parcel__c>) listofitems;
                // Initialize a detail component
                Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
                // Loop through the list
                if (addressList != null){
                    for (MUSW__Permit_Parcel__c permitParcelObj : addressList) {
                        // Add field
                        Component.Apex.OutputText opText = createprintcomponenttext('Address', '', true)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Street', permitParcelObj.MUSW__Parcel__r.MUSW__Street__c, false)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('City', permitParcelObj.MUSW__Parcel__r.MUSW__City__c, false)  ;             
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('State', permitParcelObj.MUSW__Parcel__r.MUSW__State__c, false);
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Postal Code', permitParcelObj.MUSW__Parcel__r.MUSW__Post_Zip_Code__c, false);
                        subDetail2.childComponents.add(opText);
                        opText = createprintcomponenttext('Country', permitParcelObj.MUSW__Parcel__r.Country__c, false);
                        subDetail2.childComponents.add(opText);
                    }
                    // Add to subsection container
                    printComp.childComponents.add(subDetail2);
                }
                
            }
            
        }
        
        return printComp;
    }
    
    public static Component.c.PageComponentPrintComp printQuestionComponentCreator(QuestionAnswerObj queService,PageDefService.SubSectionObj subSectionObj,PortalAttachmentSection attservice){    
        
        // Create subsection container
        Component.c.PageComponentPrintComp printQuestionsComp = new Component.c.PageComponentPrintComp();
        printQuestionsComp.compName = subSectionObj.name;
        if (subSectionObj.description != null) {
            printQuestionsComp.compDesc = subSectionObj.description.stripHtmlTags();
        }
        
        if (queService != null) {
            // Initialize a detail component
            
            Component.Apex.Detail subDetail2 = new Component.Apex.Detail();
            Component.Apex.OutputText anewtext= new Component.Apex.OutputText ();
            anewtext.value='<br/><br/><b>'+ 'Question'+ '- '+ 'Answer' + '</b><br/>';
            anewtext.escape = false;
            subDetail2.childComponents.add(anewtext);
            // Loop through the list
            for (QuestionAnswerObj.QuestionObj qObj : queService.questionsList) {
                // Add field
                if (qObj.answerText != null) {
                    
                    Component.Apex.OutputText opText = new Component.Apex.OutputText();
                    opText = createprintcomponenttext('Question - ', qObj.questionBody, false)  ;             
                    subDetail2.childComponents.add(opText);
                    
                    // Add field
                    opText = new Component.Apex.OutputText();
                    opText = createprintcomponenttext('Answer - ', qObj.answerText, false)  ; 
                    subDetail2.childComponents.add(opText);
                    
                    // Add field
                    opText = new Component.Apex.OutputText();
                    if (qObj.answerComment != null) {
                        opText = createprintcomponenttext('Comment - ', qObj.answerComment, false)  ;             
                        subDetail2.childComponents.add(opText);
                    } else {
                        opText.value = '<br/><br/>';
                        opText.escape = false;
                        subDetail2.childComponents.add(opText);
                    }
                    
                    
                    //Caters to the question group answers
                    if (qObj.QuestionGroup != null && qObj.Map_Of_AnswerGroup_childQuestionsGroup.get(qObj.QuestionGroup + '-1') != null) {
                        Set <String> qallkeys = new Set<String>();
                        Set <String> qkeys = new Set<String>();
                        qallkeys = qObj.Map_Of_AnswerGroup_childQuestionsGroup.keySet();
                        for (String key : qallkeys) {
                            if (key.contains(qObj.QuestionGroup)) {
                                qkeys.add(key);
                            }
                        }
                        for (string key : qkeys) {
                            List<QuestionAnswerObj.QuestionsGroup> qgrouplist = qObj.Map_Of_AnswerGroup_childQuestionsGroup.get(key);
                            for (QuestionAnswerObj.QuestionsGroup qgroup : qgrouplist) {
                                if (qgroup.answerText != null) {
                                    opText = new Component.Apex.OutputText();
                                    opText = createprintcomponenttext('Question - ', qgroup.questionBody, false)  ;             
                                    subDetail2.childComponents.add(opText);
                                    
                                    // Add field
                                    opText = new Component.Apex.OutputText();
                                    opText = createprintcomponenttext('Answer - ', qgroup.answerText, false)  ; 
                                    subDetail2.childComponents.add(opText);
                                    
                                    
                                    // Add field
                                    opText = new Component.Apex.OutputText();
                                    if (qgroup.answerComment != null) {
                                        opText = createprintcomponenttext('Comment - ', qgroup.answerComment, false)  ;             
                                        subDetail2.childComponents.add(opText);
                                    } else {
                                        opText.value = '<br/><br/>';
                                        opText.escape = false;
                                        subDetail2.childComponents.add(opText);
                                    }
                                }
                            }
                        }
                    }
                    // Loop through the inner list
                    for (QuestionAnswerObj.ChildQuestionObj cqObj : qObj.childQueList) {
                        
                        if (cqObj.answerText != null) {
                            // Add field
                            opText = new Component.Apex.OutputText();
                            opText = createprintcomponenttext('Question - ', cqObj.questionBody, false)  ;  
                            subDetail2.childComponents.add(opText);
                            
                            // Add field
                            opText = new Component.Apex.OutputText();
                            if (cqObj.answerText != null) {
                                opText = createprintcomponenttext('Answer - ', cqObj.answerText, false)  ; 
                                subDetail2.childComponents.add(opText);
                            }
                            
                            // Add field
                            opText = new Component.Apex.OutputText();
                            if (cqObj.answerComment != null) {
                                opText = createprintcomponenttext('Comment - non', cqObj.answerComment, false)  ;             
                                subDetail2.childComponents.add(opText);
                            } else {
                                opText.value = '<br/><br/>';
                                opText.escape = false;
                                subDetail2.childComponents.add(opText);
                            }
                        }
                    }
                } else {
                    Component.Apex.OutputText opText = new Component.Apex.OutputText();
                    opText = createprintcomponenttext('Question - ', qObj.questionBody, false)  ;  
                    subDetail2.childComponents.add(opText);
                    
                    // Add field
                    opText = new Component.Apex.OutputText();
                    opText = createprintcomponenttext('Answer - ', '', false)  ;
                    subDetail2.childComponents.add(opText);
                    
                    for (QuestionAnswerObj.ChildQuestionObj cqObj : qObj.childQueList) {
                        
                        
                        // Add field
                        opText = new Component.Apex.OutputText();
                        opText = createprintcomponenttext('Question - ', cqObj.questionBody, false)  ;  
                        subDetail2.childComponents.add(opText);
                        
                        // Add field
                        opText = new Component.Apex.OutputText();
                        opText = createprintcomponenttext('Answer - ', '', false)  ;
                        subDetail2.childComponents.add(opText);
                    }
                    
                }
            }
            
            // Add to subsection container
            printQuestionsComp.childComponents.add(subDetail2);
        }
        
        
        // For educational qualifications component       
        return printQuestionsComp;
    }
    
    public static Component.c.PageSubSectionComp fieldSetComponentCreator(PageDefService.SubSectionObj subSectionObj,Account accountObj, Contact contactObj,Sobject lic,String Applicationtype,String existingRecId,String parentId){    
        // List of fields as LicensePage1_SubSection component is not taking in FieldObj class as parameter
        List<Application_Field__c> fieldList = new List<Application_Field__c>();
        Boolean checkforparent=false;
        String parentObj='';
        String objectname='';
        List<String> fields = new List<String>();
        for (PageDefService.FieldObj fieldObj : subSectionObj.fieldObjMap.values()) {
            Application_Field__c fldObj = new Application_Field__c();
            fldObj.Id = (Id)fieldObj.id;
            fldObj.Name = fieldObj.name;
            fldObj.Label__c = fieldObj.label;
            fldObj.Type__c = fieldObj.sType;
            fldObj.Class_Name__c = fieldObj.className;
            fldObj.Required__c = fieldObj.required;
            if (fldObj.Required__c) {
                fldObj.Class_Name__c += ' req';
            } else {
                fldObj.Class_Name__c += ' secondary-fields';
            }
            
            fldObj.Object_Name__c = fieldObj.objectName;
            
            if (fldObj.Object_Name__c=='Parent of Main Object')
            {
                checkforparent=true;
                parentObj=fldObj.Object_Name__c;
                fields.add(fldObj.Name);
            }
            if(Applicationtype==label.Str_ManufacturedHomesRenewaL)
            {
                objectname='Musw__permit2__C';
            }
            else if(Applicationtype==label.RNT_Renewal){
                objectname='Musw__License2__C';
            }
            fldObj.Read_Only__c = fieldObj.readOnly;
            fieldList.add(fldObj);
        }
        Set<String>allplanreviewsandpermits =Utilities.getallPlanreviewsandpermits();
        Set<String> allcredentials =Utilities.getallCredentials();
        Component.c.PageSubSectionComp customComp = new Component.c.PageSubSectionComp();
        Integer counter = 1;
        String fieldString = '';
        if(checkforparent==true&&parentId!=null&&parentId!='')
        {
            for (String fieldName :fields){
                if (counter == fields.size()) {
                    fieldString += fieldName ;
                    break;
                } else {
                    fieldString += fieldName + ', ';
                }
                
                if (fieldString.endsWith(', ') && (counter == fields.size())) {
                    fieldstring.trim();
                    fieldstring = fieldstring.reverse();
                    fieldstring = fieldstring.replacefirst(',', '');
                    fieldstring.trim();
                    fieldstring = fieldstring.reverse();
                }
                counter++;
            }
            customComp.parentRecord = Database.query('SELECT ' + fieldString + ' FROM ' + objectname +' where id=:parentId Limit 1');
        }
        customComp.subSectionName = subSectionObj.name;
        customComp.subSectionNameWithoutWhitespace = subSectionObj.name.toLowercase().replaceAll('\\s+', '-') ;
        if (subSectionObj.description != null) {
            customComp.subSectionDesc = subSectionObj.description.stripHtmlTags();
        }
        System.debug('sharad why');
        Contact blankcontact = new Contact();
        if (contactObj != blankcontact) {
            System.debug('sharad why>');
            customComp.contactRecord = contactObj;
        } else {
            System.debug('sharad why>');
            //This enables the the License to be able to be printed when the fee is paid from the backend.
            //It uses the fields from the contact at the time the fee is paid.
            String  QueryLicense = '';
            Musw__license2__c license = new Musw__license2__c();
            Renewal_Application__c licenserenewal = new Renewal_Application__c();
            Musw__Permit2__c permit = new Musw__Permit2__c();
            if (allcredentials.contains(applicationType)) {
                QueryLicense = 'Select id,MUSW__Applicant__c     from Musw__license2__c where id= \'' + existingRecId + '\'';
                license = database.query(QueryLicense);
            }
            else if(allplanreviewsandpermits.contains(applicationType)) {
                QueryLicense = 'Select id,MUSW__Applicant__c     from Musw__Permit2__c where id= \'' + existingRecId + '\'';
                permit = database.query(QueryLicense);
                
            }else {
                QueryLicense = 'Select id,Applicant__c   from Renewal_Application__c where id= \'' + existingRecId + '\'';
                licenserenewal = database.query(QueryLicense);
            }
            
            String QueryContact = 'SELECT Id ';
            for (Application_Field__c fld : fieldList) {
                if (fld.Object_Name__c == 'Contact') {
                    QueryContact += ', ' + fld.name;
                }
            }
            if (!QueryContact.contains(label.Str_FirstName)) {
                QueryContact += ', FirstName';
            }
            if (!QueryContact.contains(label.Str_LastName)) {
                QueryContact += ', LastName';
            }
            if (allcredentials.contains(applicationType)) {
                System.debug('here again');
                QueryContact += ' from Contact where id= \'' + license.MUSW__Applicant__c + '\'';
            }             
            else if (allplanreviewsandpermits.contains(applicationType)) {
                System.debug('here again');
                QueryContact += ' from Contact where id= \'' + permit.MUSW__Applicant__c + '\'';
            } else {
                QueryContact += ' from Contact where id= \'' + licenserenewal.Applicant__c + '\'';
            }
            
            System.debug('sharad why>');
            Contact contactfrombackend = database.query(QueryContact);
            customComp.contactRecord = contactfrombackend ;
        }
        customComp.fieldList = fieldList;
        customComp.currRecord = lic;
        
        customComp.accountRecord = accountObj;
        return customComp;
    }
    
    
    public static Contact findcontact(PageDefService service,String contactId){
        List<PageDefService.FieldObj> fieldList = service.PageObj.getAllFieldObjects();
        
        // Build query
        String queryString = 'SELECT Id';
        for (PageDefService.FieldObj fld : fieldList) {
            if (fld.objectName == label.API_Contact) {
                queryString += ', ' + fld.name;
            }
        }
        if (!queryString.contains('FirstName')) {
            queryString += ', FirstName';
        }
        if (!queryString.contains('LastName')) {
            queryString += ', LastName';
        }
        queryString += ' FROM Contact WHERE Id = :contactId';
        Contact contactObj = Database.query(queryString);
        return contactObj;
        
    }
    
    public static Account findaccount(PageDefService service,String accountId){
        // Get all Account object fields present on page
        List<PageDefService.FieldObj> fieldList = service.PageObj.getAllFieldObjects();
        
        // Build query
        String queryString = 'SELECT Id';
        for (PageDefService.FieldObj fld : fieldList) {
            if (fld.objectName == 'Account') {
                queryString += ', ' + fld.name;
            }
        }
        queryString += ' FROM Account WHERE Id = :accountId';
        
        // Query Account object
        Account accountObj = Database.query(queryString);
        return accountObj;
    }
    
    public static   Component.Apex.OutputText createprintcomponenttext(String Label,String Text,Boolean firstitem)
    {
        Component.Apex.OutputText anewtext= new Component.Apex.OutputText ();
        if(text!=null){
            if(firstitem){
                anewtext.value=  '<br/><br/><b>'+ Label+ '- '+ Text + '</b><br/>';
            }
            else{ 
                anewtext.value=  '<br/>'+ Label+ '- '+ Text + '<br/>';
            }
            anewtext.escape = false;
        }
        return anewtext;
    }
    
    public static   Component.Apex.OutputText createprintcomponentdate(String Label,Date datepassed)
    {
                Component.Apex.OutputText anewtext= new Component.Apex.OutputText ();
        if(datepassed!=null){
        String Text= datepassed.month() + '/' + datepassed.day() + '/' + datepassed.year();
        anewtext.value=  '<br/> '+ Label+ '- '+ Text + '<br/>';
        anewtext.escape = false;
        }else{
             anewtext.value=  '<br/> '+ Label+ '- ' + '<br/>';
        anewtext.escape = false;
        }
        return anewtext;

        
    }
    
    
    
}