/****************************************************************************************************************************************** 
* Class Name   : Clone_Index_Controller
* Description  : Class for Clone_Index Component
* Created By   : Deloitte Consulting
* 
*****************************************************************************************************************************************/
Public with sharing class Clone_Index_Controller {

    Public String homeUrl {
        get;
        set;
    }
    Public String searchWord {
        get;
        set;
    }
    Public Boolean Studies {
        get;
        set;
    }
    Public Boolean Everything {
        get;
        set;
    }
    Public Boolean DataAssets {
        get;
        set;
    }
    Public Boolean Partnerships {
        get;
        set;
    }
    Public Boolean Requests {
        get;
        set;
    }

    //Constructor for Index component
    Public Clone_Index_Controller() {

        Everything = true;
        Studies = true;
        DataAssets = true;
        Partnerships = true;
        Requests = true;

        homeurl = Clone_Index_Controller.gethomeurl();

    }
    
     /* 
    * @Method Name                    :  populateGlobalURL
    * @Description                    :  Method for Referencing tabs on the Page
    * @Return Type                    :  PageReference 
    * @Parameters                     :  None
    */ 
    public PageReference populateGlobalURL() {
        if (searchWord != NULL && searchWord != '') {
            string reference;
            string encodedString;
            searchWord = EncodingUtil.urlEncode(searchWord, 'UTF-8');
            reference = '/apex/Clone_Global_Search?searchWord=' + searchWord ;
            if (Studies == true) {
                reference += '&Studies=true';
            }
            if (DataAssets == true) {
                reference += '&DataAssets=true';
            }
            if (Partnerships == true) {
                reference += '&Partnerships=true';
            }
            if (Requests == true) {
                reference += '&Requests=true';
            }
            PageReference pageRef = new PageReference(reference);
            pageRef.setRedirect(true);
            return pageRef;
        } else {
            return NULL;
        }
    }
    
     /* 
    * @Method Name                    :  getHomeUrl
    * @Description                    :  Method for Returning back to RWE App
    * @Return Type                    :  String
    * @Parameters                     :  None
    */
    public static String getHomeUrl() {
        String homeURL = '';
        Request_FieldId_Settings__c oCustSetting = Request_FieldId_Settings__c.getOrgDefaults();
        String AppId = oCustSetting.RWE_AppId__c;
      //  homeURL = homeURL.substring(homeURL.lastindexOf(Label.Clone_HomeURL.substring(19)) + 1);
      //  homeURL = Label.Clone_HomeURL + AppId;
        return homeUrl;
    }
 
}