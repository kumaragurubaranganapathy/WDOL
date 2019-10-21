<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Admin_accept_business</fullName>
        <description>Account Admin accept - business</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_accept_business_final</template>
    </alerts>
    <alerts>
        <fullName>Account_Admin_accept_contact</fullName>
        <description>Account Admin accept - contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_accept_contact_final</template>
    </alerts>
    <alerts>
        <fullName>Account_Admin_decline_business</fullName>
        <description>Account Admin decline - business</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_decline_business_final</template>
    </alerts>
    <alerts>
        <fullName>Account_Admin_decline_contact</fullName>
        <description>Account Admin decline - contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_decline_contact_final</template>
    </alerts>
    <alerts>
        <fullName>Account_Admin_invitation_notification_contact</fullName>
        <description>Account Admin invitation notification - contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_invitation_notification_contact_final</template>
    </alerts>
    <fieldUpdates>
        <fullName>update_status_on_No_Response</fullName>
        <description>update status when  no response is received  from contact</description>
        <field>Status__c</field>
        <literalValue>No Response</literalValue>
        <name>update status on No Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email - Account Admin accept</fullName>
        <actions>
            <name>Account_Admin_accept_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Admin_accept_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Account_Admin_accept</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Role__c</field>
            <operation>equals</operation>
            <value>Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Account Admin decline</fullName>
        <actions>
            <name>Account_Admin_decline_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Admin_decline_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Account_Admin_decline</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Role__c</field>
            <operation>equals</operation>
            <value>Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Account Admin invitation notification</fullName>
        <actions>
            <name>Account_Admin_invitation_notification_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Account_Admin_invitation_notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Role__c</field>
            <operation>equals</operation>
            <value>Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>update_status_on_No_Response</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>MUSW__Account_Contact__c.invitation_send_date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Email_Outbound_Account_Admin_accept</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>MUSW__Account_Contact__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Account Admin accept</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Account_Admin_decline</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>MUSW__Account_Contact__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Account Admin decline</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Account_Admin_invitation_notification</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>MUSW__Account_Contact__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Account Admin invitation notification</subject>
    </tasks>
</Workflow>
