<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_About_Acceptance_of_Account_Admin</fullName>
        <description>Send Email About Acceptance of Account Admin to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_accept_contact_final</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_About_Declination_of_Account_Admin_to_contact</fullName>
        <description>Send Email About Declination of Account Admin to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_decline_contact_final</template>
    </alerts>
    <alerts>
        <fullName>WA_Email_Alert_to_accept_invitation_to_join_firm</fullName>
        <description>WA Email Alert to accept invitation to join firm</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_invitation_notification_contact_final</template>
    </alerts>
    <alerts>
        <fullName>WA_Email_Alert_to_business_about_declination_of_Account_Admin</fullName>
        <description>WA Email Alert to business about declination of Account Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_decline_business_final</template>
    </alerts>
    <alerts>
        <fullName>WA_Email_alert_to_business_about_acceptance_of_Account_Admin</fullName>
        <description>WA Email alert to business about acceptance of Account Admin</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_accept_business_final</template>
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
        <fullName>Send Email About  Declination of Account Admin</fullName>
        <actions>
            <name>Send_Email_About_Declination_of_Account_Admin_to_contact</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WA_Email_Alert_to_business_about_declination_of_Account_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send email about acceptance of Account Admin</fullName>
        <actions>
            <name>Send_Email_About_Acceptance_of_Account_Admin</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WA_Email_alert_to_business_about_acceptance_of_Account_Admin</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
            <field>MUSW__Account_Contact__c.invitation_send_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
