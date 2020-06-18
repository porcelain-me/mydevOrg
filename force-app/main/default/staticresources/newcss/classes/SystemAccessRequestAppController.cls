public class SystemAccessRequestAppController {
    @AuraEnabled
    public static List<System_Access_Request__c> getEmployeeRequests() {
		List<System_Access_Request__c> requests = [SELECT Id, Application__c, App_Permissions__c, Duration__c, Status__c FROM System_Access_Request__c];
        return requests;
    }

    @AuraEnabled
    public static Map<String,List<String>> getApplicationDetail() {
		List<App_Permission__c> permissions = [SELECT Name, Application__r.Name FROM App_Permission__c ORDER BY Application__r.Name, Name ASC];
        Map<String,List<String>> permissionMap = new Map<String,List<String>>();
        if(!permissions.isEmpty()) {
            for(App_Permission__c appPerm : permissions) {
                If(permissionMap.containsKey(appPerm.Application__r.Name)) {
                    List<String> appPermList = permissionMap.get(appPerm.Application__r.Name);
                    appPermList.add(appPerm.Name);
                    permissionMap.put(appPerm.Application__r.Name,appPermList);
                }
                else {
                    List<String> appPermList = new List<String>();
                    appPermList.add(appPerm.Name);
                    permissionMap.put(appPerm.Application__r.Name,appPermList);
                }
            }
        }
        return permissionMap;
    }
    
    @AuraEnabled
    public static void createRequest() {
		List<System_Access_Request__c> requests = new List<System_Access_Request__c>();
        
    }
}