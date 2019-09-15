<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Application_Submitted_Alert</fullName>
        <description>Application Submitted Alert</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Client_Approved_Built/Application_submission_final</template>
    </alerts>
    <alerts>
        <fullName>License_Email_Alert</fullName>
        <description>License Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Payment_For_License</template>
    </alerts>
	<alerts>
        <fullName>Payment_for_License_Fee_two_step</fullName>
        <description>Payment for License Fee - two step</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Client_Approved_Finance/First_License_Fee</template>
    </alerts>
    <alerts>
        <fullName>Polaris_License_Expiration_Notice</fullName>
        <description>Polaris - License Expiration Notice</description>
        <protected>false</protected>
        <recipients>
            <field>MUSW__Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Polaris_120_days_Renewal_Notice</template>
    </alerts>
    <fieldUpdates>
        <fullName>Inactivate_License_on_expiration</fullName>
        <description>Inactivate License on expiration date &lt; today</description>
        <field>MUSW__Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Inactivate License on expiration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
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
    <fieldUpdates>
        <fullName>Update_the_Owner_to_RBS_Queue</fullName>
        <description>Queue Assignment for Architect and Funeral Establishment</description>
        <field>OwnerId</field>
        <lookupValue>RBS_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update the Owner to RBS Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Owner_to_Real_Estate_Appraise</fullName>
        <description>Queue Assignment for Certified General Appraiser</description>
        <field>OwnerId</field>
        <lookupValue>Appraiser_Trainee_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update the Owner to Real Estate Appraise</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Inactivate License on expiration</fullName>
        <actions>
            <name>Inactivate_License_on_expiration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Inactivate License on expiration date &lt; today</description>
        <formula>MUSW__Expiration_Date__c &lt;  TODAY() &amp;&amp; $User.Bypass_Validation_Workflow_Rules__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
        <fullName>Payment Notification for License Fee</fullName>
        <actions>
            <name>Payment_for_License_Fee_two_step</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Pending License Fee</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Total_Balance__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__License2__c.Credential_Type__c</field>
            <operation>contains</operation>
            <value>Architect,Landscape Architect</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__License2__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
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
            <field>MUSW__License2__c.Name</field>
            <operation>notEqual</operation>
            <value>null</value>
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
        <description>Queue Assignment for Appraisal Management Company</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Queue Assignment for Architect and Funeral Establishment</fullName>
        <actions>
            <name>Update_the_Owner_to_RBS_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.Credential_Type__c</field>
            <operation>equals</operation>
            <value>Architect,Funeral Establishment</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__License2__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>In Review</value>
        </criteriaItems>
        <description>Queue Assignment for Architect and Funeral Establishment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Queue Assignment for Certified General Appraiser</fullName>
        <actions>
            <name>Update_the_Owner_to_Real_Estate_Appraise</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License2__c.Credential_Type__c</field>
            <operation>equals</operation>
            <value>Certified General Appraiser</value>
        </criteriaItems>
        <description>Queue Assignment for Certified General Appraiser</description>
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
