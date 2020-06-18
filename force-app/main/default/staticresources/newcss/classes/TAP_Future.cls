global class TAP_Future {
	
	@future 
	public static void activateUser(String uId) { 
    	 
    	User u = [select id from user where id = :uId];
    	u.isActive = true;
    	update u;
    	
    	system.resetPassword(u.id, true);
        
	}
	
	
	
}