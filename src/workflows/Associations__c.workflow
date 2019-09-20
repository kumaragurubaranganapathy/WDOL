<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
   <!-- <alerts>
        <fullName>Approval_notification_internship</fullName>
        <description>Approval notification - internship</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Approval_notification_internship_final</template>
    </alerts>-->
    <alerts>
        <fullName>Designated_person_accept_business</fullName>
        <ccEmails>satapathy.swapna@gmail.com</ccEmails>
        <description>Designated person accept - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_accept_business_final</template>
    </alerts>
    <alerts>
        <fullName>Designated_person_accept_licensee</fullName>
        <ccEmails>satapathy.swapna@gmail.com</ccEmails>
        <description>Designated person accept - licensee</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_accept_licensee_final</template>
    </alerts>
    <alerts>
        <fullName>Designated_person_decline_RBS_business</fullName>
        <description>Designated person decline - RBS business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_decline_RBS_business_final</template>
    </alerts>
    <alerts>
        <fullName>Designated_person_decline_RBS_licensee</fullName>
        <description>Designated person decline - RBS licensee</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_decline_RBS_licensee_final</template>
    </alerts>
    <alerts>
        <fullName>Designated_person_invitation_notification_business</fullName>
        <description>Designated person invitation notification - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_invitation_notification_business_final</template>
    </alerts>
    <alerts>
        <fullName>Designated_person_invitation_notification_licensee</fullName>
        <description>Designated person invitation notification - licensee</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Designated_person_invitation_notification_licensee_final</template>
    </alerts>
    <alerts>
        <fullName>Intern_accept_intern</fullName>
        <description>Intern accept - intern</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Intern_accept_intern_final</template>
    </alerts>
    <alerts>
        <fullName>Intern_decline_intern</fullName>
        <description>Intern decline - intern</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Intern_decline_intern_final</template>
    </alerts>
    <alerts>
        <fullName>Intern_removal_notification_intern</fullName>
        <description>Intern removal notification - intern</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Intern_removal_notification_intern_final</template>
    </alerts>
    <!--<alerts>
        <fullName>Intern_separation_notification_intern</fullName>
        <description>Intern separation notification - intern</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Intern_separation_notification_intern_final</template>
    </alerts> -->
    <alerts>
        <fullName>Licensee_accept_business</fullName>
        <description>Licensee accept - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_accept_business_final</template>
    </alerts>
    <!--<alerts>
        <fullName>Licensee_accept_licensee_additional_employer</fullName>
        <description>Licensee accept - licensee - additional employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_accept_licensee_additional_employer_final</template>
    </alerts>-->
    <alerts>
        <fullName>Licensee_accept_licensee_one_employer</fullName>
        <description>Licensee accept - licensee - one employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_accept_licensee_one_employer_final</template>
    </alerts>
    <!--<alerts>
        <fullName>Licensee_decline_business</fullName>
        <description>Licensee decline - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_decline_business_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_decline_licensee_no_employer</fullName>
        <description>Licensee decline - licensee - no employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_decline_licensee_no_employer_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_invitation_notification_CR_licensee_additional_business</fullName>
        <description>Licensee invitation notification - CR licensee - additional business</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_invitation_notification_CR_licensee_additional_business_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_invitation_notification_TS_licensee_additional_business</fullName>
        <description>Licensee invitation notification - TS licensee - additional business</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_invitation_notification_TS_licensee_additional_business_final</template>
    </alerts>-->
    <alerts>
        <fullName>Licensee_invitation_notification_business</fullName>
        <description>Licensee invitation notification - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_invitation_notification_business_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_invitation_notification_licensee</fullName>
        <description>Licensee invitation notification - licensee</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_invitation_notification_licensee</template>
    </alerts>
    <!--<alerts>
        <fullName>Licensee_removal_notification_business</fullName>
        <description>Licensee removal notification - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_removal_notification_business_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_removal_notification_licensee_no_employer</fullName>
        <description>Licensee removal notification - licensee - no employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>DOL_Licensing/Licensee_removal_notification_licensee_no_employer_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_removal_notification_licensee_with_employer</fullName>
        <description>Licensee removal notification - licensee - with employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_removal_notification_licensee_with_employer_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_separation_notification_business</fullName>
        <description>Licensee separation notification - business</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_separation_notification_business_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_separation_notification_licensee_no_employer</fullName>
        <description>Licensee separation notification - licensee - no employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_separation_notification_licensee_no_employer_final</template>
    </alerts>
    <alerts>
        <fullName>Licensee_separation_notification_licensee_with_employer</fullName>
        <description>Licensee separation notification - licensee - with employer</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Licensee_separation_notification_licensee_with_employer_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_accept_trainee_1st_supervisor</fullName>
        <description>Trainee accept - trainee - 1st supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_accept_trainee_1st_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_accept_trainee_additional_supervisor</fullName>
        <description>Trainee accept - trainee - additional supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_accept_trainee_additional_supervisor_final</template>
    </alerts>-->
    <alerts>
        <fullName>Trainee_decline_trainee_no_supervisor</fullName>
        <description>Trainee decline - trainee - no supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_decline_trainee_no_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_intern_accept_supervisor_sponsor</fullName>
        <description>Trainee intern accept - supervisor sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_intern_accept_supervisor_sponsor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_intern_decline_supervisor_sponsor</fullName>
        <description>Trainee intern decline - supervisor sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_Intern_decline_supervisor_sponsor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_intern_invitation_notification_supervisor_sponsor</fullName>
        <description>Trainee intern invitation notification - supervisor sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_intern_invitation_notification_supervisor_sponsor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_intern_invitation_notification_trainee_intern</fullName>
        <description>Trainee intern invitation notification - trainee intern</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_intern_invitation_notification_trainee_intern_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_intern_removal_notification_supervisor_sponsor</fullName>
        <description>Trainee intern removal notification - supervisor sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_intern_removal_notification_supervisor_sponsor_final</template>
    </alerts>
    <!--<alerts>
        <fullName>Trainee_intern_separation_notification_supervisor_sponsor</fullName>
        <description>Trainee intern separation notification - supervisor sponsor</description>
        <protected>false</protected>
        <recipients>
            <field>Parent_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_intern_separation_notification_supervisor_sponsor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_removal_notification_trainee_no_supervisor</fullName>
        <description>Trainee removal notification - trainee - no supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_removal_notification_trainee_no_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_removal_notification_trainee_with_supervisor</fullName>
        <description>Trainee removal notification - trainee - with supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_removal_notification_trainee_with_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_separation_notification_trainee_no_supervisor</fullName>
        <description>Trainee separation notification - trainee - no supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_separation_notification_trainee_no_supervisor_final</template>
    </alerts>
    <alerts>
        <fullName>Trainee_separation_notification_trainee_with_supervisor</fullName>
        <description>Trainee separation notification - trainee - with supervisor</description>
        <protected>false</protected>
        <recipients>
            <field>Child_License_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>christopherwillia@deloitte.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>DOL_Licensing/Trainee_separation_notification_trainee_with_supervisor_final</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Child_License_email</fullName>
        <field>Child_License_Email__c</field>
        <formula>Child_License__r.MUSW__Applicant__r.Email</formula>
        <name>Update Child License email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Invited_Date</fullName>
        <field>invitation_send_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Invited Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_License_Status_to_Invited</fullName>
        <field>Status__c</field>
        <literalValue>Invited</literalValue>
        <name>Update License Status to Invited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_to_No_response</fullName>
        <field>Status__c</field>
        <literalValue>No Response</literalValue>
        <name>Update status to No response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_parent_email</fullName>
        <field>Parent_License_Email__c</field>
        <formula>Parent_License__r.MUSW__Applicant__r.Email</formula>
        <name>update parent email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates> -->
    <rules>
        <fullName>Email - Designated person accept</fullName>
        <actions>
            <name>Designated_person_accept_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Designated_person_accept_licensee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Designated Architect,Designated Funeral Director,Designated Engineer,Designated Land Surveyor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <description>Send email to parent and child license holder about acceptance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Designated person decline</fullName>
        <actions>
            <name>Designated_person_decline_RBS_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Designated_person_decline_RBS_licensee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Designated Architect,Designated Funeral Director,Designated Engineer,Designated Land Surveyor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Designated person invitation notification</fullName>
        <actions>
            <name>Designated_person_invitation_notification_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Designated_person_invitation_notification_licensee</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Designated_person_invitation_notification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Designated Architect,Designated Funeral Director,Designated Engineer,Designated Land Surveyor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Intern accept - intern</fullName>
        <actions>
            <name>Intern_accept_intern</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Intern_accept_intern</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Intern decline - intern</fullName>
        <actions>
            <name>Intern_decline_intern</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Intern_decline_intern</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Intern removal notification - intern</fullName>
        <actions>
            <name>Intern_removal_notification_intern</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Intern_removal_notification_intern</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <!-- <rules>
        <fullName>Email - Intern separation notification - intern</fullName>
        <actions>
            <name>Intern_separation_notification_intern</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Intern_separation_notification_intern</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules> -->
    <rules>
        <fullName>Email - Licensee accept - business</fullName>
        <actions>
            <name>Licensee_accept_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_accept_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <!--<rules>
        <fullName>Email - Licensee accept - licensee - additional employer</fullName>
        <actions>
            <name>Licensee_accept_licensee_additional_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_accept_licensee_additional_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules> -->
    <rules>
        <fullName>Email - Licensee accept - licensee - one employer</fullName>
        <actions>
            <name>Licensee_accept_licensee_one_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_accept_licensee_one_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <!--<rules>
        <fullName>Email - Licensee decline - business</fullName>
        <actions>
            <name>Licensee_decline_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_decline_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee decline - licensee - no employer</fullName>
        <actions>
            <name>Licensee_decline_licensee_no_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_decline_licensee_no_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee invitation notification - CR licensee - additional business</fullName>
        <actions>
            <name>Licensee_invitation_notification_CR_licensee_additional_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_invitation_notification_CR_licensee_additional_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee invitation notification - TS licensee - additional business</fullName>
        <actions>
            <name>Licensee_invitation_notification_TS_licensee_additional_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_invitation_notification_TS_licensee_additional_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules> -->
    <rules>
        <fullName>Email - Licensee invitation notification - business</fullName>
        <actions>
            <name>Licensee_invitation_notification_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Invited_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_invitation_notification_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_status_to_No_response</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Associations__c.invitation_send_date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email - Licensee invitation notification - licensee</fullName>
        <actions>
            <name>Licensee_invitation_notification_licensee</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_invitation_notification_licensee</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <!--<rules>
        <fullName>Email - Licensee removal notification - business</fullName>
        <actions>
            <name>Licensee_removal_notification_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_removal_notification_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee removal notification - licensee - no employer</fullName>
        <actions>
            <name>Licensee_removal_notification_licensee_no_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_removal_notification_licensee_no_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee removal notification - licensee - with employer</fullName>
        <actions>
            <name>Licensee_removal_notification_licensee_with_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_removal_notification_licensee_with_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee separation notification - business</fullName>
        <actions>
            <name>Licensee_separation_notification_business</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_separation_notification_business</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee separation notification - licensee - no employer</fullName>
        <actions>
            <name>Licensee_separation_notification_licensee_no_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_separation_notification_licensee_no_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <description>Send email to parent and child license holder about cancelation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Licensee separation notification - licensee - with employer</fullName>
        <actions>
            <name>Licensee_separation_notification_licensee_with_employer</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Licensee_separation_notification_licensee_with_employer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Timeshare Salesperson,Camping Resort Salesperson</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee accept - trainee - 1st supervisor</fullName>
        <actions>
            <name>Trainee_accept_trainee_1st_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_accept_trainee_1st_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee accept - trainee - additional supervisor</fullName>
        <actions>
            <name>Trainee_accept_trainee_additional_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_accept_trainee_additional_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules> -->
    <rules>
        <fullName>Email - Trainee decline - trainee - no supervisor</fullName>
        <actions>
            <name>Trainee_decline_trainee_no_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_decline_trainee_no_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee intern accept - supervisor sponsor</fullName>
        <actions>
            <name>Trainee_intern_accept_supervisor_sponsor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_intern_accept_supervisor_sponsor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee intern decline - supervisor sponsor</fullName>
        <actions>
            <name>Trainee_intern_decline_supervisor_sponsor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_intern_decline_supervisor_sponsor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee intern invitation notification - supervisor sponsor</fullName>
        <actions>
            <name>Trainee_intern_invitation_notification_supervisor_sponsor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee intern invitation notification - trainee intern</fullName>
        <actions>
            <name>Trainee_intern_invitation_notification_trainee_intern</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee intern removal notification - supervisor sponsor</fullName>
        <actions>
            <name>Trainee_intern_removal_notification_supervisor_sponsor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_intern_removal_notification_supervisor_sponsor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <!--<rules>
        <fullName>Email - Trainee intern separation notification - supervisor sponsor</fullName>
        <actions>
            <name>Trainee_intern_separation_notification_supervisor_sponsor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_intern_separation_notification_supervisor_sponsor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee,Funeral Director Intern,Embalmer Intern</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee removal notification - trainee - no supervisor</fullName>
        <actions>
            <name>Trainee_removal_notification_trainee_no_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_removal_notification_trainee_no_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee removal notification - trainee - with supervisor</fullName>
        <actions>
            <name>Trainee_removal_notification_trainee_with_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_removal_notification_trainee_with_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee separation notification - trainee - no supervisor</fullName>
        <actions>
            <name>Trainee_separation_notification_trainee_no_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_separation_notification_trainee_no_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email - Trainee separation notification - trainee - with supervisor</fullName>
        <actions>
            <name>Trainee_separation_notification_trainee_with_supervisor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Email_Outbound_Trainee_separation_notification_trainee_with_supervisor</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Associations__c.Status__c</field>
            <operation>equals</operation>
            <value>Canceled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.License_Number_of_Active_Relationships__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.CreatedById</field>
            <operation>notContain</operation>
            <value>Data Administrator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Associations__c.Association_Type__c</field>
            <operation>equals</operation>
            <value>Appraiser Trainee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>update status and child parent license email</fullName>
        <actions>
            <name>Update_Child_License_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_parent_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( NOT (ISNULL(Parent_License__c))  ,NOT (ISNULL(Child_License__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules> -->
    <tasks>
        <fullName>Email_Outbound_Designated_person_invitation_notification</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Designated person invitation notification</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Intern_accept_intern</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Intern accept - intern</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Intern_decline_intern</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Intern decline - intern</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Intern_removal_notification_intern</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>MUSW__License2__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Intern removal notification - intern</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Intern_separation_notification_intern</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>MUSW__License2__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Intern separation notification - intern</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_accept_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee accept - business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_accept_licensee_additional_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee accept - licensee - additional employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_accept_licensee_one_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee accept - licensee - one employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_decline_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee decline - business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_decline_licensee_no_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee decline - licensee - no employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_invitation_notification_CR_licensee_additional_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee invitation notification - CR licensee - additional business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_invitation_notification_TS_licensee_additional_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee invitation notification - TS licensee - additional business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_invitation_notification_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee invitation notification - business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_invitation_notification_licensee</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee invitation notification - licensee</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_removal_notification_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee removal notification - business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_removal_notification_licensee_no_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee removal notification - licensee - no employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_removal_notification_licensee_with_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee removal notification - licensee - with employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_separation_notification_business</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee separation notification - business</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_separation_notification_licensee_no_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee separation notification - licensee - no employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Licensee_separation_notification_licensee_with_employer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Licensee separation notification - licensee - with employer</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_accept_trainee_1st_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee accept - trainee - 1st supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_accept_trainee_additional_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee accept - trainee - additional supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_decline_trainee_no_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee decline - trainee - no supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_intern_accept_supervisor_sponsor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee intern accept - supervisor sponsor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_intern_decline_supervisor_sponsor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee intern decline - supervisor sponsor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_intern_removal_notification_supervisor_sponsor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: 	Trainee intern removal notification - supervisor sponsor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_intern_separation_notification_supervisor_sponsor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee intern separation notification - supervisor sponsor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_removal_notification_trainee_no_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee removal notification - trainee - no supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_removal_notification_trainee_with_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee removal notification - trainee - with supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_separation_notification_trainee_no_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee separation notification - trainee - no supervisor</subject>
    </tasks>
    <tasks>
        <fullName>Email_Outbound_Trainee_separation_notification_trainee_with_supervisor</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Associations__c.Current_Datetime__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Email Outbound: Trainee separation notification - trainee - with supervisor</subject>
    </tasks>
</Workflow>
