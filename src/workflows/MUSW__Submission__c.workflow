<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Owner_Change_Submission_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Submissions_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Submission Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submission_Queue_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>Submission_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Submission Queue Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Orphaned Submission Queue Assignment</fullName>
        <actions>
            <name>Owner_Change_Submission_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Submission_Queue_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Submission__c.SAN_Image_URL__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
