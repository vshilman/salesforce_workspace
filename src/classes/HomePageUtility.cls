/****************************************************************************************************************************************** 
 * Class Name   : HomePageUtility 
 * Description  : Class to display the List of Data Asset records
 * Created By   : 
 * 
 *****************************************************************************************************************************************/
 
 public class HomePageUtility {
 
    /* 
     * @Method Name                    :  FrameClause
     * @Description                    :  This method constructs the query clause if check boxes are checked on UI 
     * @Return Type                    :  string
     * @Parameters                     :  List of WrapperLabelCheckBox  
     */
    Public static string FrameClause(List < WrapperLabelCheckBox > lWrapperForProcessing)
    {
        String sClause = '';

        for (WrapperLabelCheckBox oWrapper: lWrapperForProcessing)
        {
            if (oWrapper.isSelected)
            {
                sClause += '\'' + oWrapper.label + '\',';
            }
        }
        if (sClause != '')
        {
            sClause = '(' + sClause.removeend(',') + ')';
        }
        return sClause;
    }
    
    /* 
     * @Method Name                    :  CombineQuery
     * @Description                    :  This method combines all query clauses generated in FrameClause() method 
     * @Return Type                    :  string
     * @Parameters                     :  string and list of strings 
     */
    public static String combineQuery(String sPrefix, List < String > sClauses)
    {
        List < String > sCombineClause = new List < String > ();
        for (String sClause: sClauses)
        {
            if (sClause != null && sClause != '')
                sCombineClause.add(sClause);
        }
        if (sCombineClause.size() > 0)
            return ' ' + sPrefix + ' ' + string.join(sCombineClause, ' AND ');
        return '';
    }
    
    /* 
     * @Method Name                    :  cAggregateQueryString
     * @Description                    :  This method combines all query clauses generated in FrameClause() method 
     * @Return Type                    :  string
     * @Parameters                     :  string and list of strings 
     */
    public static String cAggregateQueryString(String sCustomField, string sCustomObject)
    {
        return 'SELECT count(Id) gCount, ' + sCustomField + ' FROM ' +  sCustomObject + ' where ' +  sCustomField + ' !=null  GROUP BY ' + sCustomField ;
    
    }
    
     /* 
     * @Method Name                    :  cAggregateQueryString
     * @Description                    :  This method combines all query clauses generated in FrameClause() method 
     * @Return Type                    :  string
     * @Parameters                     :  string and list of strings 
     */
    public static String cAggregateQueryString(String sCustomField, string sCustomObject, string sCombinedQuery)
    {
        return 'SELECT count(Id), ' + sCustomField + ' FROM ' +  sCustomObject + ' where ' +  sCustomField + ' !=null ' + sCombinedQuery + ' GROUP BY ' + sCustomField ;
    
    }
    
    
 
 }