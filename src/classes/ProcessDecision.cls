public with sharing class ProcessDecision {

    public String recId;
    public RWE_Data_Asset__c records {get; set;}
    
    
    public processDecision (){
        recId = ApexPages.currentPage().getParameters().get('id'); 
        records = [select Name,Data_Asset_ID__c,Data_Continuity__c,Data_Type__c,Enrollment__c,Medical_Reports__c FROM RWE_Data_Asset__c where id =:recId];
        
        
        }








}