<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Invoice_Due_Date</fullName>
        <description>Update Invoice Due Date to 30 days from current date</description>
        <field>BGBK__Due_Date__c</field>
        <formula>BGBK__Invoice_Date__c + 30</formula>
        <name>Update Invoice Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Invoice Due Date</fullName>
        <actions>
            <name>Update_Invoice_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BGBK__Bill__c.BGBK__Invoice_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Invoice due date</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
