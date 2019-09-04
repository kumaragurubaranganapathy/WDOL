<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Complaint_Fill_City_from_Parcel</fullName>
        <description>Fills in City from Parcel City field.</description>
        <field>MUSW__City__c</field>
        <formula>MUSW__Parcel__r.MUSW__City__c</formula>
        <name>Complaint - Fill City from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Fill_Latitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Latitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Latitude__s</formula>
        <name>Complaint - Fill Latitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Fill_Longitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Longitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Longitude__s</formula>
        <name>Complaint - Fill Longitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Fill_Postal_Code_from_Parcel</fullName>
        <field>MUSW__Zip__c</field>
        <formula>MUSW__Parcel__r.MUSW__Post_Zip_Code__c</formula>
        <name>Complaint - Fill Postal Code from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Complaint_Fill_Street_from_parcel</fullName>
        <description>Fills in Street from Parcel Address (MUSW__Street__c) field.</description>
        <field>MUSW__Street__c</field>
        <formula>MUSW__Parcel__r.MUSW__Street__c</formula>
        <name>Complaint  - Fill Street from parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Complain Parcel filled  - Geolocation blank</fullName>
        <actions>
            <name>Complaint_Fill_Latitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Complaint_Fill_Longitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When a complaint&apos;s parcel lookup is filled and the Lat Long is blank the Lat Long fields should populate from the parcel.</description>
        <formula>AND(not(isblank(MUSW__Parcel__c)),isblank(  MUSW__Geolocation__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Complain Parcel filled  - street blank</fullName>
        <actions>
            <name>Complaint_Fill_City_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Complaint_Fill_Postal_Code_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Complaint_Fill_Street_from_parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a complaint&apos;s parcel lookup is filled the address fields from that parcel should populate the complaint address field.  Lat Long fields are managed in a separate workflow Complaints may be entered at a geo point and may not inherit the parcel geocode</description>
        <formula>AND(not(isblank(MUSW__Parcel__c)),isblank( MUSW__Street__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
