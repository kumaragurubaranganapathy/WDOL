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
    <fieldUpdates>
        <fullName>License_Fill_Latitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Latitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Latitude__s</formula>
        <name>License - Fill Latitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>License_Fill_Longitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Longitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Longitude__s</formula>
        <name>License - Fill Longitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>License Parcel filled  - Geolocation blank</fullName>
        <actions>
            <name>License_Fill_Latitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>License_Fill_Longitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a license&apos;s parcel lookup is filled and the Lat Long is blank the Lat Long fields should populate from the parcel.</description>
        <formula>NOT(ISBLANK(MUSW__Parcel__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
