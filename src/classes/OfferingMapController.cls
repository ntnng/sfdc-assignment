public with sharing class OfferingMapController {
    
    public transient map<Id, Offering__c> offeringMap {get; set;}
    public transient list<AccountOffering> accountOfferings {get; set;}

    public OfferingMapController(ApexPages.StandardController stdController) {
    	Id accId = stdController.getId();
        accountOfferings = new list<AccountOffering>();
        offeringMap = new map<Id, Offering__c>();
    	if(accId <> null) {
            map<Id, Account> accountMap = new map<Id, Account>();
            map<Id, map<Id, Boolean>> accountOfferingCheckMap = new map<Id, map<Id, Boolean>>();
            set<Id> accountIds = new set<Id>();
            map<Id, Account> childAccounts = new map<Id, Account>([Select Id From Account Where ParentId = :accId]);
            accountIds.add(accId);
            accountIds.addAll(childAccounts.keySet());
            for(AccountOffering__c ao : [Select Id, Account__c, Account__r.Name, 
                                         Offering__c, Offering__r.Name
                                         From AccountOffering__c
                                         Where Account__c IN :accountIds]) {
                if(!offeringMap.containsKey(ao.Offering__c)) {
                    offeringMap.put(ao.Offering__c, ao.Offering__r);
                }
                if(!accountMap.containsKey(ao.Account__c)) {
                    accountMap.put(ao.Account__c, ao.Account__r);
                }
                if(accountOfferingCheckMap.containsKey(ao.Account__c)) {
                    map<Id, Boolean> tempOfferingCheckMap = accountOfferingCheckMap.get(ao.Account__c);
                    tempOfferingCheckMap.put(ao.Offering__c, true);
                } else {
                    accountOfferingCheckMap.put(ao.Account__c, new map<Id, Boolean>{ao.Offering__c => true});
                }
            }

            if(accountOfferingCheckMap.size() > 0) {
                for(Id aId : accountOfferingCheckMap.keySet()) {
                    map<Id, Boolean> tempOfferingCheckMap = accountOfferingCheckMap.get(aId);
                    for(Id oId : offeringMap.keySet()) {
                        if(!tempOfferingCheckMap.containsKey(oId)) {
                            tempOfferingCheckMap.put(oId, false);
                        }
                    }
                    accountOfferings.add(new AccountOffering(accountMap.get(aId), tempOfferingCheckMap));
                }
            }
        }
    }

    public class AccountOffering{
        public Account acc {get; set;}
        public map<Id, Boolean> oaMap {get; set;}
        public AccountOffering(Account acc, map<Id, Boolean> oaMap) {
            this.acc = acc;
            this.oaMap = oaMap;
        }
    }
}