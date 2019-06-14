@isTest
public class FetchInstructions_Test {

    @isTest
    public static void testInstructions01(){
        FetchInstructions fi = new FetchInstructions();
        String instructions = fi.getInstructions('Invalid Value', 'Invalid Value');
        system.assert(instructions == null || instructions == '' || instructions == label.Str_INSTRUCTIONS_NOT_FOUND);
    }
    
    @isTest
    public static void testInstructions02(){
        FetchInstructions fi = new FetchInstructions();
        Newsfeed__c news = fi.getInstructionObject('Invalid Value', 'Invalid Value');
        String instructions = news.Instructions__c;
        system.assert(instructions == null || instructions == '' || instructions == label.Str_INSTRUCTIONS_NOT_FOUND);
    }
    
    @isTest
    public static void testInstructions03(){
        RecordType rt = [Select Id From RecordType where sObjectType='Newsfeed__c' AND name='FAQ'];
        
        Newsfeed__c news = new Newsfeed__c();
        news.Name = 'Test';
        news.Instructions__c = 'Test Instructions';
        news.RecordTypeId = rt.Id;
        news.External_Id__c = '999999';
        insert news;
        
        FetchInstructions fi = new FetchInstructions();
        String instructions = fi.getInstructions('Test', 'FAQ');
        system.assert(instructions == 'Test Instructions');
    }
    
    @isTest
    public static void testInstructions04(){
        RecordType rt = [Select Id From RecordType where sObjectType='Newsfeed__c' AND name='FAQ'];
        
        Newsfeed__c news = new Newsfeed__c();
        news.Name = 'Test';
        news.Instructions__c = 'Test Instructions';
        news.RecordTypeId = rt.Id;
        news.External_Id__c = '999999';
        insert news;
        
        FetchInstructions fi = new FetchInstructions();
        Newsfeed__c news2 = fi.getInstructionObject('Test', 'FAQ');
        String instructions = news2.Instructions__c;
        system.assert(instructions == 'Test Instructions');
    }
}