<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
        <fullName>Send_Email_About_Acceptance</fullName>
        <description>Send Email About Acceptance</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sisinkar@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Templates_Relationships/Licensee_accept_licensee</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_About_Declination</fullName>
        <description>Send Email About Declination</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Templates_Relationships/Licensee_decline_licensee</template>
    </alerts>
    <alerts>
        <fullName>WA_Email_Alert_that_inivitation_is_sent</fullName>
        <description>WA Email Alert that inivitation is sent</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Washington/Dept_of_Licensing_Request_Sent_to_join_your_firm</template>
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
        <template>Washington/Dept_of_licensing_pending_request_to_join_firm</template>
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
        <fullName>Notify sender and receiver of Affiliation</fullName>
        <actions>
            <name>WA_Email_Alert_that_inivitation_is_sent</name>
            <type>Alert</type>
        </actions>
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
            <operation>notEqual</operation>
            <value>Controlling person</value>
        </criteriaItems>
        <description>Notify sender and receiver of  Affiliation</description>
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
        <active>true</active>
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
        <fullName>Send email about acceptance of contact</fullName>
        <actions>
            <name>Send_Email_About_Acceptance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Account_Contact__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
