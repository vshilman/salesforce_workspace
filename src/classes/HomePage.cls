/****************************************************************************************************************************************** 
* Class Name   : HomePage
* Description  : Class for the HomePage on the UI
* Created By   : AJ
* 
*****************************************************************************************************************************************/
public with sharing class HomePage {

    public String getA() {
        return null;
    }
    
    public string cLegalUserProfileId = DataAssetApprovalRejectionExtension.gProfileId('Legal Reviewer');
    public string cLicenseUserProfileId = DataAssetApprovalRejectionExtension.gProfileId('License Reviewer');
    public string cSystemAdminProfileId = DataAssetApprovalRejectionExtension.gProfileId('System Administrator');
    string aWhereCondition = '' ;

    Public Map<String,Integer> mCategoyCount {get;set;} 

        //Loading the Constructor
    public HomePage () {
            
        mCategoyCount = new Map<String,Integer>();
        
        
        if(UserInfo.getProfileId() == cLegalUserProfileId )
        {
            aWhereCondition += ' Approval_Status__c = \'Pending License Approval\'';
        }
        else if(UserInfo.getProfileId() == cLicenseUserProfileId)
        {
            aWhereCondition += ' Approval_Status__c = \'Pending Legal Approval\'';
        }
        else if( UserInfo.getProfileId() == cSystemAdminProfileId)
        {
            aWhereCondition += ' (Approval_Status__c = \'Pending Legal Approval\' OR Approval_Status__c = \'Pending License Approval\')' ;
        }
        else
        {
            Id userId = UserInfo.getUserId();
            aWhereCondition += ' Requestor__c =:  userId ';
        }
        
        system.debug(' @@ aWhereCondition   @@ ' + aWhereCondition );
        
        for (AggregateResult ar : database.query('SELECT count(Id) FROM RWE_Data_Asset_Approval__c WHERE '  + aWhereCondition)) {
            mCategoyCount.put('Request',(Integer)ar.get('expr0'));
        }
        
        for (AggregateResult ar : [SELECT count(Id) FROM RWE_Partnership__c]) {
            mCategoyCount.put('Partnerships',(Integer)ar.get('expr0'));
        }
                
        for (AggregateResult ar : [SELECT count(Id) FROM RWE_Data_Asset__c]) {
            mCategoyCount.put('DataAssets',(Integer)ar.get('expr0'));
        }
        
        
        for (AggregateResult ar : [SELECT count(Id) FROM RWE_Study__c]) {
            mCategoyCount.put('Study',(Integer)ar.get('expr0'));
        }      
         
    }
}