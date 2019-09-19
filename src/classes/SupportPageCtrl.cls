/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name                : SupportPageCtrl
** Description         :  
** Version             : 1.0
** Built By            : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
************************************************************************************/
public class SupportPageCtrl {
    
    public Boolean isGuestUser {get;set;}
    public String selectedSection {get; set;}
    public List<SelectOption> sectionSelectOptions {get; set;}    
    public List<Newsfeed__c> sectionFAQs {get; set;} 
    private List<Newsfeed__c> allFAQs;
    
    public SupportPageCtrl() {
        allFAQs = [SELECT id, Name, Section__c, Question__c, Answer__c
                   FROM Newsfeed__c 
                   WHERE RecordType.DeveloperName = :System.label.RT_FAQ
                   AND FAQ_Active__c = true
                  ];
        
        generateSectionSelectList();
        refreshFAQlists();        
        isGuestUser = Utilities.isGuestUserLoggedIn();   
    }
    
    public void refreshFAQlists() {
        refreshSectionFAQlist();
    }
    
    private void generateSectionSelectList() {
        sectionSelectOptions = new List<SelectOption>();
        sectionSelectOptions.add(new SelectOption('', label.Str_All_Topics));
        selectedSection = DOL_AppConstants.NULL_EMPTY_STRING + '';
        Set<String> sections = new Set<String>();
        
        for(Newsfeed__c faq : allFAQs) {
            if(String.isNotEmpty(faq.Section__c)) {
                sections.add(faq.Section__c);
            }
        }
        
        for(String section : sections) {
            sectionSelectOptions.add(new SelectOption(section, section));
        }
    }
    
    private void refreshSectionFAQlist() {
        sectionFAQs = new List<Newsfeed__c>();
        
        for(Newsfeed__c faq : allFAQs) {
            if(String.isNotEmpty(faq.Section__c) && ( faq.Section__c == selectedSection || String.isEmpty(selectedSection) )) {
                sectionFAQs.add(faq);
            }
        }
    }
    
    
}