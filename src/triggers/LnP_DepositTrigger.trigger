/* @author  :   Rishap
* @US       :   1966
* @discription :    Update Agency Code and Voucher Number field from Deposit to Receipt
*/ 
trigger LnP_DepositTrigger on MUSW__Deposit__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
 
    /* If the triggers have not been disabled, then call the trigger handler */
    TriggerDispatcher.Run(new LnP_DepositTriggerHandler()); 
}