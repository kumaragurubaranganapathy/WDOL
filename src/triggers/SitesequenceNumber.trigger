trigger SitesequenceNumber on MUSW__Project2__c (before insert, before update) {
MUSW.SequenceNumber.updateNumbers(Trigger.new, Trigger.old);
}