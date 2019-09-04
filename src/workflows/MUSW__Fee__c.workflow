<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>send_payment_reminder</fullName>
        <description>send payment reminder</description>
        <protected>false</protected>
        <recipients>
            <recipient>abhilassharma@deloitte.wadolbuspro</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Fee_Past_Due_Payment_Notice</template>
    </alerts>
    <fieldUpdates>
        <fullName>FeeAmountSet</fullName>
        <field>MUSW__Amount__c</field>
        <formula>MUSW__Quantity__c * MUSW__Price_Per_Unit__c</formula>
        <name>Fee Amount - Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FeePricePerUnitSetFlex</fullName>
        <field>MUSW__Price_Per_Unit__c</field>
        <formula>CASE(MUSW__Type__c,
&quot;Hourly Inspections&quot;, 45,
&quot;Overtime Inspections&quot;, 60,
&quot;Additional Plan Check&quot;, 45,
MUSW__Price_Per_Unit__c)</formula>
        <name>Fee Price Per Unit - Set (Flex)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Fee_Paid_DateTime_unset</fullName>
        <field>MUSW__Fee_Paid_Date__c</field>
        <name>Fee Paid DateTime unset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Fee_Paid_Date_unset</fullName>
        <field>MUSW__Fee_Paid_Date2__c</field>
        <name>Fee Paid Date unset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Paid_in_Full_check</fullName>
        <field>MUSW__Fee_Paid__c</field>
        <literalValue>1</literalValue>
        <name>Paid in Full check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MUSW__Paid_in_Full_uncheck</fullName>
        <field>MUSW__Fee_Paid__c</field>
        <literalValue>0</literalValue>
        <name>Paid in Full uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MUSW__Blank Flat Fee Amount</fullName>
        <active>false</active>
        <booleanFilter>(1 OR 2) and 3</booleanFilter>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Amount__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Amount__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Fee_Paid__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Calculate/Default the Fee Amount based on the Fee Type when the Amount is not specified or is zero</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Paid in Full check</fullName>
        <actions>
            <name>MUSW__Paid_in_Full_check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Outstanding_Fee__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Amount__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MUSW__Paid in Full uncheck</fullName>
        <actions>
            <name>MUSW__Fee_Paid_DateTime_unset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MUSW__Fee_Paid_Date_unset</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MUSW__Paid_in_Full_uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>MUSW__Fee__c.MUSW__Outstanding_Fee__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
