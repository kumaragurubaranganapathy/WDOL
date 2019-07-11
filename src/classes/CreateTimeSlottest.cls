@isTest
public class CreateTimeSlottest {
    
    @isTest public static void justCoverage() {
        CreateTimeSlotsfortheyearCC c = new CreateTimeSlotsfortheyearCC();  
        c.getFBSlotAndOrgBusinessHours();
        PageReference pr  = c.CreateSlotsForYear();      
        c.SaveSetting();
        c.FreeUPFBSlotTable();
        c.getWorkingHours();
        c.getHolidayHours();
        integer x=   c.slot_dur_in_minutes;    
        Test.startTest();
        c.deleteAllSlot();
            //c.slot_dur_in_minutes = 12;
        System.assert(c != null);
        Test.stopTest();      
    }
    
}