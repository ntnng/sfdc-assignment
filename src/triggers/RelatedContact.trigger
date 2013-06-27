trigger RelatedContact on RelatedContact__c (before insert, after insert, before update, after update, after delete) {
    if(Trigger.isInsert) {
    	if(Trigger.isBefore) {
    		RelatedContactTriggerHandler.onBeforeInsert(Trigger.new);
    	}
    	if(Trigger.isAfter) {
        	if (RelatedContactTriggerHandler.isFirstRun) {
        		RelatedContactTriggerHandler.onAfterInsert(Trigger.new);
        	}
    	}
    }
   
    if(Trigger.isUpdate) {
    	if(Trigger.isBefore) {
    		RelatedContactTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    	}
    	if(Trigger.isAfter) {
            if (RelatedContactTriggerHandler.isFirstRun) {
                RelatedContactTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
   
    if(Trigger.isDelete && Trigger.isAfter) {
    	if (RelatedContactTriggerHandler.isFirstRun) {
            RelatedContactTriggerHandler.onAfterDelete(Trigger.old);
        }
    }
}