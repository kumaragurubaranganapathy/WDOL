public with sharing class LnP_ProgramType{
    
    @AuraEnabled
    public Static Map<String, List<String>> getDependency(sObject objDetail, string contrfieldApiName,string depfieldApiName){
        try{
        return LnP_getDependentPicklist.getDependentMap(objDetail, contrfieldApiName, depfieldApiName);
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static string deleteCustomerEnvelope(Customer_Envelope__c custEnv){
      //  system.debug('custEnv : '+custEnv);
        try{
            delete custEnv;
            return 'success';
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
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
    
    @AuraEnabled 
    public static Map<String, String> getPayment() {
        try{
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Receipt__c.MUSW__Payment_Method__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        
        Return mapOptions;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    } 
    
    @AuraEnabled         
    public static Map<String, String> getProgramType() {
        try{
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Deposit__c.wadol_Program_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        Return mapOptions;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    } 
    
    @AuraEnabled        
    public static Map<String, String> getFormNumber() {
        try{
        Map<String, String> mapOptions = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = MUSW__Deposit__c.Form_number__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p: pList){
            //Put Picklist Value & Label in Map
            mapOptions.put(p.getValue(), p.getLabel());
        }
        Return mapOptions;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    } 
    
    
    @AuraEnabled
    public static MUSW__Deposit__c getDepositInfo(){
        try{
     //   system.debug('inside the controller');
        MUSW__Deposit__c depositInfo=[SELECT id,Date_Today_s__c FROM MUSW__Deposit__c LIMIT 1];
     //   system.debug('return is' +depositInfo);
        return depositInfo;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static void saveReciept(List<MUSW__Receipt__c> recList){        
        try{
     //   system.debug('the reclist is:' +recList);
        insert recList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    public static List<ListView> getObjViews() {
        try{
        List<ListView> listviews = 
            [SELECT Id, Name FROM ListView WHERE SobjectType =: DOL_AppConstants.NULL_EMPTY_STRING + 'Customer_Envelope__c'];
        
        return listviews;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    @AuraEnabled
    //public static void saveReciptRecords(){
    public static MUSW__Receipt__c saveReciptRecords(MUSW__Receipt__c receiptRecord){
        try{
        receiptRecord.Intake_Method__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Validation Room';
      //  system.debug('inside save method');
      //  system.debug('the reclist is' +receiptRecord);
        insert receiptRecord;
        return receiptRecord;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    } 
    @AuraEnabled
    public static MUSW__Receipt__c updateRecieptRec(MUSW__Receipt__c recList){
        try{
    //    system.debug('recList : '+recList);      
        update recList;
        return recList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    @AuraEnabled        
    public static MUSW__Deposit__c saveDeposit_Receipt_Records(MUSW__Deposit__c depRecList){
        
      //  system.debug('depRecList before insert: ' + depRecList); 
        try{
            insert depRecList;
          //  system.debug('depRecList after insert : ' + depRecList); 
            return depRecList; 
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
        
    }
    @AuraEnabled        
    public static MUSW__Deposit__c updateDepositRec(MUSW__Deposit__c depList){
        try{
    //    system.debug('before depList : '+depList);
        update depList   ;
     //    system.debug('after depList : '+depList);
        return depList;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    //new class
    @AuraEnabled
    public static string updateEnvelopRec(String programType,List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr ,Customer_Envelope__c customerEnvelopeRec,String parRecordId){
        try{
    //    system.debug('programType : '+programType);
     //   system.debug('List<MUSW__Receipt__c> : '+ recRecLstArr);
     //   system.debug('List<MUSW__Deposit__c> : '+ depRecLstArr);
     //   system.debug('Customer_Envelope__c : '+ customerEnvelopeRec);
    //    system.debug('Customer_Envelope__c id is: '+ customerEnvelopeRec.Id);
     //   system.debug('customerEnvelopeRec.Validation_number__c : '+ customerEnvelopeRec.Validation_number__c);
       // system.debug('parentRecordId is: '+ parRecordId);
        String lockBoxId= parRecordId;
        
        //system.debug('lockBoxId---> is: '+ lockBoxId);
        if( recRecLstArr != null && depRecLstArr != null){
            createPayableReceipt(recRecLstArr,depRecLstArr);
        }        
        //customerEnvelopeRec.wadol_DefaultProgramType__c= programType; 
        
        if(lockBoxId !=null){
            system.debug('inside if');
            customerEnvelopeRec.Lockbox_Envelope__c=lockBoxId;
        }
        if(customerEnvelopeRec != null){
            update customerEnvelopeRec  ;
        }
        //system.debug('updated customerEnvelopeRec '+customerEnvelopeRec);
        if(depRecLstArr != null && !depRecLstArr.isEmpty()){
            list<MUSW__Deposit__c> updateDepLst = new list<MUSW__Deposit__c>();
            for(MUSW__Deposit__c d : depRecLstArr){            
                d.Validation_number__c = customerEnvelopeRec.ID;
                d.ValidationNumber__c = customerEnvelopeRec.Validation_number__c;
                updateDepLst.add(d);
            }
            if(!updateDepLst.isEmpty()){
                update updateDepLst;  
          //      system.debug('updateDepLst : '+updateDepLst);
            } 
        }
        
        if( recRecLstArr != null && !recRecLstArr.isEmpty() ){
            list<MUSW__Receipt__c> updateRecLst = new list<MUSW__Receipt__c>();
            for(MUSW__Receipt__c rec : recRecLstArr){                
                rec.Validation_number__c = customerEnvelopeRec.ID;
                updateRecLst.add(rec);
            }
            if(!updateRecLst.isEmpty()){
                update updateRecLst;  
            //    system.debug('updateRecLst : '+updateRecLst);
            } 
        }
        
               
        return 'success';
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }    
    
    @AuraEnabled    
    public static Customer_Envelope__c getValidationNumberInfo(){
        try{
        //system.debug('inside getValidationNumberInfo');
        Customer_Envelope__c customerEnvelopeRec=new Customer_Envelope__c();          
        insert customerEnvelopeRec;
        //system.debug('customerEnvelopeRec : '+customerEnvelopeRec);
        return [SELECT id,Date_Today_s__c,Validation_number__c FROM Customer_Envelope__c WHERE Id =: customerEnvelopeRec.Id LIMIT 1];
        //return customerEnvelopeRec;
        }catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
    
    public static void createPayableReceipt(List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr){
        //payment receipt logic
        BGBK.Payable[] payables = new BGBK.Payable[]{};
            if(!depRecLstArr.isEmpty()){
                for (MUSW__Deposit__c dep : depRecLstArr){              
                    payables.add(new BGBK.Payable(dep, dep.Amount__c));               
                } 
            }
        Map<MUSW__Receipt__c, Decimal> receiptMap = new Map<MUSW__Receipt__c, Decimal>();
        if(!recRecLstArr.isEmpty()){                  
            for(MUSW__Receipt__c rec : recRecLstArr){
                receiptMap.put(rec, rec.MUSW__Amount_Tendered__c);
            }            
        }
        
        Datetime myDateTime = Datetime.now();  
        BGBK.PaymentService paymentServiceObj = new BGBK.PaymentService();
       // system.debug('payables : ' +payables);
        //system.debug('receiptMap : '+receiptMap);
        paymentServiceObj.processPayment(payables, receiptMap,null,myDateTime);
        //  global virtual Boolean processPayment(List<BGBK.Payable> payables, Map<MUSW__Receipt__c,Decimal> receiptAmounts, Id payerAccountId, Datetime processingDatetime) {
        
    }
    
    
    
}