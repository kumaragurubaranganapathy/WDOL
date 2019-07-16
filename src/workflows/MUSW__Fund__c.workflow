<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MUSW__SetFundAmountDollar</fullName>
        <field>MUSW__Original_Amount__c</field>
        <formula>IF(ISNULL(MUSW__Original_Full_Amount__c),0,MUSW__Original_Full_Amount__c)</formula>
        <name>Set Fund Amount (Dollar)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MUSW__Zero Fund Amount %28Dollar%29</fullName>
        <actions>
            <name>MUSW__SetFundAmountDollar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Fund__c.MUSW__Original_Amount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Copies the dollar portion of the Fund Amount to the Amount (Dollar) field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
