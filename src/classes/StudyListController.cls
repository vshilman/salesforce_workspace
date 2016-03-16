/*
 * @Class Name   : StudyListController 
 * @Description  : Data Assest Records will be displayed based on Selected Criteria
 */

Public class StudyListController
{
    Public ApexPages.StandardSetController cStudyListCntlr {get;set;}
    
    Public Map < String, Integer > mCategoyCount {get;set;}
     
    Public Map < String, List < WrapperLabelCheckBox >> mStudyObjectStructure {get;set;}
    
    /* 
     * @Method Name                    :  getStudies
     * @Description                    :  Initialize cStudyListCntlr and return a list of records
     */
    
    Public List < RWE_Study__c > getStudies()
    {
        return (List < RWE_Study__c > ) cStudyListCntlr.getRecords();
    }

    //Constructor
    Public StudyListController(ApexPages.StandardController controller)
    {
        // Initialization
        mStudyObjectStructure = new Map < String, List < WrapperLabelCheckBox >> ();

        // Methods called
        DescribeObjectWithDetails();
        Query();
    }

    /* 
     * @Method Name                    :  DescribeObjectWithDetails
     * @Description                    :  This method populates the filtering fields on the UI page 
     */
    
    Public Void DescribeObjectWithDetails()
    {
        List < WrapperLabelCheckBox > lPicklist = new List < WrapperLabelCheckBox > ();
        mCategoyCount = new Map < String, Integer > ();

        for (Schema.Picklistentry oPicklistValues: RWE_Study__c.Therapeutic_Area__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mStudyObjectStructure.put('Therapeutic_Area__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Study__c.Study_Type__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mStudyObjectStructure.put('Study_Type__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Study__c.Study_Status__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mStudyObjectStructure.put('Study_Status__c', lPicklist);
        
        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Study__c.Region__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mStudyObjectStructure.put('Region__c', lPicklist);
        
        
        for (String mCount: mCategoyCount.keyset())
        {
            mCategoyCount.put(mCount, 0);
        }
        
        string sCombineQueryString =  HomePageUtility.cAggregateQueryString('Therapeutic_Area__c', 'RWE_Study__c' );
        
        system.debug('@@ sCombineQueryString @@ ' + sCombineQueryString);
            
        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Therapeutic_Area__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Study_Status__c', 'RWE_Study__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Study_Status__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Study_Type__c', 'RWE_Study__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Study_Type__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Region__c', 'RWE_Study__c');
        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Region__c'), (Integer) ar.get('gCount'));
        }
    }
    

    /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and displays the results on UI
     */
    
    Public void Query()
    {
        String sRegionClause = '';
        String sAccessMethodClause = '';
        String sTherapeuticAreaClause = '';
        String sRegionMethodClause= '';


        sRegionClause = HomePageUtility.FrameClause(mStudyObjectStructure.get('Study_Type__c'));
        if (sRegionClause != '')
        {
            sRegionClause = ' Study_Type__c IN ' + sRegionClause;
        }

        sTherapeuticAreaClause = HomePageUtility.FrameClause(mStudyObjectStructure.get('Therapeutic_Area__c'));
        if (sTherapeuticAreaClause != '')
        {
            sTherapeuticAreaClause = ' Therapeutic_Area__c IN ' + sTherapeuticAreaClause;
        }
        
        sRegionMethodClause= HomePageUtility.FrameClause(mStudyObjectStructure.get('Region__c'));
        if (sRegionMethodClause!= '')
        {
            sRegionMethodClause= ' Region__c IN ' + sRegionMethodClause;
        }


        sAccessMethodClause = HomePageUtility.FrameClause(mStudyObjectStructure.get('Study_Status__c'));
        if (sAccessMethodClause != '')
        {
            sAccessMethodClause = ' Study_Status__c IN ' + sAccessMethodClause;
        }

        cStudyListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
            'SELECT Name,Owner.Name,createddate,Start_Date__c,Study_Type__c,Therapeutic_Area__c,Study_Status__c,Study_Pick__c,Count_Study_Link__c,Study_Description__c,Study_Lead__c,Study_Lead__r.Name,  (Select Id, RWE_Data_Asset__c From RWE_Data_Asset_Study_Link__r)   FROM RWE_Study__c ' + HomePageUtility.CombineQuery('WHERE', new List < String >
            {                // , (SELECT Id, Name FROM Junction_Data_Asset_Studys__r)
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sRegionMethodClause
            }) + ' ORDER BY Name ASC NULLS FIRST' ));
        // cStudyListCntlr.setPageSize(10000);     
    }

    /* 
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     */
    
    public void FetchDataForCriteria()
    {
        Query();
    }
}