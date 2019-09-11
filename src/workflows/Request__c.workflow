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
    <alerts>
        <fullName>Approval_to_Reschedule_Exam</fullName>
        <description>Notification on AMR Approval to Reschedule Exam</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Request_to_Reschedule_Exam_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Request_Applicant_when_request_is_approved</fullName>
        <description>Email to Request Applicant when request is approved</description>
        <protected>false</protected>
        <recipients>
            <field>Request_Applicant__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Exam_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Request_Applicant_when_request_is_rejected</fullName>
        <description>Email to Request Applicant when request is rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Request_Applicant__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_to_Request_Applicant_when_request_is_rejected</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_request_complete</fullName>
        <description>Maintenance request complete</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Maintenance_request_complete_final</template>
    </alerts>
    <alerts>
        <fullName>Maintenance_submission_review_required</fullName>
        <description>Maintenance submission - review required</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Maintenance_submission_review_required_final</template>
    </alerts>
    <alerts>
        <fullName>Notification_on_AMR_Approval_to_Reschedule_Exam</fullName>
        <description>Notification on AMR Approval to Reschedule Exam</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Request_to_Reschedule_Exam_Approved</template>
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
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Maintenance submission - review required</fullName>
        <actions>
            <name>Maintenance_submission_review_required</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
        <fullName>Email to request applicant with approval status</fullName>
        <actions>
            <name>Email_to_Request_Applicant_when_request_is_approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approve</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to request applicant with deny status</fullName>
        <actions>
            <name>Email_to_Request_Applicant_when_request_is_rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Deny</value>
        </criteriaItems>
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
    <rules>
        <fullName>Send Email on Reschedule Exam Request Approval</fullName>
        <actions>
            <name>Approval_to_Reschedule_Exam</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Request__c.Service_Request_Type__c</field>
            <operation>equals</operation>
            <value>Reschedule Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
