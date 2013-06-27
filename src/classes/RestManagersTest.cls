@isTest
private class RestManagersTest {
	
	static testMethod void testReachGet() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];

		Test.startTest();
	    RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
	    req.requestURI = 'https://ap1.salesforce.com/services/apexrest/Account/Reach/'+acc.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

	    ContactHelper.StatusCount[]  results = ReachRestManager.getReachMapByAccId();
	    Test.stopTest();
	}

	static testMethod void testOrgChartGet() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];
		
		Test.startTest();
	    RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
	    req.requestURI = 'https://ap1.salesforce.com/services/apexrest/Account/OrgChart/'+acc.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

	    Contact[]  results = OrgRestManager.getOrgChartByAccId();
	    Test.stopTest();
	}

	static testMethod void testOfferingGet() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];
		
		Test.startTest();
	    RestRequest req = new RestRequest(); 
    	RestResponse res = new RestResponse();
	    req.requestURI = 'https://ap1.salesforce.com/services/apexrest/Account/Offering/'+acc.Id;  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

	    Offering__c[]  results = OfferingRestManager.getOfferingsByAccId();
	    Test.stopTest();
	}
}