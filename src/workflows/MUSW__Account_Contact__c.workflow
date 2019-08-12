<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Accept_inviation</fullName>
        <description>Accept inviation</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Washington/Accept_invitation</template>
    </alerts>
    <alerts>
        <fullName>Notify</fullName>
        <description>Notify Controling Person for registration</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Washington/Notify_Controling_person_to_register</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_About_Acceptance_of_Account_Admin</fullName>
        <description>Send Email About Acceptance of Account Admin to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Account_Admin_decline_contact_final</template>
    </alerts>
    <alerts>
        <fullName>Send_invitation_on_contact_addition</fullName>
        <description>Send invitation on contact addition</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>niinani@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Department_of_Licensing_Pending_request_to_join_a_firm</template>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <fullName>Notify sender and receiver of Account Admin</fullName>
        <actions>
            <name>WA_Email_Alert_to_accept_invitation_to_join_firm</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
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
        <description>Notify sender and receiver of  Account Admin</description>
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
    <rules>
        <fullName>Notify the Controling person of Account to register</fullName>
        <actions>
            <name>Notify</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Role__c</field>
            <operation>equals</operation>
            <value>Controlling person</value>
        </criteriaItems>
        <description>Notify the Controling person of Account to register.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
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
