public class RelatedContactTriggerHandler{

    public static boolean isFirstRun = true;
    
    public static void onBeforeInsert(list<RelatedContact__c> newRelatedContacts) {
    	setUniqueValues(newRelatedContacts);
    }
    
    public static void onAfterInsert(list<RelatedContact__c> newRelatedContacts) {
        isFirstRun = false;
        if(newRelatedContacts != null && newRelatedContacts.size() > 0) {
            list<RelatedContact__c> newRelatedContactsToInsert = new list<RelatedContact__c>();
            for(RelatedContact__c relCon : newRelatedContacts) {
            	newRelatedContactsToInsert.add(
					new RelatedContact__c(
                        FirstContact__c = relCon.SecondContact__c,
                        SecondContact__c = relCon.FirstContact__c,
                        RelationshipType__c = relCon.RelationshipType__c,
                        UniqueValue__c = relCon.SecondContact__c + '-' + relCon.FirstContact__c
					)
				);
            }
            if(newRelatedContactsToInsert.size() > 0) {
            	insert newRelatedContactsToInsert;
            }
        }
    }
    
    public static void onBeforeUpdate(list<RelatedContact__c> newRelatedContacts, map<Id, RelatedContact__c> oldRelatedContactsMap) {
    	list<RelatedContact__c> relatedContactsWithUpdatedContact = new list<RelatedContact__c>();
    	
    	for(RelatedContact__c relCon : newRelatedContacts) {
    		if(relCon.FirstContact__c <> oldRelatedContactsMap.get(relCon.Id).FirstContact__c ||
    		   relCon.SecondContact__c <> oldRelatedContactsMap.get(relCon.Id).SecondContact__c) {
    			relatedContactsWithUpdatedContact.add(relCon);
    		}
    	}
    	
    	if(relatedContactsWithUpdatedContact.size() > 0) {
            setUniqueValues(relatedContactsWithUpdatedContact);		
    	}
    }
    
    public static void onAfterUpdate(list<RelatedContact__c> newRelatedContacts, map<Id, RelatedContact__c> oldRelatedContactsMap) {
        isFirstRun = false;
        list<RelatedContact__c> updatedRelatedContacts = new list<RelatedContact__c>();
        
        for(RelatedContact__c relCon : newRelatedContacts) {
            if(relCon.UniqueValue__c <> oldRelatedContactsMap.get(relCon.Id).UniqueValue__c ||
               relCon.RelationshipType__c <> oldRelatedContactsMap.get(relCon.Id).RelationshipType__c) {
                updatedRelatedContacts.add(relCon);
            }
        }
        
        if(updatedRelatedContacts.size() > 0) {
        	map<String, RelatedContact__c> reverseUniqueValueUpdatedRcMap = new map<String, RelatedContact__c>();
            for(RelatedContact__c relCon : updatedRelatedContacts) {
            	String reverseUniqueValue = oldRelatedContactsMap.get(relCon.Id).SecondContact__c + '-' +  oldRelatedContactsMap.get(relCon.Id).FirstContact__c;
            	reverseUniqueValueUpdatedRcMap.put(reverseUniqueValue, relCon);
            }
            
            if(reverseUniqueValueUpdatedRcMap.size() > 0) {
            	list<RelatedContact__c> relatedContactsToUpdate = new list<RelatedContact__c>();
            	for(RelatedContact__c relCon : [Select Id, FirstContact__c, SecondContact__c, RelationshipType__c, UniqueValue__c
            	                                From RelatedContact__c
            	                                Where UniqueValue__c IN :reverseUniqueValueUpdatedRcMap.keySet()]) {
            		RelatedContact__c tempRelCon = reverseUniqueValueUpdatedRcMap.get(relCon.UniqueValue__c);
            		relCon.FirstContact__c = tempRelCon.SecondContact__c;
                    relCon.SecondContact__c = tempRelCon.FirstContact__c;
                    relCon.RelationshipType__c = tempRelCon.RelationshipType__c;
                    relCon.UniqueValue__c = tempRelCon.SecondContact__c + '-' + tempRelCon.FirstContact__c;
                    relatedContactsToUpdate.add(relCon);
            	}
            	
            	if(relatedContactsToUpdate.size() > 0) {
            		update relatedContactsToUpdate;
            	}
            }
        }
    }
    
    public static void onAfterDelete(list<RelatedContact__c> oldRelatedContacts) {
    	isFirstRun = false;
    	if(oldRelatedContacts <> null && oldRelatedContacts.size() > 0) {
    		set<String> uniqueValuesToCheck = new set<String>();
    		for(RelatedContact__c relCon : oldRelatedContacts) {
    			uniqueValuesToCheck.add(relCon.SecondContact__c + '-' + relCon.FirstContact__c);
    		}
    		if(uniqueValuesToCheck.size() > 0) {
    			list<RelatedContact__c> reverseRelatedContacts = [Select Id From RelatedContact__c Where UniqueValue__c IN :uniqueValuesToCheck];
    			if(reverseRelatedContacts.size() > 0) {
    				delete reverseRelatedContacts;
    			}
    		}
    	}
    }
    
    private static void setUniqueValues(list<RelatedContact__c> newRelatedContacts) {
    	if(newRelatedContacts != null && newRelatedContacts.size() > 0) {
            for(RelatedContact__c relCon : newRelatedContacts) {
                relCon.UniqueValue__c = relCon.FirstContact__c + '-' + relCon.SecondContact__c;
            }
        }
    }
}