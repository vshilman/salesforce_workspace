<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Approval_RejectedReview</fullName>
        <field>Request_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval RejectedReview</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Legal_Review</fullName>
        <field>Request_Status__c</field>
        <literalValue>Under Legal Review</literalValue>
        <name>Update Approval Status Legal Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_License_Review</fullName>
        <field>Request_Status__c</field>
        <literalValue>Under License Review</literalValue>
        <name>Update Approval Status License Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
