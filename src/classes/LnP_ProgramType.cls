public class LnP_ProgramType{
    
    @AuraEnabled
    public Static Map<String, List<String>> getDependency(sObject objDetail, string contrfieldApiName,string depfieldApiName){
        return LnP_getDependentPicklist.getDependentMap(objDetail, contrfieldApiName, depfieldApiName);
    }
    
    
    @AuraEnabled
    public static string deleteCustomerEnvelope(Customer_Envelope__c custEnv){
        system.debug('custEnv : '+custEnv);
        try{
            delete custEnv;
            return 'success';
        }catch(Exception e){
            System.debug('Exception : '+ e.getMessage() );
            return 'fail';
        }
        
    }
    @AuraEnabled         
    public static Map<String, String> getDefaultProgramType() {
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Customer_Envelope__c.wadol_DefaultProgramType__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        
        Return mapOptions;
        
    } 
    /*
@AuraEnabled         
public static Map<String,Map<String, String>> getDefaultProgramType() {
Map<String,Map<String, String>>  mapOptions = new Map<String,Map<String, String>>();

Map<String, String> defaultProgramTypeMap = new Map<String, String>();
Schema.DescribeFieldResult defaultProgramResult = Customer_Envelope__c.wadol_DefaultProgramType__c.getDescribe();
List<Schema.PicklistEntry> defaultProgramValues = defaultProgramResult.getPicklistValues();
for(Schema.PicklistEntry p: defaultProgramValues){
//Put Picklist Value & Label in Map
defaultProgramTypeMap.put(p.getValue(), p.getLabel());
}

Map<String, String> statusMap = new Map<String, String>();
Schema.DescribeFieldResult statusResult = Customer_Envelope__c.Status__c.getDescribe();
List<Schema.PicklistEntry> statusValues = statusResult.getPicklistValues();
for(Schema.PicklistEntry p: statusValues){
//Put Picklist Value & Label in Map
statusMap.put(p.getValue(), p.getLabel());
}
mapOptions.put('PROGRAMTYPE',defaultProgramTypeMap);
mapOptions.put('STATUS',statusMap);

Return mapOptions;

}   */ 
    @AuraEnabled 
    public static Map<String, String> getPayment() {
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Receipt__c.MUSW__Payment_Method__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        
        Return mapOptions;
        
    } 
    
    @AuraEnabled         
    public static Map<String, String> getProgramType() {
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Deposit__c.wadol_Program_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        Return mapOptions;
    } 
    
    @AuraEnabled        
    public static Map<String, String> getFormNumber() {
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Deposit__c.Form_number__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        Return mapOptions;
    } 
    
    /*   @AuraEnabled
public static Customer_Envelope__c getcustomerEnvelopeInfo(){
system.debug('inside the controller');
Customer_Envelope__c customerEnvelpe=[SELECT id,Date_Today_s__c FROM Customer_Envelope__c LIMIT 1];
system.debug('return is' +customerEnvelpe);
return customerEnvelpe;
}*/
    
    @AuraEnabled
    public static MUSW__Receipt__c getReceiptInfo(){
        system.debug('inside the controller');
        MUSW__Receipt__c receiptInfo=[SELECT id,Date_Today_s__c FROM MUSW__Receipt__c LIMIT 1];
        system.debug('return is' +receiptInfo);
        return receiptInfo;
    }
    
    @AuraEnabled
    public static MUSW__Deposit__c getDepositInfo(){
        system.debug('inside the controller');
        MUSW__Deposit__c depositInfo=[SELECT id,Date_Today_s__c FROM MUSW__Deposit__c LIMIT 1];
        system.debug('return is' +depositInfo);
        return depositInfo;
    }
    
    @AuraEnabled
    public static void saveReciept(List<MUSW__Receipt__c> recList){        
        system.debug('the reclist is:' +recList);
        insert recList;
    }
    @AuraEnabled
    public static List<ListView> getObjViews() {
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType = 'Customer_Envelope__c'];
        
        return listviews;
    }
    @AuraEnabled
    //public static void saveReciptRecords(){
    public static MUSW__Receipt__c saveReciptRecords(MUSW__Receipt__c receiptRecord){
        receiptRecord.Intake_Method__c = 'Validation Room';
        system.debug('inside save method');
        system.debug('the reclist is' +receiptRecord);
        insert receiptRecord;
        return receiptRecord;
    } 
    @AuraEnabled
    public static MUSW__Receipt__c updateRecieptRec(MUSW__Receipt__c recList){
        system.debug('recList : '+recList);      
        update recList;
        return recList;
    }
    
    @AuraEnabled        
    public static MUSW__Deposit__c saveDeposit_Receipt_Records(MUSW__Deposit__c depRecList){
        
        system.debug('depRecList : ' + depRecList); 
        try{
            insert depRecList;
        }catch(Exception e){
            system.debug('Exception : ' + e.getMessage());
            system.debug('Exception : ' + e.getStackTraceString());
        }
        return depRecList; 
    }
    @AuraEnabled        
    public static MUSW__Deposit__c updateDepositRec(MUSW__Deposit__c depList){
        system.debug('depList : '+depList);
        update depList   ;
        return depList;
    }
    
    //new class
    @AuraEnabled
    public static string updateEnvelopRec(String programType,List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr ,Customer_Envelope__c customerEnvelopeRec,String parRecordId){
        system.debug('programType : '+programType);
        system.debug('List<MUSW__Receipt__c> : '+ recRecLstArr);
        system.debug('List<MUSW__Deposit__c> : '+ depRecLstArr);
        system.debug('Customer_Envelope__c : '+ customerEnvelopeRec);
        system.debug('Customer_Envelope__c id is: '+ customerEnvelopeRec.Id);
        system.debug('parentRecordId is: '+ parRecordId);
        String lockBoxId= parRecordId;
        
        system.debug('lockBoxId---> is: '+ lockBoxId);
        createPayableReceipt(recRecLstArr,depRecLstArr);
        
        customerEnvelopeRec.wadol_DefaultProgramType__c= programType; 
        
        if(lockBoxId !=null){
            customerEnvelopeRec.Lockbox_Envelope__c=lockBoxId;
        }
        update customerEnvelopeRec  ;
        system.debug('updated customerEnvelopeRec '+customerEnvelopeRec);
        
        list<MUSW__Deposit__c> updateDepLst = new list<MUSW__Deposit__c>();
        for(MUSW__Deposit__c dep : depRecLstArr){
            MUSW__Deposit__c d = new MUSW__Deposit__c(id = dep.id);
            d.Validation_number__c = customerEnvelopeRec.ID;
            updateDepLst.add(d);
        }
        if(!updateDepLst.isEmpty()){
            update updateDepLst;  
            system.debug('updateDepLst : '+updateDepLst);
        }  
        
        list<MUSW__Receipt__c> updateRecLst = new list<MUSW__Receipt__c>();
        for(MUSW__Receipt__c rec : recRecLstArr){                
            rec.Validation_number__c = customerEnvelopeRec.ID;
            updateRecLst.add(rec);
        }
        if(!updateRecLst.isEmpty()){
            update updateRecLst;  
            system.debug('updateRecLst : '+updateRecLst);
        }   
        try{ 
        }catch(exception e){
            system.debug('***EXCEPTION : '+e.getMessage());
            system.debug('Exception : ' + e.getStackTraceString());
            return 'failure';
        }        
        return 'success';
    }    
    
    @AuraEnabled    
    public static Customer_Envelope__c getValidationNumberInfo(){
        system.debug('inside getValidationNumberInfo');
        Customer_Envelope__c customerEnvelopeRec=new Customer_Envelope__c();          
        insert customerEnvelopeRec;
        system.debug('customerEnvelopeRec : '+customerEnvelopeRec);
        return [SELECT id,Date_Today_s__c,Validation_number__c FROM Customer_Envelope__c WHERE Id =: customerEnvelopeRec.Id LIMIT 1];
        //return customerEnvelopeRec;
    }
    
    public static void createPayableReceipt(List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr){
        //payment receipt logic
        BGBK.Payable[] payables = new BGBK.Payable[]{};
            for (MUSW__Deposit__c dep : depRecLstArr){              
                payables.add(new BGBK.Payable(dep, dep.Amount__c));               
            }
        
        Map<MUSW__Receipt__c, Decimal> receiptMap = new Map<MUSW__Receipt__c, Decimal>();
        for(MUSW__Receipt__c rec : recRecLstArr){
            receiptMap.put(rec, rec.MUSW__Amount_Tendered__c);
        }
        
        DateTime myDateTime = DateTime.newInstance(2000, 7, 7, 7, 8, 12);   
        BGBK.PaymentService paymentServiceObj = new BGBK.PaymentService();
        system.debug('payables : ' +payables);
        system.debug('receiptMap : '+receiptMap);
        paymentServiceObj.processPayment(payables, receiptMap,null,myDateTime);
        //  global virtual Boolean processPayment(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        
        /*  public void preparePayables(){
System.debug(' inside preparePayables'); 
System.debug(' fee '+feeVos);
System.debug(' invoiceVos '+invoiceVos);
System.debug(' depositVOs '+depositVOs);

payables = new BGBK.Payable[]{};

for (FeeVO fvo : feeVos) if (fvo.isSelected && fvo.paymentAmount>0) payables.add(new BGBK.Payable(fvo.f, fvo.paymentAmount));
for (InvoiceVO ivo : invoiceVos) if (ivo.isSelected && ivo.paymentAmount>0) payables.add(new BGBK.Payable(ivo.i, ivo.paymentAmount));
for (DepositVO depVO : depositVOs){
if(depVO.isSelected){
payables.add(new BGBK.Payable(depVO.deposit, depVO.paymentAmount));
}
}
}*/
        /*
        //old code
        list<MUSW__Payable_Receipt__c> payList = new list<MUSW__Payable_Receipt__c>();
        
        
        for(integer r=0 ; r < recRecLstArr.size() ; r++ ){
            decimal receiptAmountDiff = recRecLstArr[r].MUSW__Amount_Tendered__c;
            
            for(integer d=0 ; d < depRecLstArr.size(); d++ ){
                
                if(depRecLstArr[d].Amount__c != 0) {
                    
                    if( receiptAmountDiff == depRecLstArr[d].Amount__c){
                        MUSW__Payable_Receipt__c pay = new MUSW__Payable_Receipt__c();
                        pay.MUSW__Receipt__c = recRecLstArr[r].Id;       
                        pay.MUSW__Deposit__c = depRecLstArr[d].Id; 
                        pay.MUSW__Amount__c = receiptAmountDiff;                           
                        depRecLstArr[d].Amount__c = 0;
                        system.debug('pay : 1'+ pay);
                        payList.add(pay);  
                        break;
                        
                    }
                    
                    if(receiptAmountDiff > depRecLstArr[d].Amount__c){
                        MUSW__Payable_Receipt__c pay = new MUSW__Payable_Receipt__c();
                        pay.MUSW__Receipt__c = recRecLstArr[r].Id;       
                        pay.MUSW__Deposit__c = depRecLstArr[d].Id; 
                        pay.MUSW__Amount__c = depRecLstArr[d].Amount__c;
                        receiptAmountDiff = receiptAmountDiff - depRecLstArr[d].Amount__c ;
                        depRecLstArr[d].Amount__c = 0;
                        system.debug('pay : 2'+ pay);
                        payList.add(pay);  
                        continue;
                    }
                    
                    if(receiptAmountDiff < depRecLstArr[d].Amount__c){
                        MUSW__Payable_Receipt__c pay = new MUSW__Payable_Receipt__c();
                        pay.MUSW__Receipt__c = recRecLstArr[r].Id;       
                        pay.MUSW__Deposit__c = depRecLstArr[d].Id; 
                        pay.MUSW__Amount__c = receiptAmountDiff;
                        depRecLstArr[d].Amount__c = depRecLstArr[d].Amount__c - receiptAmountDiff;
                        system.debug('pay : 3'+ pay);
                        payList.add(pay);  
                        break; 
                    }
                }
                
            }
        }      
        if(!payList.isEmpty()){
            insert payList; 
            system.debug('inserted pList : '+payList);
        }  
        */
        //payment receipt logic ends
    }
    
    
    
}