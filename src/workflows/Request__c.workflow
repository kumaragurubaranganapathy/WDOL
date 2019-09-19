<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Maintenance_request_complete</fullName>
        <ccEmails>smahankali@deloitte.com</ccEmails>
        <description>Maintenance request complete</description>
        <protected>false</protected>
        <recipients>
            <field>Request_Applicant__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Maintenance_request_complete_final</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_submission_review_required</fullName>
        <description>Maintenance submission - review required</description>
        <protected>false</protected>
        <recipients>
            <field>Request_Applicant__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Maintenance_submission_review_required_final</template>
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
        <fullName>Email - Maintenance request complete</fullName>
        <actions>
            <name>Maintenance_request_complete</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Maintenance_request_complete</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Maintenance submission - review required</fullName>
        <actions>
            <name>Maintenance_submission_review_required</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Maintenance_submission_review_required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Automation rule for email notification: Maintenance submission - review required</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
    <tasks>
        <fullName>Email_Outbound_Maintenance_request_complete</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Request__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Maintenance request complete</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Maintenance_submission_review_required</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Request__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Maintenance submission - review required</subject>
    </tasks>
</Workflow>
