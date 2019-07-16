<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MUSW__Receipt_Amount_adjust_Available</fullName>
        <field>MUSW__Amount_Available__c</field>
        <formula>PRIORVALUE(MUSW__Amount_Available__c) + MUSW__Amount_Tendered__c - BLANKVALUE(PRIORVALUE( MUSW__Amount_Tendered__c ),0)</formula>
        <name>Receipt Amount adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Receipt_Reject_adjust_Available</fullName>
        <field>MUSW__Amount_Available__c</field>
        <formula>PRIORVALUE(MUSW__Amount_Available__c) + BLANKVALUE(PRIORVALUE(MUSW__Amount_Rejected__c),0) - BLANKVALUE(MUSW__Amount_Rejected__c,0)</formula>
        <name>Receipt Reject adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Receipts_Amounts_Adjust_Available</fullName>
        <field>MUSW__Amount_Available__c</field>
        <formula>PRIORVALUE(MUSW__Amount_Available__c) + 
(MUSW__Amount_Tendered__c - BLANKVALUE(PRIORVALUE( MUSW__Amount_Tendered__c ),0)) + 
(BLANKVALUE(PRIORVALUE(  MUSW__Amount_Rejected__c  ),0) - MUSW__Amount_Rejected__c  )</formula>
        <name>Receipts Amounts Adjust Available</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__SetReceiptAvailableAmount</fullName>
        <field>MUSW__Amount_Available__c</field>
        <formula>MUSW__Amount_Tendered__c -  BLANKVALUE(MUSW__Amount_Rejected__c, 0)</formula>
        <name>Set Receipt Available Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MUSW__Receipt Amount %26 Rejected Changed</fullName>
        <actions>
            <name>MUSW__Receipts_Amounts_Adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(MUSW__Amount_Tendered__c),ISCHANGED(  MUSW__Amount_Rejected__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Receipt Amount Changed</fullName>
        <actions>
            <name>MUSW__Receipt_Amount_adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(MUSW__Amount_Tendered__c),NOT(ISCHANGED(  MUSW__Amount_Rejected__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Receipt Blank Available Amount</fullName>
        <actions>
            <name>MUSW__SetReceiptAvailableAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Receipt__c.MUSW__Amount_Available__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Receipt__c.MUSW__Amount_Tendered__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Receipt Reject Changed</fullName>
        <actions>
            <name>MUSW__Receipt_Reject_adjust_Available</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(MUSW__Amount_Rejected__c),NOT(ISCHANGED( MUSW__Amount_Tendered__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
