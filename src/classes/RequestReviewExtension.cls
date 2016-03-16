/****************************************************************************************************************** 
 * Class Name   : RequestReviewExtension
 * Description  : 
 * Created By   : 
 * 
 ******************************************************************************************************************/
public class RequestReviewExtension {
   public RWE_Data_Asset_Approval__c eDataAssesst {get;set;}
   public String dynCom {get;set;} 
   public string cLegalUserProfileId = gProfileId('Legal Reviewer');
   public string cLicenseUserProfileId = gProfileId('License Reviewer');
   public string cSystemAdminProfileId = gProfileId('System Administrator');
   public RequestReviewExtension(ApexPages.StandardController controller){
      eDataAssesst    =   (RWE_Data_Asset_Approval__c)controller.getRecord();
    }
    
    
    
     /* 
     * @Method Name                    :  gProfileId
     * @Description                    :  Profile Id retrieval for specified profile name
     */
    public static string gProfileId(string pName)
    {
        return [SELECT Id FROM Profile WHERE Name =: pName].Id;    
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
        else if(UserInfo.getProfileId() == cLicenseUserProfileId || UserInfo.getProfileId() == cSystemAdminProfileId )
        {
            
                if(eDataAssesst.Valid_Till__c <= Date.Today())
                {
                    ApprovalProcessHelper.ePageMessage('Info','Validity should be greater than today.');
                    return null; 
                }
                else
                {
                    system.debug(' @@ Correct Valid till date is entered @@ ');
                    update eDataAssesst;
                    ApprovalProcessHelper.eApproveRejectRequest(eDataAssesst, dynCom , 'Approve');
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
}