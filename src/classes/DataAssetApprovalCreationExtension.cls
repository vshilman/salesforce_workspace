/****************************************************************************************************************************************** 
 * Class Name   : DataAssetApprovalCreationExtension
 * Description  : Data Asset Approval Record created and process of submission of Approval Process Using Apex
 * Created By   : 
 * 
 *****************************************************************************************************************************************/
public class DataAssetApprovalCreationExtension
{
    
    public RWE_Data_Asset_Approval__c cDataAssetApproval                {get;set;}
    public list<RWE_Data_Asset_Approval__c> cExistingDataAssetApproval  = new list<RWE_Data_Asset_Approval__c>();
    public list<Contact> cListContactDetails                            = new list<Contact>();
    public Contact cContactDetails                                      = new Contact();
    public boolean cIsApprovalProcessInvoked                            = false;
    public string cDataAssetId {get;set;}
    
    /* 
     * @Method Name                    :  Constructor
     * @Description                    :  This method invokes by default for page loading.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public DataAssetApprovalCreationExtension(ApexPages.StandardController controller) 
    {
        cDataAssetApproval = (RWE_Data_Asset_Approval__c)controller.getRecord();
        cDataAssetId = ApexPages.currentPage().getParameters().get('dataId');
        cApprovalProcessInvocation();
        system.debug(' dataId constructor ' + cDataAssetId);
    }
    
    /* 
     * @Method Name                    :  cApprovalProcessInvocation
     * @Description                    :  Checking whether Approval Process has been submitted already for the same set of data.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void cApprovalProcessInvocation()
    {
        cListContactDetails =   [SELECT Id FROM Contact WHERE Related_User__c =: UserInfo.getUserId()];
        if(cListContactDetails.size()>0){
            cContactDetails = cListContactDetails[0];
        }       
        
        cExistingDataAssetApproval = [SELECT Id, RWE_Data_Asset__r.Name FROM RWE_Data_Asset_Approval__c WHERE Relevant_Contact__c =: cContactDetails.Id AND RWE_Data_Asset__c =: cDataAssetId];
        
        if(cExistingDataAssetApproval.size() > 0)
        {
            cIsApprovalProcessInvoked = true;
        }   
    }

    /* 
     * @Method Name                    :  cDataApprovalRecord
     * @Description                    :  Returning appropriate messages on the page, Else invoking approval process if required.
     * @Return Type                    :  PageReference
     * @Parameters                     :  None
     */ 
    public PageReference cDataApprovalRecord()
    {
        if(cListContactDetails.size()<1)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Logged in user has not associated with any contact.'));
            return null;            
        }
        else if(!cIsApprovalProcessInvoked && cDataAssetId!=null)
        {
            iDataApprovalRecord();
            ApprovalProcessHelper.eApprovalProcess(cDataAssetApproval.Id, 'Submitted for Approval');
            PageReference pageRef = new PageReference('/'+cDataAssetApproval.Id);
            pageRef.setRedirect(true);
            // pageRef.getParameters().put( 'Id', cDataAssetApproval.Id);
            return pageRef;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Approval Request for current Data Asset has already been processed.'));
            return null;
        }
        
        
    }
    
    /* 
     * @Method Name                    :  iDataApprovalRecord
     * @Description                    :  Inserting RWE_Data_Asset__c record in the database.
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void iDataApprovalRecord(){
        system.debug('@@ dataId @@ ' + cDataAssetId);
        RWE_Data_Asset__c eDataAsset = [SELECT Id, Name FROM RWE_Data_Asset__c WHERE Id =: cDataAssetId];   
        cDataAssetApproval = new RWE_Data_Asset_Approval__c
                                                        (   Approval_Status__c = 'Pending Legal Approval',
                                                            Relevant_Contact__c = cContactDetails.Id,
                                                            RWE_Data_Asset__c = eDataAsset.Id,
                                                            Name = eDataAsset.Name,
                                                            Requestor__c = UserInfo.getUserId()
                                                        );
        system.debug ( ' @@ ' + cDataAssetApproval);                                                
        
        Database.SaveResult sResult = Database.Insert(cDataAssetApproval);
        
        if(sResult.isSuccess())
        {
            System.debug('@@ Record Inserted SuccesFully. @@' + sResult.getID());
        }
        else
        {
            for(Database.Error err : sResult.getErrors())
            {
                System.debug(' @@ Record Insertion Failed Reason  @@ ' + err.getMessage());
                System.debug(' @@The fields failed are @@ ' + err.getFields());
            }
        }
    }
}