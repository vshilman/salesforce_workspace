@isTest
public class TestDataFactory {

    public static Contact createContact(){
        Contact con = new Contact(  FirstName = 'TestFirst',
                                    LastName = 'TestLast',
                                    Email = 'test@test.com',
                                    Related_User__c = UserInfo.getUserId()
                                    );
        return con;
    }
    
    public static RWE_Data_Asset__c  createDataAsset(String contactId) { 
        RWE_Data_Asset__c  dataAsset = new RWE_Data_Asset__c ( Name = 'Test Data Asset',
                                                                Raw_Data_Accessibility__c = 'Test Accessibiltiy',
                                                                Theraputic_Area__c = 'Test Theraputic Area',
                                                                Claims_Type__c = 'Test Claim Type',
                                                                Data_Type__c = 'Test Data Type',
                                                                Enrollment__c = '100-200',
                                                                Data_Asset_Owner__c = contactId
                                                                );  
                        
        
        return dataAsset;
    }

    public static RWE_Data_Profiler__c createDataProfiler(string dataAssetId){
        RWE_Data_Profiler__c dataProfiler = new RWE_Data_Profiler__c(   Data_Profiler__c = 'Test Proifler',
                                                                        Data_Profiler_Link__c = 'www.test.com',
                                                                        RWE_Data_Asset_Profiler__c = dataAssetId);
        return dataProfiler;                                                                        
    }
    
    public static RWE_Study__c createStudy(string contactId){
        RWE_Study__c study = new RWE_Study__c(   Study_Lead__c = contactId,
                                                        Name = 'TestStudy',
                                                        Research_Trials__c = 'Test Trial',
                                                        Study_Pick__c = 'Test Pick',
                                                        Study_Status__c = 'In Progress',
                                                        Therapeutic_Area__c = 'Test Generic');
        return study;                                                                        
    }
    
    public static RWE_Data_Asset_Approval__c createRequest(string dataAssetId, string contactId){
        RWE_Data_Asset_Approval__c request = new RWE_Data_Asset_Approval__c(   Approval_Status__c= 'Approved',
                                                        Relevant_Contact__c = contactId,
                                                        Requestor__c = UserInfo.getUserId(),
                                                        RWE_Data_Asset__c = dataAssetId);
        return request;                                                                        
    }
    
          
}