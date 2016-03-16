<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Approval_Status_Approved</fullName>
        <description>This will update the field to approved</description>
        <field>Asset_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Legal_Review</fullName>
        <field>Asset_Status__c</field>
        <literalValue>Under Legal Review</literalValue>
        <name>Update Approval Status Legal Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Rejected</fullName>
        <description>This is to update the approval status to rejected</description>
        <field>Asset_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Under_License_Rev</fullName>
        <description>This is to update the Approval Status to-Evaluation in Progress, after initially submitting for approval.</description>
        <field>Asset_Status__c</field>
        <literalValue>Under License Review</literalValue>
        <name>Update Approval Status License Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
