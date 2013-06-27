global with sharing class ContactHelper {

    global static list<StatusCount> loadCountedRecords(String accId) {
        list<StatusCount> tempStatusCounts = new list<StatusCount>();
        if(accId <> null) {
            map<String, Integer> statusCountMap = new map<String, Integer>();
            for(Contact con : [SELECT Id, Status__c FROM Contact WHERE AccountId = :accId]) {
                if(!statusCountMap.containsKey(con.Status__c)) {
                    statusCountMap.put(con.Status__c, 1);
                } else {
                    Integer currentCount = statusCountMap.get(con.Status__c);
                    statusCountMap.put(con.Status__c, currentCount + 1);
                }
            }
            
            if(statusCountMap.size() > 0) {
                for(String status : statusCountMap.keySet()) {
                    tempStatusCounts.add(new StatusCount(status, statusCountMap.get(status)));
                }
            }
        }
        return tempStatusCounts;
    }
    
    global static list<Contact> loadRelatedContacts(String accId) {
    	list<Contact> tempContacts= new list<Contact>();
    	if(accId <> null) {
    		tempContacts = [SELECT Id, Name, Title, ReportsToId, ReportsTo.Name 
                            FROM Contact 
                            WHERE AccountId = :accId
                            ORDER BY ReportsToId NULLS FIRST];
    	}
    	return tempContacts;
    }
    
    global class StatusCount {
        global String status {get; set;}
        global Integer count {get; set;}
        global StatusCount(String status, Integer count) {
            this.status = status;
            this.count = count;
        }
    }
}