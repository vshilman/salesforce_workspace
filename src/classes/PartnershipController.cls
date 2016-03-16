/*
 * @Class Name   : PartnershipController 
 * @Description  : Data Assest Records will be displayed based on Selected Criteria
 */

Public class PartnershipController
{
    Public ApexPages.StandardSetController cPartnershipListCntlr {get;set;}
    
    Public Map < String, Integer > mCategoyCount {get;set;}
     
    Public Map < String, List < WrapperLabelCheckBox >> mPartnershipObjectStructure {get;set;}
    
    /* 
     * @Method Name                    :  getPartnerships
     * @Description                    :  Initialize cPartnershipListCntlr and return a list of records
     */
    
    Public List < RWE_Partnership__c > getPartnerships()
    {   
        //system.debug('values in the list' + (List < RWE_Partnership__c > )cPartnershipListCntlr.getRecords());
        return (List < RWE_Partnership__c > ) cPartnershipListCntlr.getRecords();
    }

    //Constructor
    Public PartnershipController(ApexPages.StandardController controller)
    {
        // Initialization
        mPartnershipObjectStructure = new Map < String, List < WrapperLabelCheckBox >> ();

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

        for (Schema.Picklistentry oPicklistValues: RWE_Partnership__c.Partner_Type__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipObjectStructure.put('Partner_Type__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Partnership__c.Partnership_Status__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipObjectStructure.put('Partnership_Status__c', lPicklist);

        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Partnership__c.Partnership_Sponsor__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipObjectStructure.put('Partnership_Sponsor__c', lPicklist);


        lPicklist = new List < WrapperLabelCheckBox > ();
        for (Schema.Picklistentry oPicklistValues: RWE_Partnership__c.Region__c.getDescribe().getPicklistValues())
        {
            lPicklist.add(new WrapperLabelCheckBox(oPicklistValues.Value, false));
            mCategoyCount.put(oPicklistValues.Label, 0);
        }
        mPartnershipObjectStructure.put('Region__c', lPicklist);        
        
        for (String mCount: mCategoyCount.keyset())
        {
            mCategoyCount.put(mCount, 0);
        }
        
        string sCombineQueryString =  HomePageUtility.cAggregateQueryString('Partner_Type__c', 'RWE_Partnership__c' );
        
        system.debug('@@ sCombineQueryString @@ ' + sCombineQueryString);
            
        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Partner_Type__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Partnership_Sponsor__c', 'RWE_Partnership__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Partnership_Sponsor__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Partnership_Status__c', 'RWE_Partnership__c');

        for (AggregateResult ar: database.query(sCombineQueryString))
        {
            mCategoyCount.put((String) ar.get('Partnership_Status__c'), (Integer) ar.get('gCount'));
        }
        
        sCombineQueryString =  HomePageUtility.cAggregateQueryString('Region__c', 'RWE_Partnership__c');

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
        String sRegionMethodClause = '';

        sRegionClause = HomePageUtility.FrameClause(mPartnershipObjectStructure.get('Partnership_Status__c'));
        if (sRegionClause != '')
        {
            sRegionClause = ' Partnership_Status__c IN ' + sRegionClause;
        }

        sTherapeuticAreaClause = HomePageUtility.FrameClause(mPartnershipObjectStructure.get('Partner_Type__c'));
        if (sTherapeuticAreaClause != '')
        {
            sTherapeuticAreaClause = ' Partner_Type__c IN ' + sTherapeuticAreaClause;
        }


        sAccessMethodClause = HomePageUtility.FrameClause(mPartnershipObjectStructure.get('Partnership_Sponsor__c'));
        if (sAccessMethodClause != '')
        {
            sAccessMethodClause = ' Partnership_Sponsor__c IN ' + sAccessMethodClause;
        }
        
         sRegionMethodClause = HomePageUtility.FrameClause(mPartnershipObjectStructure.get('Region__c'));
        if (sRegionMethodClause != '')
        {
            sRegionMethodClause = ' Region__c IN ' + sRegionMethodClause;
        }

        cPartnershipListCntlr = new ApexPages.StandardSetController(Database.getQueryLocator(
            'SELECT Name,Owner.Name,createddate,Partnership_Status__c,Partner_Type__c,Partnership_Sponsor__c,Partnership_Lead__r.Name,Partnership_Lead__c FROM RWE_Partnership__c ' + HomePageUtility.CombineQuery('WHERE', new List < String >
            {
                sRegionClause, sAccessMethodClause, sTherapeuticAreaClause, sRegionMethodClause
            }) + ' ORDER BY Name ASC NULLS FIRST' ));
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