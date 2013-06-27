@RestResource(urlMapping='/Account/OrgChart/*')
global with sharing class OrgRestManager {
  
    @HttpGet
    global static Contact[] getOrgChartByAccId() {
        RestRequest req = RestContext.request;        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Contact[] result = ContactHelper.loadRelatedContacts(accId);
        return result;
    }
}