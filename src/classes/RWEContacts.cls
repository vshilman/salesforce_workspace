public with sharing class RWEContacts {

    
    public List<Contact> allContacts{get; set;}

    public RWEContacts () {
        allContacts= [SELECT Id,Email,FirstName,LastName,Phone FROM Contact ORDER BY CreatedDate DESC NULLS LAST];
    }

}