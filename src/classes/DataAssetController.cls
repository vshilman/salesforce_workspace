/*
 * @Class Name   : DataAssetController 
 * @Description  : Data Assest Records will be displayed based on Selected Criteria
 */

Public class DataAssetController
{
    Public List < RWE_Data_Asset__c > cDataAssetListCntlr {get;set;}
    
    Public Map < String, Integer > mCategoyCount {get;set;}
     
    Public Map < String, List < WrapperLabelCheckBox >> mDataAssetObjectStructure {get;set;}
    

    //Cnstructor
    Public DataAssetController(ApexPages.StandardController controller)
    {
        // Initialization
        mDataAssetObjectStructure = new Map < String, List < WrapperLabelCheckBox >> ();

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

        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Theraputic_Area__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Theraputic_Area__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Raw_Data_Accessibility__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Raw_Data_Accessibility__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Data_Type__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Data_Type__c', lPicklist);
        
        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Data_Asset__c.Region__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mDataAssetObjectStructure.put('Region__c', lPicklist);
        
        
        for (String mCount: mCategoyCount.keyset())
        {
            mCategoyCount.put(mCount, 0);
        }
        
        string sCombineQueryString =  HomePageUtility.cAggregateQueryString('Theraputic_Area__c', 'RWE_Data_Asset__c' );
        
        system.debug('@@ sCombineQueryString @@ ' + sCombineQueryString);
            
        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Theraputic_Area__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Data_Type__c', 'RWE_Data_Asset__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Data_Type__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Raw_Data_Accessibility__c', 'RWE_Data_Asset__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Raw_Data_Accessibility__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Region__c', 'RWE_Data_Asset__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Region__c'), (Integer) ar.get('gCount'));
        }
    }

    /* 
     * @Method Name                    :  Query
     * @Description                    :  This method queries the data base and displays the results on UI 
     * @Return Type                    :  void
     * @Parameters                     :  String sOrder
     */
    
    Public void Query()
    {
        String sRegionClause = '';
        String sAccessMethodClause = '';
        String sTherapeuticAreaClause = '';
        String sRegionMethod = '';

        sRegionClause = HomePageUtility.FrameClause(mDataAssetObjectStructure.get('Raw_Data_Accessibility__c'));
        if (sRegionClause != '')
        {
            sRegionClause = ' Raw_Data_Accessibility__c IN ' + sRegionClause;
        }

        sTherapeuticAreaClause = HomePageUtility.FrameClause(mDataAssetObjectStructure.get('Theraputic_Area__c'));
        if (sTherapeuticAreaClause != '')
        {
            sTherapeuticAreaClause = ' Theraputic_Area__c IN ' + sTherapeuticAreaClause;
        }
        
        sRegionMethod = HomePageUtility.FrameClause(mDataAssetObjectStructure.get('Region__c'));
        if (sRegionMethod != '')
        {
           sRegionMethod = ' Region__c IN ' + sRegionMethod ;
        }


        sAccessMethodClause = HomePageUtility.FrameClause(mDataAssetObjectStructure.get('Data_Type__c'));
        if (sAccessMethodClause != '')
        {
            sAccessMethodClause = ' Data_Type__c IN ' + sAccessMethodClause;
        }

        cDataAssetListCntlr = Database.Query(
            'SELECT Name,Owner.Name,CreatedDate,Raw_Data_Accessibility__c,Theraputic_Area__c,Data_Asset_Owner__r.Name,Data_Asset_Owner__c,Description__c,Claims_Type__c,Created_Date__c,Data_Type__c,Enrollment__c, Open_Cohort__c, Create_Cohort__c, Count_Studies__c,  (SELECT Id,Data_Profiler__c, Data_Profiler_Link__c FROM RWE_Data_Profilers__r) FROM RWE_Data_Asset__c ' + HomePageUtility.CombineQuery('WHERE', new List < String >
            {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sRegionMethod 
            }) + ' ORDER BY Name ASC NULLS FIRST' );
            
            // system.debug('@@ SOMETHING   @@' + cDataAssetListCntlr.getResultSize() );
    }

    /* 
     * @Method Name                    :  FetchDataForCriteria
     * @Description                    :  This method is called upon anny action on UI to query the data base
     */
    
    public void FetchDataForCriteria()
    {
        system.debug('inside controller');
        Query();
    }
}