<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_SR_Completed_Email</fullName>
        <description>Send SR Completed Email</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>niinani@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Request_Completed</template>
    </alerts>
    <alerts>
        <fullName>Send_SR_Submitted_Email</fullName>
        <description>Send SR Submitted Email</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>niinani@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Service_Request_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Application_Fill_Latitude_from_Parcel</fullName>
        <field>Geolocation__Latitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Latitude__s</formula>
        <name>Application - Fill Latitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Fill_Longitude_from_Parcel</fullName>
        <field>Geolocation__Longitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Longitude__s</formula>
        <name>Application - Fill Longitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_UpdateIsAbandoned</fullName>
        <field>Is_Abandoned__c</field>
        <literalValue>1</literalValue>
        <name>Application_UpdateIsAbandoned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Application Parcel filled  - Geolocation blank</fullName>
        <actions>
            <name>Application_Fill_Latitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Application_Fill_Longitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a application&apos;s parcel lookup is filled and the Lat Long is blank the Lat Long fields should populate from the parcel.</description>
        <formula>NOT(ISBLANK(MUSW__Parcel__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send SR Completed Email</fullName>
        <actions>
            <name>Send_SR_Completed_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SR_Completed_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Application2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send SR Submitted Email</fullName>
        <actions>
            <name>Send_SR_Submitted_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SR_Submitted_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Application2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>SR_Completed_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>SR Completed Email Sent</subject>
    </tasks>
    <tasks>
        <fullName>SR_Submitted_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>SR Submitted Email Sent</subject>
    </tasks>
</Workflow>
