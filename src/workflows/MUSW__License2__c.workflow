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
    <fieldUpdates>
        <fullName>Pre_Licensure_Number_populate</fullName>
        <field>Pre_License_Number__c</field>
        <formula>Name</formula>
        <name>Pre-Licensure Number populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MUSW_Expiration_Date_to_current_date</fullName>
        <field>MUSW__Expiration_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Expiration Date to current date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Owner_to_Appraisal_Management</fullName>
        <description>Queue Assignment for Appraisal Management Company</description>
        <field>OwnerId</field>
        <lookupValue>Appraisal_Management_Company_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update the Owner to Appraisal Management</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
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
    <rules>
        <fullName>Populate Pre Licensure Number</fullName>
        <actions>
            <name>Pre_Licensure_Number_populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Generate Fee</value>
        </criteriaItems>
        <description>Populates the Pre-Licensure Number field on License, the moment License is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Queue Assignment for Appraisal Management Company</fullName>
        <actions>
            <name>Update_the_Owner_to_Appraisal_Management</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.Credential_Type__c</field>
            <operation>equals</operation>
            <value>Appraisal Management Company</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Queue Assignment for Appraisal Management Company</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Expiration Date to current date when license is sunset</fullName>
        <actions>
            <name>Set_MUSW_Expiration_Date_to_current_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Sunset</value>
        </criteriaItems>
        <description>set Expiration Date to current date when license is sunset</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
