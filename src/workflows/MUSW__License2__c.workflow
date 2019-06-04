<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_Submitted_Alert</fullName>
        <description>Application Submitted Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>niinani@deloitte.com.wadolbuspro.prod</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Application_Submitted</template>
    </alerts>
    <alerts>
        <fullName>License_Email_Alert</fullName>
        <ccEmails>nazbegum@deloitte.com</ccEmails>
        <description>License Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Payment_For_License</template>
    </alerts>
    <alerts>
        <fullName>Polaris_License_Expiration_Notice</fullName>
        <ccEmails>kkakariya@deloitte.com</ccEmails>
        <description>Polaris - License Expiration Notice</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Polaris_120_days_Renewal_Notice</template>
    </alerts>
</Workflow>
