<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email</fullName>
        <description>Email Endorsement Add Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Client_Approved_Built/Endorsement_add_approval_final</template>
    </alerts>
    <alerts>
        <fullName>Email_Endorsement_add_review</fullName>
        <description>Email Endorsement add - review</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Client_Approved_Built/Endorsement_add_review_final</template>
    </alerts>
    <alerts>
        <fullName>Email_Endorsement_remove_request</fullName>
        <description>Email Endorsement remove - request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Client_Approved_Built/Endorsement_remove_request_final</template>
    </alerts>
    <rules>
        <fullName>Email Endorsement add - approval</fullName>
        <actions>
            <name>Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>email Endorsement add - approval</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Endorsement add - review</fullName>
        <actions>
            <name>Email_Endorsement_add_review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>In-Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Endorsement Remove - Request</fullName>
        <actions>
            <name>Email_Endorsement_remove_request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Endorsement__c.Status__c</field>
            <operation>equals</operation>
            <value>Remove</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
