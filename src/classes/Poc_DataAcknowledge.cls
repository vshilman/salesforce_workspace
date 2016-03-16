public without sharing class Poc_DataAcknowledge{

    RWE_Data_Asset__c oAsset;
    list<Asset_Acknowledgement_Tracker__c> listAcknowledge = new list<Asset_Acknowledgement_Tracker__c>();
    Public string sFireWallMessage {get;private set;}
    Public Boolean IsRestrict;

    public Poc_DataAcknowledge(ApexPages.StandardController controller) {
        oAsset = (RWE_Data_Asset__c )controller.getRecord();
        listAcknowledge = [SELECT Id FROM Asset_Acknowledgement_Tracker__c WHERE Data_Asset__c =: oAsset.Id AND User__c =: UserInfo.getUserId()];
        
        sFireWallMessage  = Label.Acknowledgement;
    }
    
    public PageReference onPageLoad(){
        
        PageReference pageRef;
        if(listAcknowledge.size()>0){
            pageRef = new PageReference('/' + oAsset.Id);
            return pageRef;
        }
        else{
            return null;
        }
    }
    
    public PageReference onCancel(){
        
        PageReference pageRef = new PageReference('/apex/DataAssets');
        return pageRef;
        
    }
    
    public PageReference onAcknowledge(){
        
        Asset_Acknowledgement_Tracker__c createAcknowledge = new Asset_Acknowledgement_Tracker__c (
                                                                                                    Data_Asset__c = oAsset.Id,
                                                                                                    User__c = userInfo.getUserId(),
                                                                                                    Acknowledgement_Date__c = system.Today()
                                                                                                    );
        Database.Insert(createAcknowledge);    
        PageReference pageRef = new PageReference('/' + oAsset.Id);
        return pageRef;
        
    }
}