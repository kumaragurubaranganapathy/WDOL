@isTest(SeeAllData = true)
public class ViolationAddEditBatchTest{


    @isTest(SeeAllData=true)
    private static void testBatch(){
    
        TriggerService.setLock();
        BGCM.TestMock tm = new BGCM.TestMock();
        MUSW__Parcel__c par = new MUSW__Parcel__c(Name= DOL_AppConstants.NULL_EMPTY_STRING + 'zsdfsf');
        insert par;
            
        MUSW__Complaint2__c c = new MUSW__Complaint2__c();
        c.MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Other';
        c.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'New';
        c.MUSW__Parcel__c = par.id;
        insert c; system.debug('c======' + c);

        MUSW__Inspection__c ins = new MUSW__Inspection__c();
                
        ins.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'abcefg123456';
        ins.MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'fieldObservations';
        ins.MUSW__Priority__c= DOL_AppConstants.NULL_EMPTY_STRING + '2 Normal';
        ins.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'New';
        ins.Close_Inspection__c = false;
        ins.MUSW__On_Itinerary__c = false;
        ins.Letter_Generated__c = false;
        ins.MUSW__Scheduled_Start_Date__c = Date.today();
        ins.Requested_DateTime__c = Date.today();
        ins.Completed_DateTime__c = Date.today();
        ins.MUSW__Completed_Date__c = Date.today();
        ins.MUSW__Closed_DateTime__c = Date.today();
        
        insert ins;
        
        MUSW__Violation__c v = new MUSW__Violation__c();
        v.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Open';
        v.MUSW__Complaint2__c = c.id;
        v.Days_to_correct_User_defined__c = 20.0;
        insert v;
        
        MUSW__Inspection_Violation__c  iv = new MUSW__Inspection_Violation__c();
        iv.MUSW__Inspection__c = ins.id;
        iv.MUSW__Violation__c = v.id;
        insert iv;

        MUSW__Inspection__c[] fos = new MUSW__Inspection__c[]{};

        MUSW__Inspection__c ins2 = new MUSW__Inspection__c();
                
        ins2.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'ethjnwhfb';
        ins2.MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Mechanical';
        ins2.MUSW__Priority__c= DOL_AppConstants.NULL_EMPTY_STRING + '2 Normal';
        ins2.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'New';
        ins2.Close_inspection__c = false;
        ins2.MUSW__On_Itinerary__c = false;
        ins2.Letter_Generated__c = false;
        ins2.MUSW__Scheduled_Start_Date__c = Date.today();
        ins2.Requested_DateTime__c = Date.today();
        ins2.Completed_DateTime__c = Date.today();
        ins2.MUSW__Completed_Date__c = Date.today();
        ins2.MUSW__Closed_DateTime__c = Date.today();
        
        fos.add(ins2);        
        insert ins2;
/*               
        MUSW__Inspection__c ins3 = new MUSW__Inspection__c();
                
        ins3.Name = DOL_AppConstants.NULL_EMPTY_STRING + 'fg';
        ins3.MUSW__Type__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Mechanical';
        ins3.MUSW__Priority__c= DOL_AppConstants.NULL_EMPTY_STRING + '2 Normal';
        ins3.MUSW__Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Pending';
        ins3.Close_inspection__c = true;
        ins3.MUSW__On_Itinerary__c = false;
        ins3.Letter_Generated__c = false;
        ins3.MUSW__Scheduled_Start_Date__c = null;
        ins3.Requested_DateTime__c = null;
        ins3.Completed_DateTime__c = Date.today();
        ins3.MUSW__Completed_Date__c = null;
        ins3.MUSW__Closed_DateTime__c = null;
        fos.add(ins3);        
        
        insert fos;
*/        
        
        MUSW__Inspection_Violation__c[] ivs = new MUSW__Inspection_Violation__c[]{};
        
        MUSW__Inspection_Violation__c  iv2 = new MUSW__Inspection_Violation__c();
        iv2.MUSW__Inspection__c = ins2.id;
        iv2.MUSW__Violation__c = v.id;
        ivs.add(iv2);
        insert iv2;
/*        
        MUSW__Inspection_Violation__c  iv3 = new MUSW__Inspection_Violation__c();
        iv3.MUSW__Inspection__c = ins3.id;
        iv3.MUSW__Violation__c = v.id;                
        ivs.add(iv3);
        insert iv3;
       // insert ivs;
        
        system.debug('iv2='+ iv2);
        system.debug('iv3='+ iv3);
*/        
        //update iv2;
        
       //   update iv3;
        
        Test.startTest();
        
        Id batchInstanceId = Database.executeBatch(new ViolationAddEditBatch(ins, fos, ivs), 2);
        
        Test.stopTest();
        
    }     


}