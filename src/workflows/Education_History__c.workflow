<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Exam_approval_email_Appraiser</fullName>
        <description>Exam approval email - Appraiser</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Sent_To__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_approval_email_Appraiser_final</template>
    </alerts>
    <alerts>
        <fullName>Exam_approval_email_RBS</fullName>
        <description>Exam approval email - RBS</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Sent_To__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_approval_email_RBS_final</template>
    </alerts>
    <alerts>
        <fullName>Exam_fail_notification_Geologist</fullName>
        <description>Exam fail notification - Geologist</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_fail_notification_Geologist_final</template>
    </alerts>
    <alerts>
        <fullName>Exam_pass_notification_FG_exam</fullName>
        <description>Exam pass notification - FG exam</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_pass_notification_FG_exam_final</template>
    </alerts>
    <alerts>
        <fullName>Exam_pass_notification_Law_Review</fullName>
        <description>Exam pass notification - Law Review</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Sent_To__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_pass_notification_Law_Review_final</template>
    </alerts>
    <alerts>
        <fullName>Exam_pass_notification_single_exam_printable_license</fullName>
        <description>Exam pass notification - single exam - printable license</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Sent_To__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Exam_pass_notification_single_exam_printable_license_final</template>
    </alerts>
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
        <fullName>Email - Exam approval email - Appraiser</fullName>
        <actions>
            <name>Exam_approval_email_Appraiser</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Exam_approval_email_Appraiser</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Type__c</field>
            <operation>equals</operation>
            <value>Certified General,Certified Residential,State Licensed Appraiser Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Results Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Automation rule for email notification: Exam approval email - Appraiser</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Exam approval email - RBS</fullName>
        <actions>
            <name>Exam_approval_email_RBS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Exam_approval_email_RBS</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Results Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Type__c</field>
            <operation>notContain</operation>
            <value>Certified General,Certified Residential,State Licensed Appraiser Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Automation rule for email notification: Exam approval email - RBS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Exam fail notification - Geologist</fullName>
        <actions>
            <name>Exam_fail_notification_Geologist</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3 )AND 4</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.License_Type__c</field>
            <operation>equals</operation>
            <value>Geologist</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.License_Type__c</field>
            <operation>equals</operation>
            <value>Geologist In Training</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Fail</value>
        </criteriaItems>
        <description>Automation rule for email notification: Exam fail notification - Geologist</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Exam pass notification - FG exam</fullName>
        <actions>
            <name>Exam_pass_notification_FG_exam</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Education_History__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Application_Type__c</field>
            <operation>equals</operation>
            <value>Geologist</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Type__c</field>
            <operation>equals</operation>
            <value>Fundamentals of Geology</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Automation rule for email notification: Exam pass notification - FG exam</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Exam pass notification - Law Review</fullName>
        <actions>
            <name>Exam_pass_notification_Law_Review</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Exam_pass_notification_Law_Review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Type__c</field>
            <operation>equals</operation>
            <value>Architecture Law Review,Embalmer - State Law Review Exam,Engineering Law Review Exam,Landscape Law Review,Land Surveyor Law Review Exam,Funeral Director - State Law Review Exam,On-Site Designer State Law Review Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Automation rule for email notification: Exam pass notification - Law Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Exam pass notification - single exam - printable license</fullName>
        <actions>
            <name>Exam_pass_notification_single_exam_printable_license</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Outbound_Email_Exam_pass_notification_single_exam_printable_license</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Education_History__c.Status__c</field>
            <operation>equals</operation>
            <value>Pass</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.Exam_Type__c</field>
            <operation>equals</operation>
            <value>On-Site Designer License Exam</value>
        </criteriaItems>
        <criteriaItems>
            <field>Education_History__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
    <tasks>
        <fullName>Email_Outbound_Exam_approval_email_Appraiser</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Education_History__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Exam approval email - Appraiser</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Exam_approval_email_RBS</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Education_History__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Exam approval email - RBS</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Exam_pass_notification_Law_Review</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Education_History__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Exam pass notification - Law Review</subject>
    </tasks>
    <tasks>
        <fullName>Outbound_Email_Exam_pass_notification_single_exam_printable_license</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Education_History__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Outbound Email: Exam pass notification - single exam - printable license</subject>
    </tasks>
</Workflow>
