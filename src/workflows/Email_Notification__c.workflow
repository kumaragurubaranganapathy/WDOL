<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_Notification</fullName>
        <description>Send Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Recipient_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Send_Email_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_for_business_security_code</fullName>
        <description>Send Email for Business security code</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Security_Code_Email_Business_path</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_for_security_code</fullName>
        <description>Send Email for security code</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Security_Code_Email</template>
    </alerts>
    <alerts>
        <fullName>User_Upgrade_Notification</fullName>
        <description>User Upgrade Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/User_Upgrade_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Sent_Email_field</fullName>
        <description>Update Sent Email field</description>
        <field>Email_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Sent Email field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Business Security Code</fullName>
        <actions>
            <name>Send_Email_for_business_security_code</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Email_Notification__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Email_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Send Business Security Code</value>
        </criteriaItems>
        <description>Email the Business security code</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Security Code</fullName>
        <actions>
            <name>Send_Email_for_security_code</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Email_Notification__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Email_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Send Individual Security Code</value>
        </criteriaItems>
        <description>Email the forgot security code</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Reminder</fullName>
        <actions>
            <name>Send_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Sent_Email_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Email_Notification__c.Body__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Email_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>Raw HTML Body</value>
        </criteriaItems>
        <criteriaItems>
            <field>Email_Notification__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send Email Reminder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Upgrade User Notification</fullName>
        <actions>
            <name>User_Upgrade_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Email_Notification__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Email_Notification__c.Type__c</field>
            <operation>equals</operation>
            <value>User Upgrade</value>
        </criteriaItems>
        <description>Notify user when the profile is upgraded to community plus user</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
