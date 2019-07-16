<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approve_Refund</fullName>
        <field>Stage__c</field>
        <literalValue>Release</literalValue>
        <name>Approve Refund</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_Approval_Status_as_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Mark Approval Status as Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Refund</fullName>
        <field>Stage__c</field>
        <literalValue>Request</literalValue>
        <name>Reject Refund</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release_Refund</fullName>
        <field>Stage__c</field>
        <literalValue>Send Refund</literalValue>
        <name>Release Refund</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submit_Refund_for_Approval</fullName>
        <field>Stage__c</field>
        <literalValue>Approve</literalValue>
        <name>Submit Refund for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
