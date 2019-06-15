@isTest
public class CommonUtil_Test {

    @isTest
    public static void testPageParam(){
        String val = CommonUtil.getPageParam('Test');
        system.assertEquals(null, val);
        
        PageReference pageRef = Page.Application;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Test', '01');
        
        val = CommonUtil.getPageParam('Test');
        system.assertEquals('01', val);
    }
    
    @isTest
    public static void testIsBlank(){
        String str = '';
        Boolean val = CommonUtil.isBlank(str);
        system.assertEquals(true, val);
        
        str = 'Test';
        val = CommonUtil.isBlank(str);
        system.assertEquals(false, val);
    }
    
    @isTest
    public static void testIsNotBlank(){
        String str = '';
        Boolean val = CommonUtil.isNotBlank(str);
        system.assertEquals(false, val);
        
        str = 'Test';
        val = CommonUtil.isNotBlank(str);
        system.assertEquals(true, val);
    }
    
    @isTest
    public static void testIsNull(){
        Decimal dec = null;
        Boolean val = CommonUtil.isNull(dec);
        system.assertEquals(true, val);
        
        dec = 21.0;
        val = CommonUtil.isNull(dec);
        system.assertEquals(false, val);
    }
    
    @isTest
    public static void testIsDateBlank(){
        Date dt = null;
        Boolean val = CommonUtil.isDateBlank(dt);
        system.assertEquals(true, val);
        
        dt = Date.today();
        val = CommonUtil.isDateBlank(dt);
        system.assertEquals(false, val);
    }
    
    @isTest
    public static void testIsEmpty(){
        List<String> lstStr = null;
        Boolean val = CommonUtil.isEmpty(lstStr);
        system.assertEquals(true, val);
        
        val = CommonUtil.isNotEmpty(lstStr);
        system.assertEquals(false, val);
        
        lstStr = new List<String>{'abc', '123'};
        val = CommonUtil.isEmpty(lstStr);
        system.assertEquals(false, val);
        
        val = CommonUtil.isNotEmpty(lstStr);
        system.assertEquals(true, val);
    }
    
    @isTest
    public static void testToInteger(){
        String str = '123';
        Integer val = CommonUtil.toInteger(str);
        system.assertEquals(123, val);
    }
    
    @isTest
    public static void testToDecimal(){
        String str = '123.5';
        Decimal val = CommonUtil.toDecimal(str);
        system.assertEquals(123.5, val);
    }
    
    @isTest
    public static void testDateValue(){
        String str = '2018-10-15T00:00:00Z';
        Date val = CommonUtil.getDateValue(str);
        system.assertNotEquals(null, val);
        
        str = '1600-10-15T00:00:00Z';
        val = CommonUtil.getDateValue(str);
        system.assertEquals(null, val);
    }
    
    @isTest
    public static void testDateValueWithDateParse(){
        String str = '10/15/2018';
        Date val = CommonUtil.getDateValueWithDateParse(str);
        system.assertNotEquals(null, val);
        
        str = '10/15/1600';
        val = CommonUtil.getDateValueWithDateParse(str);
        system.assertEquals(null, val);
    }
    
    @isTest
    public static void testTruncatedDateTime(){
        Date dt = Date.today();
        DateTime val = CommonUtil.getTruncatedDateTime(dt);
        system.assertEquals(0, val.hour());
    }
    
    @isTest
    public static void testValidInputData(){
        Boolean val = CommonUtil.isValidInputData('[abc]','a');
        system.assertEquals(true, val);
        
        val = CommonUtil.isValidInputData('[abc]','xx');
        system.assertEquals(false, val);
    }
    
    @isTest
    public static void testDateYYYYMMDD(){
        Date dt = Date.newInstance(2018,10,15);
        String val = CommonUtil.getDateYYYYMMDD(dt);
        system.assertEquals('2018-10-15', val);
    }
    
    @isTest
    public static void testIsHoliday(){
        Date dt = Date.newInstance(2018,10,15);
        Boolean val = CommonUtil.isHoliday(dt);
    }
    
    @isTest
    public static void testDaysElapsed(){
        Date dt = Date.today();
        Integer val = CommonUtil.getDaysElapsed(dt.addDays(-20), dt);
        system.assertEquals(20, val);
    }
    
    @isTest
    public static void testRecordTypes(){
        String objectName = 'MUSW__License2__c';
        Map<String, Id> val = CommonUtil.getRecordTypes(objectName);
        system.assertNotEquals(null, val);
    }

    @isTest
    public static void testFields(){
        String objectName = 'MUSW__License2__c';
        String val = CommonUtil.getFields(objectName);
        system.assertNotEquals(null, val);
    }
    
    @isTest
    public static void testGenerateNewTimeSlots(){
        OrgSettings__c o = new OrgSettings__c(Minimum_Slot_duration__c = 8, Name = 'Test');
        insert o;
        
        DateTime startTime = DateTime.now().addDays(-30);
        DateTime endTime = DateTime.now();
        OrgSettings__c os = [Select Id, Minimum_Slot_duration__c From OrgSettings__c limit 1];
        BusinessHours bh = [Select Id From BusinessHours limit 1];
        
        CommonUtil.generateNewTimeSlots(startTime, endTime, os, bh);
    }
}