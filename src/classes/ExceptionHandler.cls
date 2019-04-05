/**
* User Story: 108 - Promote user, to a business user, by creating an account on the portal
* Class Name: ExceptionHandler
* Test Class Name: ExceptionHandler_Test
* Description: Apex class to handle exceptions for Email Services.
* Date:            Developer/Company                    Description
* ---------------------------------------------------------------------------------------------------------------------------------------- *
* 08/02/2018    Srikanth Kottam/Deloitte           	  Initial Creation
**/
public with sharing class ExceptionHandler 
{
	public static string exceptionEmailAccount ;
	
	static
	{
   		List<Name_Value_Pair__mdt> nVals = [Select ID , Name__c, Value__c from Name_Value_Pair__mdt Where Name__c = 'Exception occured while Processing request' limit 1 ] ;
   		if(nVals != null && nVals.isEmpty() == false )
   		{
   			exceptionEmailAccount = nVals[0].Value__c ;
   		}
	}
	 
public static void processException(Exception ex , string location, String addtionalIfo)
    {
   			
   			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.Setsubject('Exception occured while Processing request') ;
            string mailBody = 'The following exception occured while processing your Request, Below are details  <br/> <br/> <br/>' + 
                '<b>Exception Location :- </b> ' + location + '<br/><br/> ' +
                '<b>Exception Type :- </b> ' + ex.getTypeName() + '<br/><br/> ' +
                '<b>Exception Message :-</b>'+ ex.getMessage() + ' <br/><br/>' + 
                '<b>Exception line number  :-</b>'+ ex.getLineNumber() + ' <br/><br/>' +
                '<b>Exception Stack traces :-</b>'+ ex.getStackTraceString() + ' <br/><br/><br/>' +
                '<b>Exception Cause :- </b> ' + ex.getCause() + ' <br/><br/>'  +
                '<b>Additional Details   :- </b> ' + addtionalIfo + ' <br/><br/>'  +
                '<b> Thanks & Regards </b><br/> WI eSLA Team ';
      		     mail.setHTMLBody(mailBody);
            mail.setToAddresses(new String[] {exceptionEmailAccount});
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        emails.add(mail);
        try
        {
        	Messaging.sendEmail(emails);
        }Catch(exception exp){}
    }
    
    
    public static void sendMessage(String messageDetail , String operationName )
    {
   			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.Setsubject(operationName) ;
            string mailBody = 
                '<b>Additional Details   :- </b> ' + messageDetail + ' <br/><br/>'  +
                '<b> Thanks & Regards </b><br/> WI eSLA Team ';
      		     mail.setHTMLBody(mailBody);
            mail.setToAddresses(new String[] {exceptionEmailAccount});
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        emails.add(mail);
        try
        {
        	Messaging.sendEmail(emails);
        }Catch(exception exp){}
    }
}