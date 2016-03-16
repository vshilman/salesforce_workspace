public class SubmitPartnershipExtension {
    public RWE_Partnership__c cPartnership{get;set;}
    public blob dUploadAttachementBody{get;set;}
    public string dFileName{get;set;}

    public SubmitPartnershipExtension(ApexPages.StandardController controller) {
        cPartnership = (RWE_Partnership__c )controller.getRecord();
    }
    
    public PageReference dCreateDataAsset(){
        // Insertion of Data Asset Record
        Database.SaveResult dResultPartnership= Database.Insert(cPartnership);
        
        // Insertion of required Attachement for it
        Attachment dAttachment = new Attachment();
        if(dUploadAttachementBody != null){
            dAttachment.Body = this.dUploadAttachementBody;
            dAttachment.Name = this.dFileName;
            dAttachment.ParentId = dResultPartnership.Id;
            Database.SaveResult dResultDataAssetAttach = Database.Insert(dAttachment);
        }
        
                
        PageReference dReturnPage = new PageReference('/' + dResultPartnership.Id);
        return dReturnPage; 
    }

}