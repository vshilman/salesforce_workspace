public with sharing class DataAsset_Test {
    
    public List<RWE_Data_Asset__c> allDataAssets{get; set;}

    public DataAsset_Test () {
        allDataAssets= [SELECT Name,Asset_Status__c,Data_Continuity__c,Enrollment__c,Theraputic_Area__c FROM RWE_Data_Asset__c ORDER BY CreatedDate DESC NULLS LAST];
    }
}