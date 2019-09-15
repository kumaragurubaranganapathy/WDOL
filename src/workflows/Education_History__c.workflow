<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
     <fieldUpdates>
        <fullName>Update_Exam_Status</fullName>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Update Exam Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reschedule_Flag</fullName>
        <field>Reschedule_Possible__c</field>
        <literalValue>1</literalValue>
        <name>Update Reschedule Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reschedule_Possible_Flag</fullName>
        <field>Reschedule_Possible__c</field>
        <literalValue>1</literalValue>
        <name>Update Reschedule Possible Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Exam Status On Expiration</fullName>
        <actions>
            <name>Update_Exam_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the status of the exam if the exam expiration date is passed.</description>
        <formula>TODAY() &gt; Exam_Result_Expiry_Date__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Reschedule Flag on Exam</fullName>
        <actions>
            <name>Update_Reschedule_Possible_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 ) AND 4</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>No Show</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Reschedule_via_DOL__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
