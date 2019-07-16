<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>MUSW__Blank Complaint City %26 Zip</fullName>
        <active>true</active>
        <description>Default the City &amp; Zip when both are blank</description>
        <formula>AND(ISNULL(MUSW__Parcel__c ),  ISNULL(MUSW__City__c ),ISNULL( MUSW__Post_Zip_Code__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
