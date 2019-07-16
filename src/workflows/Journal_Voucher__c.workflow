<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ApprovedBy</fullName>
        <field>Approved_By__c</field>
        <formula>$User.FirstName + &apos; &apos; + $User.LastName</formula>
        <name>ApprovedBy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ApprovedByDate</fullName>
        <field>Approved_by_Date__c</field>
        <formula>TODAY()</formula>
        <name>ApprovedByDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
