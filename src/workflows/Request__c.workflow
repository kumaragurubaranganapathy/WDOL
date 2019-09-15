<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AMR_Approval_Notification</fullName>
        <description>AMR Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Washington/Accept_invitation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Applicant_Email_Address_From_License_Obj</fullName>
        <field>Request_Applicant__c</field>
        <formula>License__r.MUSW__Applicant__r.Email</formula>
        <name>Applicant Email Address From License Obj</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Request</fullName>
        <field>OwnerId</field>
        <lookupValue>RBS_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Request_RE</fullName>
        <field>OwnerId</field>
        <lookupValue>RE_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email to RBS Queue for request</fullName>
        <actions>
            <name>Owner_Change_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status__c, &apos;Under Review&apos;) &amp;&amp; ( ISPICKVAL(License__r.Application_Type__c, &apos;Funerals&apos;) || ISPICKVAL(License__r.Application_Type__c, &apos;Cemeteries&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Engineers&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Land Surveyors&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;On-site Wastewater&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Geologist&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Architects&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Landscape Architects&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to RE Queue for request</fullName>
        <actions>
            <name>Owner_Change_Request_RE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Status__c, &apos;Under Review&apos;) &amp;&amp; ( ISPICKVAL(License__r.Application_Type__c, &apos;Camping Resorts&apos;) || ISPICKVAL(License__r.Application_Type__c, &apos;Appraisers -Real Estate&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Timeshares&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Notary Public&apos;) ||
ISPICKVAL(License__r.Application_Type__c, &apos;Appraisal Management Companies&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Request Applicant Email Update</fullName>
        <actions>
            <name>Applicant_Email_Address_From_License_Obj</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISBLANK(Request_Applicant__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
