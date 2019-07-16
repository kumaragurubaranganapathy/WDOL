<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Inspection_CloseInspection_true</fullName>
        <field>Close_Inspection__c</field>
        <literalValue>1</literalValue>
        <name>Inspection - CloseInspection = true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inspection_Fill_Latitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Latitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Latitude__s</formula>
        <name>Inspection - Fill Latitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inspection_Fill_Longitude_from_Parcel</fullName>
        <field>MUSW__Geolocation__Longitude__s</field>
        <formula>MUSW__Parcel__r.MUSW__Geolocation__Longitude__s</formula>
        <name>Inspection - Fill Longitude from Parcel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inspection_Increment_Count</fullName>
        <field>Reinspection_Count__c</field>
        <formula>IF (ISBLANK(MUSW__Previous_Inspection__c), 1,MUSW__Previous_Inspection__r.Reinspection_Count__c + 1)</formula>
        <name>Inspection - Increment Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inspection_Requested_Status_Requested</fullName>
        <field>MUSW__Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Inspection Requested - Status= Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inspection_fill_completed_date</fullName>
        <field>MUSW__Completed_Date__c</field>
        <formula>Today()</formula>
        <name>Inspection - fill completed date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Inspection - Set Reinspection count</fullName>
        <actions>
            <name>Inspection_Increment_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Inspection__c.MUSW__Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inspection - closed</fullName>
        <actions>
            <name>Inspection_CloseInspection_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Inspection_fill_completed_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>MUSW__Inspection__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Inspection__c.MUSW__Status__c</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Inspection__c.Close_Inspection__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inspection Parcel filled  - Geolocation blank</fullName>
        <actions>
            <name>Inspection_Fill_Latitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Inspection_Fill_Longitude_from_Parcel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a inspection&apos;s parcel lookup is filled and the Lat Long is blank the Lat Long fields should populate from the parcel.</description>
        <formula>NOT(ISBLANK(MUSW__Parcel__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inspection Requested - Field Updates</fullName>
        <actions>
            <name>Inspection_Requested_Status_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Inspection__c.Requested_DateTime__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Inspection__c.MUSW__Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
