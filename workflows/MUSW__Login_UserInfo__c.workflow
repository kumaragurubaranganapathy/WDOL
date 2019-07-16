<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MUSW__Login_New_User_Created</fullName>
        <description>Login - New User Created</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>MUSW__System_Templates/MUSW__Login_New_User_Created</template>
    </alerts>
    <rules>
        <fullName>MUSW__Login %E2%80%93 New User Created</fullName>
        <actions>
            <name>MUSW__Login_New_User_Created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>MUSW__Login_UserInfo__c.MUSW__Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
