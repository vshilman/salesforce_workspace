/****************************************************************************************************************************************** 
 * Class Name   : ApprovalProcessHelper
 * Description  : Generic Custom Approval Processes Methods has been written.
 * Created By   : 
 * 
 *****************************************************************************************************************************************/

public class ApprovalProcessHelper{
     
     /* 
     * @Method Name                    :  eApprovalProcess
     * @Description                    :  Approval Process will be invoked on Click 
     * @Return Type                    :  void
     * @Parameters                     :   
     */
    
    public static void eApprovalProcess(String aRecordId, String aComment){
        Approval.ProcessSubmitRequest sApprovalProcess = new Approval.ProcessSubmitRequest();
        sApprovalProcess.setComments(aComment);
        sApprovalProcess.setObjectId(aRecordId);
        Approval.ProcessResult result;
        try
        {
            // submit the approval request for processing
            result = Approval.process(sApprovalProcess);
        }
        catch(Exception e)
        {
            System.debug('No approval process has been setup yet.');
        }
    }
    
    /* 
     * @Method Name                    :  eApproveRejectRequest
     * @Description                    :  Approve and Reject Request Processed on click. 
     * @Return Type                    :  void
     * @Parameters                     :   
     */
    
    public static void eApproveRejectRequest(RWE_Data_Asset_Approval__c aDataAsset, String aComment, String aAction){
        
        Approval.ProcessWorkitemRequest sApprovalProcess = new Approval.ProcessWorkitemRequest();
        sApprovalProcess.setComments(aComment);
        list<ProcessInstanceWorkitem> sProcessWorkItems = [ SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :aDataAsset.Id AND ProcessInstance.Status = 'Pending' LIMIT 1];
        if(sProcessWorkItems.size() > 0)
        {
            sApprovalProcess.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            sApprovalProcess.setWorkitemId(sProcessWorkItems[0].Id);
            sApprovalProcess.setAction(aAction);            
        }
        else
        {
            ePageMessage('Info', 'No Process Pending for Approval.');           
        }
        try
        {
            Approval.ProcessResult result;
            result = Approval.process(sApprovalProcess);
        }
        catch(Exception e)
        {
            System.debug(aAction + ' Action to be Taken.');
        }
    }
    
    /* 
     * @Method Name                    :  ePageMessage
     * @Description                    :  Showing Page Message as required 
     * @Return Type                    :  void
     * @Parameters                     :   
     */
    
    public static void ePageMessage(String aMessageType, String aMessage){
        
        ApexPages.Message showMessage = new ApexPages.Message(ApexPages.Severity.INFO, aMessage);
        
        if(aMessageType == 'Info'){
            showMessage = new ApexPages.Message(ApexPages.Severity.INFO, aMessage);
        }
        
        ApexPages.addMessage(showMessage);
    }
}