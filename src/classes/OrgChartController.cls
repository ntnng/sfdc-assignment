public with sharing class OrgChartController {
    
    public OrgChartController(ApexPages.StandardController stdController) {
        
    }
    
    @RemoteAction   
    public static Contact[] loadCharts(String accId) {
        return ContactHelper.loadRelatedContacts(accId);
    }
}