/**
* User Story: 242 - Use standard paragraphs in generated documents
* Class Name: StandardTextSearch_CC
* Test Class Name: StandardTextSearch_CC_Test
* Description: This class serves as Controller class for StandardTextSearch VF page
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 09/04/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/
public without sharing class StandardTextSearch_CC
{
    public List<MUSW__Violation_Type__c> standardText { get; set; }
    public String name { get; set; }
    public String code { get; set; }
    public String codeNumber { get; set; }
    public String sectionNumber { get; set; }
    public String shortDescription { get; set; }
    public string errorText{get; set;}
    public boolean norec{get; set;}
	public Id recordTypeId;
    
    public StandardTextSearch_CC()
    {
        standardText = new List<MUSW__Violation_Type__c>();
        recordTypeId = Schema.SObjectType.MUSW__Violation_Type__c.getRecordTypeInfosByName().get('Paragraph').getRecordTypeId();
    }
    
    public string getQuery(string name, string code, string codeNumber, string sectionNumber, string shortDescription){
        string query = 'select Id, Name, MUSW__Code__c, MUSW__Code_Number__c, MUSW__Section__c, MUSW__Description__c'
                     	+ ' from MUSW__Violation_Type__c' 
            			+ ' where RecordTypeId = \'' +recordTypeId + '\'';
        query = (String.isNotBlank(name)) ? query +=' AND name LIKE \'' +name + '%\'' : query; 
        query = (String.isNotBlank(code)) ? query +=' AND MUSW__Code__c LIKE \'' +code + '%\'' : query;
        query = (String.isNotBlank(codeNumber)) ? query +=' AND MUSW__Code_Number__c LIKE \'' +codeNumber + '%\'' : query;
        query = (String.isNotBlank(sectionNumber)) ? query +=' AND MUSW__Section__c LIKE \'' +sectionNumber + '%\'' : query;
        query = (String.isNotBlank(shortDescription)) ? query +=' AND MUSW__Short_Description__c LIKE \'' +shortDescription + '%\'' : query;
        return query;
    }

    public PageReference searchStandardText()
    {
        
        string query;
        if(name != '' || code != '' || codeNumber != '' || sectionNumber != '' || shortDescription != ''){
            query = getQuery(name, code, codeNumber, sectionNumber, shortDescription) ;
            system.debug('query>>>'+query);
        	standardText = Database.query(query);
            system.debug('standardText>>>>'+standardText);
            if(standardText.size() == 0){
                errorText = 'Could not find any data';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Could not find any data'));
                norec = true;
            }
        	system.debug('standardText>>>>'+standardText);
            norec = false;
        } else{
            errorText = 'Please enter the data and search';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter the data and search'));
            norec = true;
        }
        return null;
    }
}