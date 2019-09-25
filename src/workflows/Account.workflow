<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_SecurityCode</fullName>
        <field>Security_Code__c</field>
        <formula>Right(Id, 7)</formula>
        <name>Set SecurityCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Course_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Course_Provider</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Course Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Grace Period</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Certificate_Mailed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>DSPS Tax delinquency grace period</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Certificate_Mailed_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Security Code for Account</fullName>
        <actions>
            <name>Set_SecurityCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Security_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Validation_Workflow_Rules__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Generates Security code for Account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Record Type Id</fullName>
        <actions>
            <name>Update_Course_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Course_Provider__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
