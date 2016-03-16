@RestResource(urlMapping='/Accounts/*')
global with sharing class RESTCaseController {
    @HttpGet
    global static List<Account> getAccounts() {
    String companyName = RestContext.request.params.get('companyName');
    list<Account> company = [ Select ID, Name, BillingState from Account where Name = :companyName];

    return company ;
    
  }

}