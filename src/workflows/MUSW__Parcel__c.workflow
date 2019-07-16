<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MUSW__Parcel_Primary_Contact_Name_Set</fullName>
        <field>MUSW__Primary_Contact_Name__c</field>
        <formula>if(MUSW__Primary_Contact__r.FirstName != &quot;&quot;,MUSW__Primary_Contact__r.FirstName+ &quot; &quot;,&quot;&quot;) + MUSW__Primary_Contact__r.LastName</formula>
        <name>Parcel Primary Contact Name Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ParcelCityDefault</fullName>
        <field>MUSW__City__c</field>
        <formula>&quot;&quot;</formula>
        <name>Parcel City - Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ParcelPostZipCodeDefault</fullName>
        <field>MUSW__Post_Zip_Code__c</field>
        <formula>&quot;&quot;</formula>
        <name>Parcel Post Zip Code - Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MUSW__Blank Parcel City %26 Zip</fullName>
        <active>false</active>
        <criteriaItems>
            <field>MUSW__Parcel__c.MUSW__City__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Parcel__c.MUSW__Post_Zip_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Default City &amp; Zip if both are blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Parcel Primary Contact not blank</fullName>
        <actions>
            <name>MUSW__Parcel_Primary_Contact_Name_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(MUSW__Primary_Contact__c != null, MUSW__Primary_Contact_Name__c == null),ISCHANGED(MUSW__Primary_Contact__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
