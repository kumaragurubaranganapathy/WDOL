<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MUSW__DefaultCityPermit</fullName>
        <description>Sample Only</description>
        <field>MUSW__Job_Location_City__c</field>
        <formula>&quot;Your City Name&quot;</formula>
        <name>Default City - Permit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__DefaultPostalZipCodePermit</fullName>
        <description>Sample Only</description>
        <field>MUSW__Job_Location_Post_Zip_Code__c</field>
        <formula>&quot;12345&quot;</formula>
        <name>Default Postal/Zip Code - Permit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MUSW__Blank Permit City %26 Zip</fullName>
        <active>false</active>
        <description>Default City and Postal Code when City and Zip are blank</description>
        <formula>AND(ISNULL(MUSW__Parcel__c ), ISNULL( MUSW__Job_Location_City__c  ),ISNULL(  MUSW__Job_Location_Post_Zip_Code__c  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Permit Issued with blank Expiration Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>MUSW__Permit__c.MUSW__Issued_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Permit__c.MUSW__Expiration_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set the expiration ahead by X number of days when the permit is issued and the expiration date is not set. Have the option to set different expiries based on permit type for example in the rule actions using a formula.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
