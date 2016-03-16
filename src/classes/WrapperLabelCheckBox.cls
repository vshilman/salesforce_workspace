/****************************************************************************************************************************************** 
 * Class Name   : WrapperLabelCheckBox 
 * Description  : This is a wrapper class which holds the picklist value name and checkbox to filter out results on Data Asset list Page
 * Created By   : 
 * 
 *****************************************************************************************************************************************/

Public class WrapperLabelCheckBox
{
    Public Boolean isSelected
    {
        get;
        set;
    }
    Public string label
    {
        get;
        set;
    }
    public WrapperLabelCheckBox(String l, Boolean isC)
    {
        label = l;
        isSelected = isC;
    }
}