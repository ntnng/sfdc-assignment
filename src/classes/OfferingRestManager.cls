@RestResource(urlMapping='/Account/Offering/*')
global with sharing class OfferingRestManager {
  
    @HttpGet
    global static Offering__c[] getOfferingsByAccId() {
        RestRequest req = RestContext.request;        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        set<Id> offeringIds = new set<Id>();
        for(AccountOffering__c ao : [SELECT Offering__c FROM AccountOffering__c WHERE Account__c = :accId]) {
            offeringIds.add(ao.Offering__c);
        }

        list <Offering__c> result = [SELECT Name, Description__c, DrivenBy__r.Name
                                     FROM Offering__c 
                                     WHERE Id IN :offeringIds];
        return result;
    }
}