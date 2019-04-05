/****************************************************************************** 
** User Story:
*********************************************************************************
** Class Name   : FetchInstructions
** Description  : Fetch Instructions fro the page
** Version      : Initial Version
** Built By     : 
**--------------------------------------------------------------------------------
** Modification Log: 
**------------------
** Developer                  Date          Version               Description
**--------------------------------------------------------------------------------
** 
**---------------
** Reviewer                  Date          Version               Description
**--------------------------------------------------------------------------------
** 
********************************************************************************/

public class FetchInstructions{
 
    public string getInstructions(String name, String instructionType){

        String instructions;
        try{
            List<Newsfeed__c> ins = [SELECT Id, name, RecordType.Name, Instructions__c
                            FROM Newsfeed__c
                            WHERE recordtypeId IN (SELECT Id FROM RecordType WHERE sobjecttype='Newsfeed__c' AND name=:instructionType) AND name=:name  LIMIT 1];
            if(ins.size()>0)
            {
                instructions = ins[0].Instructions__c;
            }
            else
            {
                instructions = label.Str_INSTRUCTIONS_NOT_FOUND;
            }
        }catch(DmlException e){
           ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'News', 'Getting Instructions', 'getInstructions', 'FetchInstructions', label.str_HIGH);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
            system.debug('Error: ' + e);
        }

        return instructions;
    }
    
    public Newsfeed__c getInstructionObject(String name, String instructionType){

        Newsfeed__c instructionObj = new Newsfeed__c();
        try{            
            
            List<Newsfeed__c> news = [SELECT Id, name, RecordType.Name, Instructions__c
                            FROM Newsfeed__c
                            WHERE recordtypeId IN (SELECT Id FROM RecordType WHERE sobjecttype='Newsfeed__c' AND name=:instructionType) AND name=:name  LIMIT 1];
                            
            if(news.size()>0)
            {
                instructionObj = news[0];
            }
        }catch(DmlException e){
            ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'News', 'Getting Instructions Object', 'getInstructionObject', 'FetchInstructions', label.str_HIGH);
             //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
             system.debug('Error: ' + e);
        }

        return instructionObj;
    }
}