<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DSPS_Tax_Contact_grace_period</fullName>
        <description>DSPS Tax Contact grace period</description>
        <protected>false</protected>
        <recipients>
            <recipient>System_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Contact_Grace_Period</template>
    </alerts>
    <alerts>
        <fullName>DSPS_Tax_delinquency_Contact_Active</fullName>
        <description>DSPS Tax delinquency Contact Active</description>
        <protected>false</protected>
        <recipients>
            <recipient>System_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Contact_Active</template>
    </alerts>
    <alerts>
        <fullName>DSPS_Tax_delinquency_Contact_OnHold</fullName>
        <description>DSPS Tax delinquency Contact OnHold</description>
        <protected>false</protected>
        <recipients>
            <recipient>System_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>vagoel@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Contact_On_Hold</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Status_Update_to_Inactive</fullName>
        <description>Update Contact Status to Inactive when the Deceased Date is populated.</description>
        <field>Contact_Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>Contact Status Update to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Update_Record_Type_on_Create</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Contact - Update Record Type on Create</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__ContactSFIDset</fullName>
        <field>MUSW__SFId__c</field>
        <formula>Id</formula>
        <name>Contact SFID set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SecurityCode</fullName>
        <field>Security_Code__c</field>
        <formula>Right(Id, 5)</formula>
        <name>Set SecurityCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Email</fullName>
        <description>Update email to default for deceased contact</description>
        <field>Email</field>
        <formula>IF( Email == &apos;&apos; &amp;&amp;  ISNULL(Deceased_Date__c) = FALSE , &apos;inactive@Wi.gov&apos;, Email)</formula>
        <name>Update Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact - Update page layout on create</fullName>
        <actions>
            <name>Contact_Update_Record_Type_on_Create</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact Grace Period</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Contact_Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Certificate_Mailed_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>DSPS Tax delinquency grace period</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DSPS_Tax_Contact_grace_period</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.Certificate_Mailed_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MUSW__Contact SFID field is blank</fullName>
        <actions>
            <name>MUSW__ContactSFIDset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.MUSW__SFId__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set SecurityCode</fullName>
        <actions>
            <name>Set_SecurityCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Security_Code__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Contact_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User.Bypass_Validation_Workflow_Rules__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
