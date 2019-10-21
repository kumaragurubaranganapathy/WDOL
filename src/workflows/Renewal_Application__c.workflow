<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_submission_renewal_reinstatement</fullName>
        <description>Application submission - renewal reinstatement</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Application_submission_renewal_reinstatement_final</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Complete</fullName>
        <field>Renewal_Status__c</field>
        <literalValue>Complete</literalValue>
        <name>Update Status to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email - Application submission - renewal reinstatement</fullName>
        <actions>
            <name>Application_submission_renewal_reinstatement</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Application_submission_renewal_reinstatement</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Renewal_Application__c.Renewal_Status__c</field>
            <operation>equals</operation>
            <value>In-Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Renewal_Application__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Email_Outbound_Application_submission_renewal_reinstatement</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Renewal_Application__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Application submission - renewal reinstatement</subject>
    </tasks>
</Workflow>
