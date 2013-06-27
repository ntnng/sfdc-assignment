public with sharing class ReachMapController {
    
    public ReachMapController(ApexPages.StandardController stdController) {
        
    }
    
    public list<ContactHelper.StatusCount> getStatusCounts() {
        Id accId = ApexPages.currentPage().getParameters().get('Id');
        return ContactHelper.loadCountedRecords(accId);
    }
    
    @RemoteAction   
    public static ContactHelper.StatusCount[] loadCharts(String accId) {
    	return ContactHelper.loadCountedRecords(accId);
    }
}