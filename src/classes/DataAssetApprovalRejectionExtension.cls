/****************************************************************************************************************************************** 
 * Class Name   : DataAssetApprovalExtension
 * Description  : 
 * Created By   : 
 * 
 *****************************************************************************************************************************************/
 
Public class DataAssetApprovalRejectionExtension{

    public boolean cLincenseActive {get;set;}
    public boolean cLincenseUsage {get;set;}
    public boolean cUserCredentials {get;set;}
    public boolean cDataLicense {get;set;}
    public boolean cRestriction {get;set;}
    public boolean cFirstLevelApproval {get;set;}
    public boolean cSecondLevelApproval {get;set;}
    public boolean cDisabledComponents {get;set;}
    public RWE_Data_Asset_Approval__c eDataAssesst {get;set;}
    public String dynCom {get;set;}
    public string cLegalUserProfileId = gProfileId('Legal Reviewer');
    public string cLicenseUserProfileId = gProfileId('License Reviewer');
    public string cSystemAdminProfileId = gProfileId('System Administrator');

    public DataAssetApprovalRejectionExtension(ApexPages.StandardController controller){
        eDataAssesst    =   (RWE_Data_Asset_Approval__c)controller.getRecord();
        cFirstLevelApproval = false;
        cSecondLevelApproval = false;
                        
        if((UserInfo.getProfileId() == cLegalUserProfileId || UserInfo.getProfileId() == cLicenseUserProfileId || UserInfo.getProfileId() == cSystemAdminProfileId ))
        {
            cFirstLevelApproval = true;
        }
        if((eDataAssesst.Approval_Status__c == 'Pending Approval 2') && (UserInfo.getProfileId() == cLicenseUserProfileId || UserInfo.getProfileId() == cSystemAdminProfileId ))
        {
            cSecondLevelApproval = true;
            cLincenseActive = true;
            cLincenseUsage = true;
            cUserCredentials = true;
        }  
        if(eDataAssesst.Approval_Status__c == 'Approved')
        {
            cFirstLevelApproval = true;
            cSecondLevelApproval = true;
            cLincenseActive = true;
            cLincenseUsage = true;
            cUserCredentials = true;
            cDataLicense = true;
            cRestriction = true;
            cDisabledComponents = true;
        } 

    }
    
    /* 
     * @Method Name                    :  eApprovalProcess
     * @Description                    :  Approval Process will be invoked on Click   
     */
    public void eApprovalProcess()
    {
        
    }

    public List<Attachment> att{get;set;}
    /* 
     * @Method Name                    :  getRecAttach
     * @Description                    :  Attachments are retrieved for the parent record   
     */
    public String getRecAttach() 
    {
         att=[Select Id From Attachment where parentId= :eDataAssesst.RWE_Data_Asset__c LIMIT 1];
         String attId;
         for(Attachment recAtt: att)
         {
             attId = recAtt.Id;
         }
         return attId;   
    }
    
    /* 
     * @Method Name                    :  eApproveRequest
     * @Description                    :  Approve Request processed onclick of Approve Button 
     */
    public PageReference eApproveRequest()
    {
        if(UserInfo.getProfileId() == cLegalUserProfileId || UserInfo.getProfileId() == cSystemAdminProfileId )
        {
            system.debug(' @@ Profile Checked @@ ');
            if(cLincenseActive && cLincenseUsage && cUserCredentials)
            {
                if(eDataAssesst.Valid_Till__c <= Date.Today())
                {
                    ApprovalProcessHelper.ePageMessage('Info','Validity should be greater than today.');
                    return null; 
                }
                else
                {
                    system.debug(' @@ Checkboxes Checked @@ ');
                    update eDataAssesst;
                    ApprovalProcessHelper.eApproveRejectRequest(eDataAssesst, dynCom , 'Approve');
                }
                
            }
            else
            {
                system.debug('@@ Unchecked Checkboxes @@');
                ApprovalProcessHelper.ePageMessage('Info','Please check required check boxes.');
                return null;
            }   
        }
        else if(UserInfo.getProfileId() == cLicenseUserProfileId || UserInfo.getProfileId() == cSystemAdminProfileId )
        {
            if(cDataLicense && cRestriction)
            {
            
                if(eDataAssesst.Valid_Till__c <= Date.Today())
                {
                    ApprovalProcessHelper.ePageMessage('Info','Validity should be greater than today.');
                    return null; 
                }
                else
                {
                    system.debug(' @@ Checkboxes Checked @@ ');
                    update eDataAssesst;
                    ApprovalProcessHelper.eApproveRejectRequest(eDataAssesst, dynCom , 'Approve');
                }
            }
            else
            {
                ApprovalProcessHelper.ePageMessage('Info','Please check required check boxes.');
                return null;
            }               
        }
        else
        {
            ApprovalProcessHelper.ePageMessage('Info','Your Profile dont have access for Approval.');
            return null;
        }
             
        PageReference pageRef = new PageReference('/' + eDataAssesst.Id);
        pageRef.setredirect(true); 
        return pageRef;
    }
    
    /* 
     * @Method Name                    :  eRejectRequest
     * @Description                    :  Approve Request processed onclick of Approve Button 
     */
    public PageReference eRejectRequest()
    {
        ApprovalProcessHelper.eApproveRejectRequest(eDataAssesst, dynCom , 'Reject');
        PageReference pageRef = new PageReference('/' + eDataAssesst.Id);
        pageRef.setredirect(true); 
        return pageRef;
    }
    
    /* 
     * @Method Name                    :  gProfileId
     * @Description                    :  Profile Id retrieval for specified profile name
     */
    public static string gProfileId(string pName)
    {
        return [SELECT Id FROM Profile WHERE Name =: pName].Id;    
    }
}