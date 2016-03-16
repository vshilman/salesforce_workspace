public with sharing class UserTriggerHandler {
    
    public static void OnAfterInsert(List <User> userListNew){		
		    Contact newContact = new Contact();
        
        List <Contact> toInsertContacts = new List <Contact>();
        for(User eachUser : userListNew){
            system.debug('@@ Audit Fields @@ ' + eachUser.CreatedDate);
            newContact = new Contact (	FirstName	=	eachUser.FirstName,
                                    	  LastName	=	eachUser.LastName,
                                      	Email		=	eachUser.Email,
                                     	  User_Name__c=	eachUser.Username,
                                      	Title		=	eachUser.Title,
                                      	Department	=	eachUser.Department,
                                      	Phone		=	eachUser.Phone,
                                      	MobilePhone	= 	eachUser.MobilePhone,
                                      	isActive__c =	eachUser.IsActive,
                                      	User_Id__c 	= 	eachUser.Id
                                      	//MailingAddress= eachUser.Address
                                      	);
            
            toInsertContacts.add(newContact);     
        }
            insert toInsertContacts;   
        } 
    //}
    
    /* public static void OnAfterUpdate(List <User> userListUpdate){
      List <Contact> toUpdateContact = new List <Contact>();
      for(User eachUser : userListUpdate){
           Contact getContact = [SELECT Id FROM Contact WHERE User_Id__c = :eachUser.Id];
            if(getContact.size() > 0){
                getContact.FirstName = eachUser.FirstName;
                getContact.LastName = eachUser.LastName;
                    getContact.Email =	eachUser.Email;
                    getContact.User_Name__c = eachUser.Username;
                    getContact.Title =	eachUser.Title;
                    getContact.Department =	eachUser.Department;
                    getContact.Phone =	eachUser.Phone;
                    getContact.MobilePhone = eachUser.MobilePhone;
                    getContact.isActive__c = eachUser.IsActive;
                    getContact.User_Id__c = eachUser.Id;
                    //getContact.MailingAddress= eachUser.Address;
                    }
          	else{
            	  getContact = null;
          	}
          Update getContact;
    	}
	} */
}