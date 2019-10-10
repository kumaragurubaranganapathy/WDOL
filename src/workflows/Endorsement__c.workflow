<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_notification_supervisor</fullName>
        <description>Approval notification - supervisor</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Approval_notification_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Electronic_Notary_software_provider_reminder_after_issuance</fullName>
        <description>Electronic Notary software provider reminder - after issuance</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Electronic_Notary_software_provider_reminder_after_issuance_final</template>
    </alerts>
    <alerts>
        <fullName>Electronic_Notary_software_provider_reminder_submission</fullName>
        <description>Electronic Notary software provider reminder - submission</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Electronic_Notary_software_provider_reminder_submission_final</template>
    </alerts>
    <alerts>
        <fullName>Endorsement_add_approval</fullName>
        <description>Endorsement add - approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Endorsement_add_approval_final</template>
    </alerts>
    <alerts>
        <fullName>Endorsement_add_review</fullName>
        <description>Endorsement add - review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Endorsement_add_review_final</template>
    </alerts>
    <alerts>
        <fullName>Endorsement_remove_request</fullName>
        <description>Endorsement remove - request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>dolisdpolarisnonprod@dol.wa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Endorsement_remove_request_final</template>
    </alerts>
    <rules>
        <fullName>Email - Approval notification - supervisor</fullName>
        <actions>
            <name>Approval_notification_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Approval_notification_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>equals</operation>
            <value>Supervisor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Electronic Notary software provider reminder - after issuance</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>equals</operation>
            <value>Electronic Records Notary Public Endorsement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Is_Record_Exists__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Electronic_Notary_software_provider_reminder_after_issuance</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Email_Outbound_Electronic_Notary_software_provider_reminder_after_issuance</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Endorsement__c.Date_Requested_for_Adding_Endorsement__c</offsetFromField>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email - Electronic Notary software provider reminder - submission</fullName>
        <actions>
            <name>Electronic_Notary_software_provider_reminder_submission</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Electronic_Notary_software_provider_reminder_submission</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>equals</operation>
            <value>Electronic Records Notary Public Endorsement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Is_Record_Exists__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Date_Requested_for_Adding_Endorsement__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Endorsement add - approval</fullName>
        <actions>
            <name>Endorsement_add_approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Endorsement_add_approval</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>notContain</operation>
            <value>Supervisor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Email - Endorsement add - approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Endorsement add - review</fullName>
        <actions>
            <name>Endorsement_add_review</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Endorsement_add_review</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>In-Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Endorsement remove - request</fullName>
        <actions>
            <name>Endorsement_remove_request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Endorsement_remove_request</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Remove</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Email_Outbound_Approval_notification_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Approval notification - supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Electronic_Notary_software_provider_reminder_after_issuance</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Electronic Notary software provider reminder - after issuance</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Electronic_Notary_software_provider_reminder_submission</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Electronic Notary software provider reminder - submission</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Endorsement_add_approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Endorsement add - approval</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Endorsement_add_review</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Endorsement add - review</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Endorsement_remove_request</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Endorsement__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Endorsement remove - request</subject>
    </tasks>
</Workflow>
