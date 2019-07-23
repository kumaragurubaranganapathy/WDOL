public class CashRegisterTriggerHandler {
    public static void handleBeforeInsert(List<Cash_Register__c> newList){
        Id validationRoomRecTypeId = Schema.SObjectType.Cash_Register__c.getRecordTypeInfosByName().get('Validation Room').getRecordTypeId();
        List<AggregateResult> aggRes = [Select sum(MUSW__Amount_Tendered__c),MUSW__Payment_Method__c from MUSW__Receipt__c where createdDate = Today group by MUSW__Payment_Method__c ];
        Map<String,Decimal> paymentTypeToAmountMap = new Map<String,Decimal>();
        for(AggregateResult agr :aggRes){
            paymentTypeToAmountMap.put((String)agr.get('MUSW__Payment_Method__c'),(Decimal)agr.get('expr0'));
        }
        system.debug('Map::'+paymentTypeToAmountMap);
        
        for(Cash_Register__c cr: newList){
            
            if(cr.RecordTypeId == validationRoomRecTypeId ){
                if((paymentTypeToAmountMap.containsKey('Cash') &&  cr.Total_Amount_of_Cash__c != paymentTypeToAmountMap.get('Cash')) || (!paymentTypeToAmountMap.containsKey('Cash') && cr.Total_Amount_of_Cash__c >0 ) ){
                    cr.Total_Amount_of_Cash__c.addError('Total Amount of Cash entered is not matching the system\'s calculated value '+paymentTypeToAmountMap.get('Cash'));
                }
                if((paymentTypeToAmountMap.containsKey('Check/Cashier\'s Check') && cr.Total_Amount_of_Cheque__c != paymentTypeToAmountMap.get('Check/Cashier\'s Check')) || (!paymentTypeToAmountMap.containsKey('Check/Cashier\'s Check') && cr.Total_Amount_of_Cheque__c >0) ){
                    cr.Total_Amount_of_Cheque__c.addError('Total Amount of Cheque entered is not matching the system\'s calculated value '+paymentTypeToAmountMap.get('Check/Cashier\'s Check'));
                }
                if((paymentTypeToAmountMap.containsKey('Vitalcheck') && cr.Total_from_Vitalcheck__c != paymentTypeToAmountMap.get('Vitalcheck')) || (!paymentTypeToAmountMap.containsKey('Vitalcheck') && cr.Total_from_Vitalcheck__c > 0) ){
                    cr.Total_from_Vitalcheck__c.addError('Total from Vitalcheck entered is not matching the system\'s calculated value '+paymentTypeToAmountMap.get('Vitalcheck'));
                }
                if((paymentTypeToAmountMap.containsKey('Voucher') && cr.Total_Amount_for_Vouchers__c != paymentTypeToAmountMap.get('Voucher')) || (!paymentTypeToAmountMap.containsKey('Voucher') && cr.Total_Amount_for_Vouchers__c >0) ){
                    cr.Total_Amount_for_Vouchers__c.addError('Total Amount for Vouchers entered is not matching the system\'s calculated value '+paymentTypeToAmountMap.get('Voucher'));
                }
                
                if(paymentTypeToAmountMap.containsKey('NCR - cash')){
                    cr.Total_Amount_for_NCR_cash__c = paymentTypeToAmountMap.get('NCR - cash');
                }
                if(paymentTypeToAmountMap.containsKey('NCR - check')){
                    cr.Total_Amount_for_NCR_check__c = paymentTypeToAmountMap.get('NCR - check');
                }
                if(paymentTypeToAmountMap.containsKey('Cash')){
                    cr.Validation_Room_Cash_Total__c = paymentTypeToAmountMap.get('Cash');
                }
                if(paymentTypeToAmountMap.containsKey('Check/Cashier\'s Check')){
                    cr.Validation_Room_Cheque_Total__c = paymentTypeToAmountMap.get('Check/Cashier\'s Check');
                }
                if(paymentTypeToAmountMap.containsKey('Vitalcheck')){
                    cr.Validation_Room_Vitalcheck_Total__c = paymentTypeToAmountMap.get('Vitalcheck');
                }
                
            }
            
        }
        
    }
}