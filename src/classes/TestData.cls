@isTest
public class TestData {

	public static void createTestData() {
		Account parentAccount = new Account(Name = 'ParentAccount');
		insert parentAccount;
		Account childAccount = new Account(Name = 'ChildAccount', ParentId = parentAccount.Id);
		insert childAccount;

		Contact paContact1, caContact1;
		insert new list<Contact> {
			paContact1 =  new Contact(FirstName='Manager', LastName='ParentAccount', AccountId=parentAccount.Id, Title='Manager', Status__c='Unaware'),
			caContact1 =  new Contact(FirstName='Manager', LastName='ChildAccount', AccountId=childAccount.Id, Title='Manager', Status__c='Unaware')
		};

		insert new list<Contact> {
			new Contact(FirstName='Junior', LastName='ParentAccount', AccountId=parentAccount.Id, Title='Junior', ReportsToId=paContact1.Id, Status__c='Unaware'),
			new Contact(FirstName='Junior', LastName='ChildAccount', AccountId=childAccount.Id, Title='Junior', ReportsToId=caContact1.Id, Status__c='Unaware')
		};

		insert (new RelatedContact__c(FirstContact__c=paContact1.Id, SecondContact__c=caContact1.Id, RelationshipType__c='Friend'));

		Offering__c offering1, offering2;
		insert new list<Offering__c> {
			offering1 = new Offering__c(Name='Offering 1', Description__c='First', DrivenBy__c=UserInfo.getUserId()),
			offering2 = new Offering__c(Name='Offering 2', Description__c='Second', DrivenBy__c=UserInfo.getUserId())
		};

		insert new list<AccountOffering__c> {
			new AccountOffering__c(Account__c=parentAccount.Id, Offering__c=offering1.Id),
			new AccountOffering__c(Account__c=parentAccount.Id, Offering__c=offering2.Id),
			new AccountOffering__c(Account__c=childAccount.Id, Offering__c=offering2.Id)
		};
	}
}