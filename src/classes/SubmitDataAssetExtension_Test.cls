public class SubmitDataAssetExtension_Test {
    public New_Data_Asset_Request__c cDataAssetRequest{get;set;}
    public blob dUploadAttachementBody{get;set;}
    public string dFileName{get;set;}
   

    public SubmitDataAssetExtension_Test(ApexPages.StandardController controller) {
        cDataAssetRequest = (New_Data_Asset_Request__c)controller.getRecord();
    }
    
    public PageReference dCreateDataAsset(){
        // Insertion of Data Asset Record
        Database.SaveResult dResultDataAssetRequest = Database.Insert(cDataAssetRequest);
        
        // Insertion of required Attachement for it
        Attachment dAttachment = new Attachment();
        if(dUploadAttachementBody != null){
            dAttachment.Body = this.dUploadAttachementBody;
            dAttachment.Name = this.dFileName;
            dAttachment.ParentId = dResultDataAssetRequest.Id;
            Database.SaveResult dResultDataAssetAttach = Database.Insert(dAttachment);
        }
        
                
        PageReference dReturnPage = new PageReference('/' + dResultDataAssetRequest.Id);
        return dReturnPage; 
    }

}