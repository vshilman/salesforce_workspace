@isTest 
public class DataAssetControllerTest {
    static testMethod void dataAssetTestMethod() {
        
        Contact insertCon = TestDataFactory.createContact();
        insert insertCon;
        RWE_Data_Asset__c insertDataAsset = TestDataFactory.createDataAsset(insertCon.Id);
        insert insertDataAsset;
        RWE_Data_Profiler__c insertProfiler = TestDataFactory.createDataProfiler(insertDataAsset.Id);
        insert insertProfiler;
        RWE_Study__c insertStudy = TestDataFactory.createStudy(insertCon.Id);
        insert insertStudy;
        RWE_Data_Asset_Approval__c insertRequest = TestDataFactory.createRequest(insertDataAsset.Id, insertCon.Id);
        insert insertRequest;
		
		RWE_Data_Asset_Approval__c dataAssetApprovalRejection = new RWE_Data_Asset_Approval__c(	Name = insertDataAsset.Name,
																								Relevant_Contact__c = insertCon.Id,
																								Requestor__c = UserInfo.getUserId(),
																								RWE_Data_Asset__c = insertDataAsset.Id,
																								Valid_Till__c = Date.Today().addMonths(3));
		// insert dataAssetApprovalRejection;																						
        
        ApexPages.StandardController scDataAsset = new ApexPages.standardController(insertDataAsset);
        DataAssetController dataAssetCont = new DataAssetController(scDataAsset);
        dataAssetCont.FetchDataForCriteria();
        
        ApexPages.StandardController scStudy = new ApexPages.standardController(insertStudy);
        StudyListController studyCont = new StudyListController(scStudy);
        studyCont.FetchDataForCriteria();
		
		ApexPages.StandardController createApp = new ApexPages.standardController(dataAssetApprovalRejection);
        DataAssetApprovalCreationExtension createApproval = new DataAssetApprovalCreationExtension(createApp);
		PageReference pgRef = Page.DataAssetApprovalCreation; 
		Test.setCurrentPage(pgRef); 
		ApexPages.currentPage().getParameters().put('dataId', insertDataAsset.id);
		system.debug('@@ PageRef @@' + pgRef );
		dataAssetApprovalRejection = new RWE_Data_Asset_Approval__c();
        createApproval.iDataApprovalRecord();
		
		dataAssetApprovalRejection = [select id from RWE_Data_Asset_Approval__c limit 1];
        ApexPages.StandardController dataAssetApproRej = new ApexPages.standardController(dataAssetApprovalRejection);
        DataAssetApprovalRejectionExtension dataAssAppRej = new DataAssetApprovalRejectionExtension(dataAssetApproRej);
		dataAssAppRej.cLincenseActive  = true;
		dataAssAppRej.cLincenseUsage  = true;
		dataAssAppRej.cUserCredentials  = true;
		dataAssAppRej.cDataLicense  = true;
		dataAssAppRej.cRestriction  = true;
		dataAssAppRej.cFirstLevelApproval  = true;
		dataAssAppRej.cSecondLevelApproval  = true;
        dataAssAppRej.eApproveRequest();
		dataAssAppRej.eRejectRequest();
		


		
                
    }
}