public class LnP_ProgramType{
    private static Decimal currentamount = 0;
    private static List<MUSW__Receipt__c> recRecLocal = new List<MUSW__Receipt__c>();
    private static boolean isFirstTime = true;
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
        
        @AuraEnabled
        public static Customer_Envelope__c getcustomerEnvelopeInfo(){
            system.debug('inside the controller');
            Customer_Envelope__c customerEnvelpe=[SELECT id,Date_Today_s__c FROM Customer_Envelope__c LIMIT 1];
            system.debug('return is' +customerEnvelpe);
            return customerEnvelpe;
        }
        
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
            system.debug('inside save method');
          system.debug('the reclist is' +receiptRecord);
            insert receiptRecord;
            return receiptRecord;
        }
        
    @AuraEnabled        
    public static MUSW__Deposit__c saveDeposit_Receipt_Records(Integer paymentSourceTotal , Integer docTotal ,List<MUSW__Receipt__c> recRecLstArr , MUSW__Deposit__c depRecList){
        if(recRecLocal.isEmpty() && isFirstTime){
            recRecLocal = recRecLstArr;
        }
        system.debug('paymentSourceTotal : ' + paymentSourceTotal); 
         system.debug('docTotal : ' + docTotal); 
         system.debug('recRecLocal : ' + recRecLocal); 
         system.debug('depRecList : ' + depRecList); 
        try{
            insert depRecList;
           /* currentamount = paymentSourceTotal - (depRecList.Amount__c + currentamount);
            system.debug('currentamount : '+currentamount);
            list<MUSW__Payable_Receipt__c> pList = new list<MUSW__Payable_Receipt__c>();
            //
            if( currentamount == 0 && !recRecLocal.isEmpty() && recRecLocal.size() > 0 ){                
                for(MUSW__Receipt__c receiptRec : recRecLocal ){
                    MUSW__Payable_Receipt__c p = new MUSW__Payable_Receipt__c();
                    p.MUSW__Deposit__c = depRecList.Id;
                    p.MUSW__Receipt__c = receiptRec.Id;
                    p.MUSW__Amount__c = 0;
                    pList.add(p);
                }
                system.debug('pList == : '+pList);  
                isFirstTime = false;
            }
            else if(currentamount > 0  && !recRecLocal.isEmpty() && recRecLocal.size() > 0){
                MUSW__Payable_Receipt__c p = new MUSW__Payable_Receipt__c();             
                p.MUSW__Deposit__c = depRecList.Id;
                p.MUSW__Receipt__c =  recRecLstArr[0].Id;
                p.MUSW__Amount__c = 0;
                pList.add(p); 
                if(recRecLocal.size() != 1){
                    recRecLocal.remove(0);
                }
                 system.debug('pList == : '+pList);                  
            }
            if(!pList.isEmpty() && pList.size() > 0){
                insert pList; 
                system.debug('inserted pList : '+pList);
            }*/
                    
        }catch(Exception e){
            system.debug('Exception : ' + e.getMessage());
            system.debug('Exception : ' + e.getStackTraceString());
        }
        return depRecList; 
    }

    @AuraEnabled
    public static void bindReceiptToDeposit (List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr){
        for(MUSW__Deposit__c d : depRecLstArr){
            for(MUSW__Receipt__c r : recRecLstArr){
                MUSW__Payable_Receipt__c p = new MUSW__Payable_Receipt__c();
                p.MUSW__Deposit__c = d.Id;
                p.MUSW__Receipt__c = r.id;
            }
        }
    }
    
//new class
    @AuraEnabled
    public static string putEnvelopRec(String programType, List<MUSW__Receipt__c> recRecLstArr ,List<MUSW__Deposit__c> depRecLstArr ){
               system.debug('programType : '+programType);
        system.debug('List<MUSW__Receipt__c> : '+ recRecLstArr);
        system.debug('List<MUSW__Deposit__c> : '+ depRecLstArr);
        
        
        //payment receipt logic
        try{
            list<MUSW__Payable_Receipt__c> payList = new list<MUSW__Payable_Receipt__c>();
            if(recRecLstArr.size() < depRecLstArr.size()){
                decimal bigBalance = 0;
                for(MUSW__Receipt__c rec : recRecLstArr){
                    //storing the difference
                    //r1 -1500
                    //r2 - 1500
                    decimal smallBalance = rec.MUSW__Amount_Tendered__c; //1500 >500 > 0
                    
                    for(MUSW__Deposit__c dep : depRecLstArr){
                     
                            //d1 - 1000
                            //d2 -1000
                            //d3 - 1000
                        if(bigBalance > 0){
                            smallBalance = bigBalance;
                        }
                            MUSW__Payable_Receipt__c pay = new MUSW__Payable_Receipt__c();
                        
                            if(dep.Amount__c <= smallBalance ){//1
                                pay.MUSW__Receipt__c = rec.Id;       
                                pay.MUSW__Deposit__c = dep.Id; 
                                pay.MUSW__Amount__c = dep.Amount__c; //assigning the lesser among - 1000
                                smallBalance = (smallBalance - dep.Amount__c); // storing the difference 
                                
                                //r1 d1 1000 
                            }else{
                                //r1 d2 500
                                //r1 d3 500
                                pay.MUSW__Receipt__c = rec.Id;     
                                pay.MUSW__Deposit__c = dep.Id; 
                                pay.MUSW__Amount__c = smallBalance;//assigning the lesser among500                                
                                smallBalance = (smallBalance - dep.Amount__c) ; // storing the difference
                            }
                        system.debug('pay : '+ pay);
                            payList.add(pay);
                        
                        if(smallBalance < 0){
                            bigBalance = smallBalance.abs();
                        }
                        
                    }//dep loop
                       
                    
                }//rec loop
            }
            
                       
             if(!payList.isEmpty() && payList.size() > 0){
                insert payList; 
                system.debug('inserted pList : '+payList);
            }            
            //payment receipt logic ends
            
            //inserting the Env Recs :
            Customer_Envelope__c customerEnvelope=new Customer_Envelope__c();
            customerEnvelope.wadol_DefaultProgramType__c= programType;           
            insert customerEnvelope;
            ID customerEnvelopeId = customerEnvelope.ID;
           
            list<MUSW__Deposit__c> updateDepLst = new list<MUSW__Deposit__c>();
            for(MUSW__Deposit__c dep : depRecLstArr){
                dep.Validation_number__c = customerEnvelope.Id;
                updateDepLst.add(dep);
            }
            if(!updateDepLst.isEmpty() && updateDepLst.size() > 0 ){
               update updateDepLst;  
                system.debug('updateDepLst : '+updateDepLst);
            }  
            
            list<MUSW__Receipt__c> updateRecLst = new list<MUSW__Receipt__c>();
            for(MUSW__Receipt__c rec : recRecLstArr){
                rec.Validation_number__c = customerEnvelope.Id;
                updateRecLst.add(rec);
            }
            if(!updateRecLst.isEmpty() && updateRecLst.size() > 0 ){
                update updateRecLst;  
                system.debug('updateRecLst : '+updateRecLst);
            }   
            
        }catch(exception e){
            system.debug('***EXCEPTION : '+e.getMessage());
            return 'failure';
        }
        
        return 'success';
    }    
    
    
    @AuraEnabled
     public static void saveCustomerEnvelopeRecords(test testclass){
       
       system.debug('inside apex method class');
         Customer_Envelope__c customerEnvelope=new Customer_Envelope__c();
         customerEnvelope.wadol_DefaultProgramType__c='Funerals';
         system.debug('the instace values are:' +customerEnvelope);
         insert customerEnvelope;
         ID customerEnvelopeId = customerEnvelope.ID;
         system.debug('the id is' +customerEnvelopeId);
         
        /* MUSW__Deposit__c deposit=new MUSW__Deposit__c(
          Validation_number__c=customerEnvelopeId);
         insert deposit;
         
         MUSW__Receipt__c receipt=new MUSW__Receipt__c(
          Validation_number__c=customerEnvelopeId);
         insert receipt;*/
         
        }
    
     @AuraEnabled
        
        public static Customer_Envelope__c getValidationNumberInfo(){
        system.debug('inside save method');
        Customer_Envelope__c valNumber=[SELECT Id, Validation_number__c FROM Customer_Envelope__c ORDER BY Validation_number__c DESC LIMIT 1];
        system.debug('the valNumber is' +valNumber);
        return valNumber;
        }
    
    
    /* @AuraEnabled
        public static void saveReciept(List<MUSW__Receipt__c> recList){
            insert recList;
        }*/
    }