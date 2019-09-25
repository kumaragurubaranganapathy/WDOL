<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Application_Fill_Latitude_from_Parcel</fullName>
        <field>Geolocation__Latitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Latitude__s</formula>
        <name>Application - Fill Latitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Fill_Longitude_from_Parcel</fullName>
        <field>Geolocation__Longitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Longitude__s</formula>
        <name>Application - Fill Longitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_UpdateIsAbandoned</fullName>
        <field>Is_Abandoned__c</field>
        <literalValue>1</literalValue>
        <name>Application_UpdateIsAbandoned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Application Parcel filled  - Geolocation blank</fullName>
        <actions>
            <name>Application_Fill_Latitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Application_Fill_Longitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a application&apos;s parcel lookup is filled and the Lat Long is blank the Lat Long fields should populate from the parcel.</description>
        <formula>NOT(ISBLANK(MUSW__Parcel__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
