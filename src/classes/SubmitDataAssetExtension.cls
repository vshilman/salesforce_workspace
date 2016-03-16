public class SubmitDataAssetExtension {
    public RWE_Data_Asset__c cDataAsset{get;set;}
    public blob dUploadAttachementBody{get;set;}
    public string dFileName{get;set;}
   

    public SubmitDataAssetExtension(ApexPages.StandardController controller) {
        cDataAsset = (RWE_Data_Asset__c)controller.getRecord();
    }
    
    public PageReference dCreateDataAsset(){
        // Insertion of Data Asset Record
        Database.SaveResult dResultDataAsset = Database.Insert(cDataAsset);
        
        // Insertion of required Attachement for it
        Attachment dAttachment = new Attachment();
        if(dUploadAttachementBody != null){
            dAttachment.Body = this.dUploadAttachementBody;
            dAttachment.Name = this.dFileName;
            dAttachment.ParentId = dResultDataAsset.Id;
            Database.SaveResult dResultDataAssetAttach = Database.Insert(dAttachment);
        }
        
                
        PageReference dReturnPage = new PageReference('/' + dResultDataAsset.Id);
        return dReturnPage; 
    }

}