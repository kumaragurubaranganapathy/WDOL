<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DSPS_Tax_Account_grace_period</fullName>
        <description>DSPS Tax Account grace period</description>
        <protected>false</protected>
        <recipients>
            <recipient>vagoel@deloitte.com.polaris.sit2</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Account_Grace_Period</template>
    </alerts>
    <alerts>
        <fullName>DSPS_Tax_delinquency_Account_Active</fullName>
        <description>DSPS Tax delinquency Account Active</description>
        <protected>false</protected>
        <recipients>
            <recipient>vagoel@deloitte.com.polaris.sit2</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Account_Active</template>
    </alerts>
    <alerts>
        <fullName>DSPS_Tax_delinquency_Account_OnHold</fullName>
        <description>DSPS Tax delinquency Account OnHold</description>
        <protected>false</protected>
        <recipients>
            <recipient>vagoel@deloitte.com.polaris.sit2</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Account_On_Hold</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_SecurityCode</fullName>
        <field>Security_Code__c</field>
        <formula>Right(Id, 7)</formula>
        <name>Set SecurityCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
            <actions>
                <name>DSPS_Tax_Account_grace_period</name>
                <type>Alert</type>
            </actions>
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
</Workflow>
