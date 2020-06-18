public class SystemAccessRevocationManager {

    @InvocableMethod(label='Revoke System Accesses' description='Revoke system accesses to a user/employee as defined by the relative system access request/grant records')
	public static void revokeSystemAccess(List<System_Access_Grant__c> systemAccessGrants) {
        for(System_Access_Grant__c grant : systemAccessGrants) {
            
        }
    }
}