@isTest
private class ControllersTest {
	
	static testMethod void testOfferings() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];

		Test.startTest();
	    ApexPages.StandardController std = new ApexPages.StandardController(acc);
	    OfferingMapController oObj = new OfferingMapController(std);
	    
	    Test.stopTest();
	}

	static testMethod void testOrgChart() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];

		Test.startTest();
		ApexPages.StandardController std = new ApexPages.StandardController(acc);
	    OrgChartController oObj = new OrgChartController(std);
	    Contact[] contacts = OrgChartController.loadCharts(acc.Id);
	    Test.stopTest();
	}

	static testMethod void testReach() {
		TestData.createTestData();
		Account acc = [Select Id From Account Where Name='ParentAccount' limit 1];

		Test.startTest();
	    
	    ApexPages.StandardController std = new ApexPages.StandardController(acc);
	    ReachMapController rObj = new ReachMapController(std);
	    
	    PageReference pageRef = Page.ReachMap;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);

        list<ContactHelper.StatusCount> counts = rObj.getStatusCounts();
        list<ContactHelper.StatusCount> racounts = ReachMapController.loadCharts(acc.Id);
	    
	    Test.stopTest();
	}
	
}