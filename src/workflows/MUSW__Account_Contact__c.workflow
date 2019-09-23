<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Admin_accept_business</fullName>
        <description>Account Admin accept - business</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
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
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Account_Admin_invitation_notification_contact_final</template>
    </alerts>
</Workflow>
