<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <!--<alerts>
        <fullName>Endorsement_add_approval</fullName>
        <description>Endorsement add - approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Endorsement_remove_request_final</template>
    </alerts>
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
            <operation>notEqual</operation>
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
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>In-Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>notEqual</operation>
            <value>Supervisor</value>
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
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Remove</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.Endorsement_Type__c</field>
            <operation>notEqual</operation>
            <value>Supervisor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Endorsement__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
    </tasks> -->
</Workflow>
