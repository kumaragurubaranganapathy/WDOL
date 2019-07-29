<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OwnerChange_Real_Estate_Appraiser_Course</fullName>
        <field>OwnerId</field>
        <lookupValue>Real_Estate_Appraiser_Courses_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>OwnerChange Real Estate Appraiser Course</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Appraisal_Management_Comp</fullName>
        <field>OwnerId</field>
        <lookupValue>Appraisal_Management_Company_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Appraisal Management Comp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Camping_Resorts</fullName>
        <field>OwnerId</field>
        <lookupValue>Camping_Resorts_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Camping Resorts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Notaries</fullName>
        <field>OwnerId</field>
        <lookupValue>Notaries_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Notaries</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_RBS_Licenses</fullName>
        <field>OwnerId</field>
        <lookupValue>RBS_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change RBS Licenses</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Real_Estate_Appraisers</fullName>
        <field>OwnerId</field>
        <lookupValue>Real_Estate_Appraisers_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Real Estate Appraisers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change_Timeshare</fullName>
        <field>OwnerId</field>
        <lookupValue>Timeshare_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Owner Change Timeshare</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Appraisal Management Company Queue Assignment</fullName>
        <actions>
            <name>Owner_Change_Appraisal_Management_Comp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  License__c != NULL,  OR( ISPICKVAL(License__r.Credential_Type__c, &apos;Appraisal Management Company&apos;),  ISPICKVAL(License__r.Credential_Type__c, &apos;Appraisal Controlling Person&apos;))	 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Camping Resorts Queue Assignment</fullName>
        <actions>
            <name>Owner_Change_Camping_Resorts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  License__c != NULL,  OR( ISPICKVAL(License__r.Credential_Type__c, &apos;Camping Resort Company&apos;),  ISPICKVAL(License__r.Credential_Type__c, &apos;Camping Resort Salesperson&apos;))	 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notary Queue assignment</fullName>
        <actions>
            <name>Owner_Change_Notaries</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  License__c != NULL,  ISPICKVAL(License__r.Credential_Type__c, &apos;Notary Public&apos;)	 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RBS Queue Assignment</fullName>
        <actions>
            <name>Owner_Change_RBS_Licenses</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  License__c != NULL,  OR(  			 ISPICKVAL(License__r.Credential_Type__c, &apos;Funeral Director&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Embalmer&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Embalmer Intern&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Funeral Director Intern&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Funeral Establishment&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Prearrangement Funeral Services&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Funeral Establishment Branch&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Certificate of Removal Registration&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Academic Intern&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Crematory&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Cremated Remains Disposition Permit&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Cemetery&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Engineer in Training&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Professional Engineer&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Land Surveyor in Training&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Professional Land Surveyor&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;On-site Wastewater Designer&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;On-site Wastewater Inspector&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Geologist in Training&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Geologist&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Architect&apos;), 				ISPICKVAL(License__r.Credential_Type__c, &apos;Landscape Architect&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Real Estate Appraiser Courses Queue Assignment</fullName>
        <actions>
            <name>OwnerChange_Real_Estate_Appraiser_Course</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  License__c != NULL,  ISPICKVAL(License__r.Credential_Type__c, &apos;Appraiser Course&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Real Estate Appraisers Queue Assignment</fullName>
        <actions>
            <name>Owner_Change_Real_Estate_Appraisers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 
License__c != NULL, 
OR( 
ISPICKVAL(License__r.Credential_Type__c, &apos;Registered Appraiser Trainee&apos;), 
ISPICKVAL(License__r.Credential_Type__c, &apos;Certified General Appraiser&apos;),	
ISPICKVAL(License__r.Credential_Type__c, &apos;Appraiser Trainee&apos;),	
ISPICKVAL(License__r.Credential_Type__c, &apos;State Licensed Appraiser&apos;), 
ISPICKVAL(License__r.Credential_Type__c, &apos;Certified Residential Appraiser&apos;), 
ISPICKVAL(License__r.Credential_Type__c, &apos;Temporary Appraisal Permit&apos;), 
ISPICKVAL(License__r.Credential_Type__c, &apos;Temporary Certified General&apos;), 
ISPICKVAL(License__r.Credential_Type__c, &apos;Temporary Certified Residential&apos;),
ISPICKVAL(License__r.Credential_Type__c, &apos;Temporary State Licensed&apos;) 

) 
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Timeshare Queue assignment</fullName>
        <actions>
            <name>Owner_Change_Timeshare</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  License__c != NULL,  OR( ISPICKVAL(License__r.Credential_Type__c, &apos;Timeshare Company&apos;),  ISPICKVAL(License__r.Credential_Type__c, &apos;Timeshare Salesperson&apos;))	 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
