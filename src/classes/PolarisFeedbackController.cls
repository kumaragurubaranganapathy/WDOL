public with sharing class PolarisFeedbackController {
	@auraEnabled
    public static void createRecord(User_Feedback__c userfeedback){
        List<User_Feedback__c> userfeedbackObjList = new List<User_Feedback__c>();
        userfeedbackObjList.add(userfeedback);
        System.debug('Apex Created Record'+userfeedback);
        try{
            if(userfeedbackObjList != null && userfeedbackObjList.size()>0){
            	Utilityclass_withsharing.insertList(userfeedbackObjList);
            }
        }catch (Exception ex){
            
        }
    }
}