<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_license_parcel_address</fullName>
        <description>This field is used to  add the address in the letter templates</description>
        <field>License_Parcel_Address__c</field>
        <formula>MUSW__Parcel__r.Name + BR() +
MUSW__Parcel__r.MUSW__City__c + &apos; &apos; + TEXT(MUSW__Parcel__r.MUSW__State__c) + &apos; &apos; + MUSW__Parcel__r.MUSW__Post_Zip_Code__c</formula>
        <name>Update license parcel address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update  address in US Format</fullName>
        <actions>
            <name>Update_license_parcel_address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__License_Parcel__c.Parcel_Address__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
