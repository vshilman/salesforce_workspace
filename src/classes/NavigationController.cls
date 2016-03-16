/***************************************************************************************************************************************** 
 * Class Name   : NavigationController 
 * Description  : Data Assest Records will be displayed based on Selected Criteria
 * Created By   : 
 * 
 *****************************************************************************************************************************************/
Public class NavigationController
{
    Public string sRequsestCount
    {
        get;
        set;
    }
    public NavigationController()
    {
        system.debug('To Check');
        List<Contact> cLastArrivalDate = [SELECT Id, Last_Arrived_Request__c FROM Contact WHERE Related_User__c =:  UserInfo.getUserId()];
        Datetime stringDate;
        if(cLastArrivalDate.size() > 0 ){
            stringDate = cLastArrivalDate[0].Last_Arrived_Request__c;
        }
        if(stringDate != null){
            AggregateResult ar = [SELECT count(Id) gCount FROM RWE_Data_Asset_Approval__c WHERE Relevant_Contact__r.Related_User__c =: UserInfo.getUserId() AND LastModifiedDate >: stringDate];
            sRequsestCount = (String) ar.get('gCount');
        }
        
    }
    
    public void qUpdateRequest()
    {
        Contact qUpdateContact = [SELECT Id, Last_Arrived_Request__c FROM Contact WHERE Related_User__c =: UserInfo.getUserId()];
        qUpdateContact.Last_Arrived_Request__c = system.Now();
        system.debug('@@ qUpdateContact @@' + qUpdateContact);
        update qUpdateContact;
    }
}