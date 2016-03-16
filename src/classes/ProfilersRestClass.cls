@RestResource(urlMapping='/Profilers/*')
global with sharing class ProfilersRestClass {
  
    @HttpGet
    global static list<RWE_Data_Profiler__c> getProfilersList() {
        RestRequest req = RestContext.request;        
        
        String uId = req.requestURI.substring(
                                  req.requestURI.lastIndexOf('/')+1);
        User cUser = new User();
        list<RWE_Data_Profiler__Share> cListProfilerShares = new list<RWE_Data_Profiler__Share>();
        if(uId != null){
            cUser = 
                       [SELECT Id, Name
                        FROM User 
                        WHERE username = :uId];
            
            cListProfilerShares = [SELECT Id, ParentId, UserOrGroupId
                                                                  FROM RWE_Data_Profiler__Share
                                                                  WHERE UserOrGroupId =: cUser.Id
                                                                        ]; // OR UserOrGroupId LIKE'00G%'
        }
        
        
        set<Id> cProfilerIds = new set<Id>();
        // set<Id> cGroupIds = new set<Id>();
        if(cListProfilerShares.size() > 0){
            for(RWE_Data_Profiler__Share eProfilerShare : cListProfilerShares){
                // if(eProfilerShare.UserOrGroupId.startsWith('00G')){
                    // cGroupIds.add(eProfilerShare.UserOrGroupId); 
                // }
                // else{
                    cProfilerIds.add(eProfilerShare.ParentId);              
                // }
            }
        }
        
        return [SELECT  Data_Profiler__c, Data_Asset_Name__c FROM RWE_Data_Profiler__c WHERE Id IN: cProfilerIds];
        
                    
    }
}