/***************************************************************************************************************************************** 
 * Class Name   : RequestListController 
 * Description  : Data Assest Records will be displayed based on Selected Criteria
 * Created By   : 
 * 
 *****************************************************************************************************************************************/
Public class RequestListController
{
 
    Public ApexPages.StandardSetController cRequestListController
    {
        get;
        set;
    }
    Public string sField
    {
        get;
        set;
    }
    Public string sSearchWord
    {
        get;
        set;
    }
    Public string sOrder
    {
        get;
        set;
    }
    Public Map < String, Integer > mCategoyCount
    {
        get;
        set;
    }
    Public string sOwnerType
    {
        get;
        set;
    }
    Public List < Integer > lPageNumbers
    {
        get;
        private set;
    }
    Public Integer iPageNumber
    {
        get;
        set;
    }
    Public Map < String, List < WrapperLabelCheckBox >> mRequestListObjectStructure
    {
        get;
        set;
    }
    public Integer pNoLimit
    {
        get;
        set;
    }
    public Decimal dPageCount
    {
        get;
        set;
    }
    public string previousSField
    {
        get;
        set;
    }
    
    string aWhereCondition = '';
    string iWhereCondition = '';
    String sRegionClause = '';
    String sAccessMethodClause = '';
    String sTherapeuticAreaClause = '';
    String sApprovalStatus = '';
    
    public string cLegalUserProfileId = DataAssetApprovalRejectionExtension.gProfileId('Legal Reviewer');
    public string cLicenseUserProfileId = DataAssetApprovalRejectionExtension.gProfileId('License Reviewer');
    public string cSystemAdminProfileId = DataAssetApprovalRejectionExtension.gProfileId('System Administrator');

    /* 
     * @Method Name                    :  getRequestList
     * @Description                    :  Initialize cRequestListController and return a list of records
     * @Return Type                    :  list of data asset records
     * @Parameters                     :  None
     */
    Public List < RWE_Data_Asset_Approval__c > getRequestList()
    {
        return (List < RWE_Data_Asset_Approval__c > ) cRequestListController.getRecords();
    }

    //Loading the constructor the page
    Public RequestListController(ApexPages.StandardController controller)
    {
        pNoLimit = 20;
        // Initialisation 
        sField = 'Name';
        previousSField = 'Name';
        sOrder = 'ASC NULLS FIRST';
        mRequestListObjectStructure = new Map < String, List < WrapperLabelCheckBox >> ();
        

        if(UserInfo.getProfileId() == cLegalUserProfileId )
        {
            aWhereCondition += ' Approval_Status__c = \'Pending Legal Approval\'';
        }
        else if(UserInfo.getProfileId() == cLicenseUserProfileId)
        {
            aWhereCondition += ' Approval_Status__c = \'Pending License Approval\'';
        }
        else if( UserInfo.getProfileId() == cSystemAdminProfileId)
        {
            aWhereCondition += ' (Approval_Status__c = \'Pending License Approval\' OR Approval_Status__c = \'Pending Legal Approval\')' ;
        }
        else
        {
            aWhereCondition += ' Requestor__c = UserInfo.getUserId()';
        }

        // Methods for call
        DescribeObjectWithDetails();
        Query(sField + ' ' + sOrder);

    }

    /* 
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  This method populates the filtering fields on the UI page 
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    Public Void DescribeObjectWithDetails()
    {
        List < WrapperLabelCheckBox > lPicklist = new List < WrapperLabelCheckBox > ();
        mCategoyCount = new Map < String, Integer > ();

        // Not using global describe which is taking longer time, hence hardcoding the field for describe
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Theraputic_Area__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRequestListObjectStructure.put('Theraputic_Area__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Raw_Data_Accessibility__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRequestListObjectStructure.put('Raw_Data_Accessibility__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Claims_Type__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRequestListObjectStructure.put('Claims_Type__c', lPicklist);
        
        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset_Approval__c.Approval_Status__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mRequestListObjectStructure.put('Approval_Status__c', lPicklist);
        
        string sCombineQueryString =  HomePageUtility.cAggregateQueryString('RWE_Data_Asset__r.Theraputic_Area__c', 'RWE_Data_Asset_Approval__c', HomePageUtility.CombineQuery('AND', new List < String >
                                                                    {
                                                                        sApprovalStatus, sRegionClause, sAccessMethodClause, aWhereCondition
                                                                    }));
        
        system.debug('@@ sCombineQueryString @@ ' + sCombineQueryString);
            
        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Theraputic_Area__c'), (Integer) ar.get('expr0'));
        }

        sCombineQueryString =  HomePageUtility.cAggregateQueryString('RWE_Data_Asset__r.Claims_Type__c', 'RWE_Data_Asset_Approval__c', HomePageUtility.CombineQuery('AND', new List < String >
                                                                    {
                                                                        sApprovalStatus, sRegionClause, sTherapeuticAreaClause, aWhereCondition
                                                                    }));
                                                                    
        for (AggregateResult ar: database.query(sCombineQueryString ))
        {
            mCategoyCount.put((String) ar.get('Claims_Type__c'), (Integer) ar.get('expr0'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('RWE_Data_Asset__r.Raw_Data_Accessibility__c', 'RWE_Data_Asset_Approval__c', HomePageUtility.CombineQuery('AND', new List < String >
                                                                    {
                                                                        sApprovalStatus, sAccessMethodClause, sTherapeuticAreaClause, aWhereCondition
                                                                    }));

        for (AggregateResult ar: database.query(sCombineQueryString ))
        {
            mCategoyCount.put((String) ar.get('Raw_Data_Accessibility__c'), (Integer) ar.get('expr0'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Approval_Status__c', 'RWE_Data_Asset_Approval__c', HomePageUtility.CombineQuery('AND', new List < String >
                                                                    {
                                                                        sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, aWhereCondition
                                                                    }));

        for (AggregateResult ar: database.query(sCombineQueryString ))
        {
            mCategoyCount.put((String) ar.get('Approval_Status__c'), (Integer) ar.get('expr0'));
        }
        
        system.debug(' @@ mCategoyCount @@ '+ mCategoyCount); 
        
    }

    
    

    /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and displays the results on UI 
     * @Return Type                    :  void
     * @Parameters                     :  String sOrder
     */
    Public void Query(String sOrder)
    {
       

        sRegionClause = HomePageUtility.FrameClause(mRequestListObjectStructure.get('Raw_Data_Accessibility__c'));
        if (sRegionClause != '')
        {
            sRegionClause = ' RWE_Data_Asset__r.Raw_Data_Accessibility__c IN ' + sRegionClause;
        }

        sTherapeuticAreaClause = HomePageUtility.FrameClause(mRequestListObjectStructure.get('Theraputic_Area__c'));
        if (sTherapeuticAreaClause != '')
        {
            sTherapeuticAreaClause = ' RWE_Data_Asset__r.Theraputic_Area__c IN ' + sTherapeuticAreaClause;
        }


        sAccessMethodClause = HomePageUtility.FrameClause(mRequestListObjectStructure.get('Claims_Type__c'));
        if (sAccessMethodClause != '')
        {
            sAccessMethodClause = ' RWE_Data_Asset__r.Claims_Type__c IN ' + sAccessMethodClause;
        }
        
        sApprovalStatus = HomePageUtility.FrameClause(mRequestListObjectStructure.get('Approval_Status__c'));
        if (sApprovalStatus != '')
        {
            sApprovalStatus = ' Approval_Status__c IN ' + sApprovalStatus;
        }
        
        iWhereCondition = HomePageUtility.CombineQuery('', new List < String >
                                                        {
                                                            sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sApprovalStatus
                                                        });
        system.debug('@@ iWhereCondition  @@' + iWhereCondition + '@@ iWhereCondition  @@');
        if(String.isNotBlank(iWhereCondition))
        {
            iWhereCondition = '( ' +  iWhereCondition  + ' ) ' + ' AND ' ;
        }
        system.debug('@@ iWhereCondition  @@' + iWhereCondition + '@@ iWhereCondition  @@');
        
        system.debug('aWhereCondition '+ aWhereCondition );
        cRequestListController = new ApexPages.StandardSetController(Database.getQueryLocator(
        'SELECT Name, createddate, RWE_Data_Asset__r.Raw_Data_Accessibility__c,Relevant_Contact__r.Name, RWE_Data_Asset__r.Theraputic_Area__c, RWE_Data_Asset__r.Claims_Type__c,Relevant_Contact__c, Approval_Status__c FROM RWE_Data_Asset_Approval__c WHERE' + iWhereCondition  + aWhereCondition  + ' ORDER BY ' + sOrder));

        



        
    }

    /* 
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    public void FetchDataForCriteria()
    {
        Query(sField + ' ' + sOrder);
    }

 
}