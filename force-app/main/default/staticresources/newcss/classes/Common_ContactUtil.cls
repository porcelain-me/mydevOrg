//1/8/2013 UV : created this class.
//2/28/2013 UV : updated prefix of CIS ID.
public with sharing class Common_ContactUtil {
    
    public static String firstName = 'TestUtil_Contact';
    public static String lastName = 'Name';
    static String CIS_ID = '@!' + Math.mod(Math.abs(Crypto.getRandomInteger()),1000);
    static String tradingNameId = 'I' + Datetime.now().format('mmss');
    static String contactKey = 'cI' + Datetime.now().format('mmss');
    static String Phone  = '1234567890';
    static String MobilePhone = '+91-123456789200';
    static String email = 'test@test.com';
    static String OtherCountry = 'Test Country';
    static String OtherPhone = 'Test Phone';      
    static String OtherPostalCode = 'Test code';
    static String OtherStreet = 'Test street';
    
    public static GPSContact__c createContact(String accId, Integer indx) {
        // populate GPSContact__c with required fields only
        GPSContact__c con = new GPSContact__c(); 
        con.Name = firstName + ' ' + lastName;
        con.firstName__c = firstName;
        con.lastName__c = lastName;
        con.Account_Name__c = accId;
		con.GPSAccount__c = accId ;
        con.Trading_Name_ID__c = tradingNameId  +indx;
        con.TN_Contact_Key__c = contactKey + indx;
        con.CIS_Contact_ID__c = CIS_ID  + indx;
        con.Active_Flag__c = true;
        return con;
    } 
    
    
    
    public static GPSContact__c createContact(String accId,Integer indx, String languagePreference) {
        // populate GPSContact__c with phone and language.
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx);
        con.Phone__c = Phone;
        con.Mobile__c = MobilePhone;
        con.Language_Preference__c = languagePreference;
        con.II_Language__c = languagePreference;
        return con;
    }
    
    public static GPSContact__c createContact(String accId, Integer indx, String languagePreference, String usrEmail) {
         // populate GPSContact__c with language and email.
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx, languagePreference);
        con.Email__c = usrEmail;
        return con; 
    }
    
    public static GPSContact__c createContact(String accId,Integer indx, boolean rematchingInterest) {
        // populate GPSContact__c with rematching Interest.
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx);
        //con.Rematching_Interests__c = rematchingInterest;
        return con;
    }
    
    public static GPSContact__c createContact(String accId,Integer indx, Id recordTypeId) {
        // populate GPSContact__c with record type.
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx);
        con.RecordTypeId = recordTypeId;
        return con;
    }
    
    public static GPSContact__c createContact(String accId, String city, Integer indx) {
        // populate GPSContact__c with address
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx);
       /* con.OtherCity = city;
        con.OtherCountry = OtherCountry;
        con.OtherPhone = OtherPhone;
        con.OtherPostalCode = OtherPostalCode; 
        con.OtherState = 'OtherState';
        con.OtherStreet = OtherStreet;*/
        return con;
    }
    
    public static GPSContact__c createContact(Integer indx, String accId) {
        //populate GPSContact__c with phone numbers.
        GPSContact__c con = new GPSContact__c(); 
        con = Common_ContactUtil.createContact(accId, indx,'English Only', email);
        con.Prefer_Business_Phone__c = '+91-123456789000';
        con.Prefer_Mobile_Phone__c = '+91-123456789000';
        con.HomePhone__c = '+91-123456789000';
        //con.OtherPhone = '+91-123456789000';
       // con.AssistantPhone = '+91-123456789000';
        return con;
    }
    
     
    
}