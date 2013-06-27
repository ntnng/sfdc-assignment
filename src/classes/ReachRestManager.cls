@RestResource(urlMapping='/Account/Reach/*')
global with sharing class ReachRestManager {
  
    @HttpGet
    global static ContactHelper.StatusCount[] getReachMapByAccId() {
        RestRequest req = RestContext.request;        
        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        ContactHelper.StatusCount[] result =  ContactHelper.loadCountedRecords(accId);
        return result;
    }
}