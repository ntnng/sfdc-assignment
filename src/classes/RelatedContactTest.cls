@isTest
private class RelatedContactTest {
	
	static testMethod void testRelatedContactsInsert() {
		TestData.createTestData();
		list<Contact> contacts = [Select Id From Contact Where FirstName='Junior' limit 10];

		Test.startTest();

	    insert new RelatedContact__c(FirstContact__c=contacts[0].Id, SecondContact__c=contacts[1].Id, RelationshipType__c='Friend');

	    Test.stopTest();
	}
	
	static testMethod void testRelatedContactsUpdate1() {
		TestData.createTestData();
		list<Contact> contacts = [Select Id From Contact Where FirstName='Junior' limit 10];
		RelatedContact__c rc1 = [Select Id, FirstContact__c, SecondContact__c, RelationshipType__c From RelatedContact__c limit 1];
		
		Test.startTest();
		
		RelatedContactTriggerHandler.isFirstRun = true;
	    rc1.SecondContact__c = contacts[0].Id;
	    update rc1;

	    Test.stopTest();
	}

	static testMethod void testRelatedContactsUpdate2() {
		TestData.createTestData();
		RelatedContact__c rc1 = [Select Id, FirstContact__c, SecondContact__c, RelationshipType__c From RelatedContact__c limit 1];
		
		Test.startTest();

		RelatedContactTriggerHandler.isFirstRun = true;
	    rc1.RelationshipType__c = 'Competitor';
	    update rc1;

	    Test.stopTest();
	}

	static testMethod void testRelatedContactsDelete() {
		TestData.createTestData();
		RelatedContact__c rc1 = [Select Id, FirstContact__c, SecondContact__c, RelationshipType__c From RelatedContact__c limit 1];
		
		Test.startTest();
		RelatedContactTriggerHandler.isFirstRun = true;
	    delete rc1;

	    Test.stopTest();
	}
}