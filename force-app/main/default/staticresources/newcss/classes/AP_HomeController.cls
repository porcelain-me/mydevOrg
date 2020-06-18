/******************************************************************************************
* Annual Pledge
*
* ChangeLog:
*
*   9/30/15- Created by Mark R. Moser
*   
*   
*******************************************************************************************/
public class AP_HomeController { 
    //Public
    public String getJSStart() { return '<script>document.write('; } public String getJSEnd() { return ')</script>'; }
    public List<wrapGiving> wList {get;set;}    
    public List<wrapTotal> tList {get;set;}    
    public String currentYear {get;set;}  
    public String currencyAbrev {get;set;}
    public string errorclass {get;set;}
    public String nextYear {get;set;}
    public String monthStart {get;set;}
    public String dayStart {get;set;}
    public String monthEnd {get;set;}
    public String dayEnd {get;set;}
    public String payrollContact {get;set;}
    public Boolean openSeason {get;set;}
    public Boolean dataChanged {get;set;}
    public Boolean saveMessage {get;set;}
    public Employee__c e {get;set;}
    public User u {get;set;}
    public Boolean showPopup {get;set;}
    public Boolean showSave {get;set;}
    public Boolean selectedEmail{get;set;}
    public Decimal totalDonation {get;set;}
    public String totalDonationFormatted {get;set;}
    public Integer row {get;set;}
    public String rowValue {get;set;}
    public Boolean preTax {get;set;}
    public Boolean postTax {get;set;}
   
    //Private
    List<Charity__c> cList;
    List<Employee_Giving__c> gList;
    Decimal lineTotal;
    Boolean inputError;
    
    /*****************************************************************************************************************************
    *CONSTRUCTOR 
    *
    ****************************************************************************************************************************/
    public AP_HomeController(){ 
        
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');
        
       
        String sp = system.currentPageReference().getParameters().get('showpopup');
        if (sp == 'true')
            showPopup = true;
            
        nextYear = String.valueOf(date.today().addYears(1).year());
        
        inputError = false;
        totalDonation = 0;
        
        dataChanged = false;
        saveMessage=false;
        
        u = [select id, emp_id__c, email from User where id = :userInfo.getUserId()];
        
        e = [select id
            , name
            , EMPL_CLASS_JOB__C
            , Allow_Email_To_Charity__c
            , Job_Country_Job__c from Employee__c where emp_id__c = :u.emp_id__c];
        
        
        selectedEmail = e.allow_email_to_charity__c;
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(1,'January');
        monthMap.put(2,'February');
        monthMap.put(3,'March');
        monthMap.put(4,'April');
        monthMap.put(5,'May');
        monthMap.put(6,'June');
        monthMap.put(7,'July');
        monthMap.put(8,'August');
        monthMap.put(9,'September');
        monthMap.put(10,'October');
        monthMap.put(11,'November');
        monthMap.put(12,'December');
        
        date startDate, enddate;
        
        date myDate = date.valueOf(system.label.ap_start_date);
        monthStart = monthMap.get(myDate.month());
        dayStart = string.valueOf(myDate.day());
        
        startDate = myDate;
        
        myDate = date.valueOf(system.label.ap_end_date);
        monthEnd = monthMap.get(myDate.month());
        dayEnd = string.valueOf(myDate.day());
        
        endDate = myDatE;
         
        currentYear = string.valueOf(myDate.year());      
        
        openSeason = false;
        
        if (system.today() >= startDate && system.today() <= endDate){
            openSeason = true;
            loadTable();
    
        }
        
        OrgWideEmailAddress p = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Annual Appeal'];
        
        payrollContact = 'mailto:' + p.address; 
        
        if (wList != null){
            totalDonation = 0;
            for (wrapGiving w:wList) {
                if (w.g.amount__c != null)
                    totalDonation += w.g.amount__c;
            }
        }
        
        totalDonationFormatted = string.valueOf(totalDonation.format());
        tList = new List<wrapTotal>();
        tList.add(new wrapTotal(string.valueOf(totalDonation)));
    }
   
    /*****************************************************************************************************************************
    * LOAD TABLE 
    *
    *****************************************************************************************************************************/
    public void loadTable(){
        
        
        
        cList = [Select   c.Website__c
                        , c.Payroll_Contact__c
                        , c.payroll_contact__r.email__c
                        , c.Name
                        , c.Mission__c
                        , c.Minimum_Donation__c
                        , c.Id
                        , c.Donation_Increment__c
                        , c.CurrencyIsoCode
                        , c.Country__c 
                        , c.Contact_Name__c
                        , c.Address__c
                        , c.Active__c 
                        , c.logo_url__c
                        , c.tax__c
                From Charity__c c
                where country__c = :e.Job_Country_Job__c
                and 
                active__c = true
                order by name];
                
        if (cList.isEmpty())
            showSave = false;
        else
            showSave = true;
            
        if (e.EMPL_CLASS_JOB__C <> 'A')
            showSave = false;
        
        if (cList.isEmpty()){
            preTax = true;
            postTax = false;
        }
        else{
            if (clist[0].tax__c == 'PostTax'){
                postTax = true;
                preTax = false;
            }
            else{
                preTax = true;
                postTax = false;
            }
                
        }
        system.debug('current year is: ' + currentYear);
        glist = [Select e.Year__c, e.Name, e.Employee__c, e.Charity__c, e.Amount__c, amount_text__c
                 From Employee_Giving__c e where employee__c = :e.id
                 and year__c = :currentYear
                 and charity__r.active__c = true];
        
        Map<String,Employee_Giving__c> gMap = new Map<String,Employee_Giving__c>();
        
        Decimal total =0;
       
        for (Employee_Giving__c g:gList){
            total = total + integer.valueOf(g.amount__c);
           
            system.debug('total is: ' + total);
            gMap.put(g.charity__c,g);
        }
        
         
    
        wList = new List<wrapGiving>();    
          
        Integer i=0;
        for (Charity__c c:cList){
            wList.add(new wrapGiving(e,i,currentyear,c,gMap.get(c.id)));
            i++;
            //payrollContact = 'mailto:' + c.payroll_contact__r.email__c; 
            currencyAbrev=c.CurrencyIsoCode;        
        }  

         
    }
    
    /*****************************************************************************************************************************
    * WRAPPER CLASS 
    *
    ****************************************************************************************************************************/
    public class wrapGiving{
        
        public integer row {get;set;}
        public Charity__c    c{get;set;}
        public Employee_Giving__c g {get;set;}
        public String logoheight {get;set;}
        public String logowidth {get;set;}
       
        public Boolean error {get;set;}
        public String errorMessage {get;set;}
        public String errorClass {get;set;}
            
        public wrapGiving(Employee__c e, Integer row, String currentYear, Charity__c c, Employee_Giving__c g){
            this.row = row;
            this.c = c;
            this.errorClass = null;
            system.debug('g is: ' + g);
            if (c.logo_url__c != null && c.logo_url__c.endsWith('.svg'))
                logoheight='100';
            else
                logoheight = null;
             
            if (c.logo_url__c != null && c.logo_url__c.contains('www.fara.org.au'))
                logowidth='350';
            else
                logowidth='200';
                
   
            if (g == null){
                Employee_Giving__c temp = new Employee_Giving__c();
                temp.Year__c = currentYear;
                temp.Employee__c = e.id;
                temp.Charity__c = c.id;
                this.g = temp;
            }
            else{
                this.g = g;
                system.debug('in wrap');
                if (g.amount__c != null){
                    g.amount_text__c = string.valueOf(g.amount__c.format());
                    
                }
            }
            
        }
    }    
    
    /*****************************************************************************************************************************
    * WRAPPER CLASS TOTAL 
    *
    ****************************************************************************************************************************/
    public class wrapTotal{
        
        public String total {get;set;}
            
        public wrapTotal(String total){
            this.total = total;
        }
    }    
    
    
    
    /*****************************************************************************************************************************
    * VALIDATE INPUT 
    *
    ****************************************************************************************************************************/
    public void validateInput(){
        
        system.debug('***** validating input *********');
        
        Boolean error = false;
        for (wrapGiving w:wList){
            w.error = false;
            w.errorMessage = null; 
            
            if (w.g.amount_text__c == null && w.g.amount__c != null){
                w.g.amount_text__c = '0';
            }
                
            system.debug('***** w g amount text : '  + w.g.amount_text__c); 
            if (w.g.amount_text__c != null ){ 
                if (w.g.amount_text__c == '')   
                    continue;
                w.g.amount_text__c  = w.g.amount_text__c.replace(',','');
               
                try{
                    if (w.g.amount_text__c == '' )
                        w.g.amount_text__c = '0';
                    Long check = long.valueOf(w.g.amount_text__c);
                    if (check > 2000000000) {
                        w.errorMessage = 'Error: Please contact community affairs to donate more than 2 billion!';
                        w.error = true;
                        error = true;
                    }
                    else 
                        w.g.amount__c = check; 
                } 
                catch (Exception e) {
                        w.errorMessage = 'Error: Donation amount must be numeric and whole number!';
                        w.error = true;
                        error = true;
                }   
                 
                if (!w.error){
                    system.debug('Amount is: ' + w.g.amount__c);
                   
                    if (w.g.amount__c <  w.c.minimum_donation__c && w.g.amount__c != 0){
                        w.errorMessage = 'Error: Donation amount must be at least ' + w.c.minimum_donation__c;
                        w.error = true;
                        error=true;
                    }
                
                    if (w.c.donation_increment__c != 0){
                        Decimal r = math.mod(integer.valueOf(w.g.amount__c),integer.valueOf(w.c.donation_increment__c));
                        system.debug('**** r is: ' + r);
                    
                        if (r > 0){
                            w.errorMessage = 'Error: Donation amount must be in increments of: ' + w.c.donation_increment__c;
                            w.error = true;
                            error=true;
                        
                        }
                    }
                }    
            }
            
            system.debug('amount is: ' + w.g.amount__c + 'amount txt is:' + w.g.amount_Text__c);
            if (!w.error){
                if (w.g.amount_text__c != null)
                    w.g.amount__c = integer.valueof(w.g.amount_text__c);
                w.errorClass = null;
            }
            else
                w.errorClass = ' msgError';
                    
            system.debug('error is:' + w.errorMessage);    
        }
        
        if (error){
             
            inputError=true; 
            totalDonationFormatted = '';
        }
        else
            inputError=false;
        
         
    }
    /*****************************************************************************************************************************
    * SET MESSAGE 
    *
    */
    public pagereference dataChanged(){  
        
        dataChanged = true;
        saveMessage = false;  
        
      
        system.debug('row is:' + row);
        system.debug('row value is: ' + rowValue);
       
        if (rowValue == '')
            rowValue = '0';
            
        wList[row].g.amount_text__c = rowValue;
        try{
            wList[row].g.amount__c = integer.valueOf(rowValue);
        }
        Catch (exception e){
            
        }
        
        totalDonation = 0;
        for (wrapGiving w:wList) {
            if (w.g.amount__c != null)
                totalDonation += w.g.amount__c;
        }
        
        validateInput();
        
        for (wrapGiving w:wList) {
            if (!w.error){
                if (w.g.amount__c != null)
                    w.g.amount_text__c = w.g.amount__c.format();
            }
            if (w.g.amount_text__c == '0')
                w.g.amount_text__c = null;
                
        }
        
        if (!inputError){
            system.debug('**************** Calculating Total ****');
            totalDonation = 0;
            for (wrapGiving w:wList) {
                if (w.g.amount_text__c == null)
                    totalDonation += 0;
                else
                if (w.g.amount__c != null)
                    totalDonation += w.g.amount__c;
                    
                system.debug('total is: ' + totalDonation);
            }
            totalDonationFormatted = string.valueOf(totalDonation.format());
        }
        
        tList = new List<wrapTotal>();
        tList.add(new wrapTotal(string.valueOf(totalDonation)));
        
        
        
        return null;
                
    }
    /*****************************************************************************************************************************
    * CHOICE CHANGED 
    *
    ****************************************************************************************************************************/
    public void  choiceChanged(){  
        
        system.debug('******************* choice changed');
         
        system.debug('choice is: ' + e.allow_email_to_charity__c);
        
        if (selectedEmail == true)
            selectedEmail = false;
        else
            selectedEmail = true;
        
        e.allow_email_to_charity__c = selectedEmail;
        
        update e;
        
   
    }
    /*****************************************************************************************************************************
    * CLOSE POPUP
    *
    ****************************************************************************************************************************/
    public pageReference closePopup(){
                
        PageReference p = new PageReference('/apex/AP_Home');
        p.setRedirect(true);
        return p;  
       
    }
    /*****************************************************************************************************************************
    * WRAPPER CLASS 
    *
    ****************************************************************************************************************************/
    public pageReference save(){
        
        validateInput();
        
        if (inputError)
            return null;
            
        showPopup = true;

        
        saveMessage = true;
        List<Employee_Giving__c> iList = new List<Employee_Giving__c>();
        List<Employee_Giving__c> uList = new List<Employee_Giving__c>();
        List<Employee_Giving__c> dList = new List<Employee_Giving__c>();
        
        for (wrapGiving w:wList){
            if (w.g.amount__c == null || w.g.amount_text__c == '')
                w.g.amount__c = 0;
            if (w.g.id == null && w.g.amount__c > 0){ //new record
                Employee_Giving__c g = w.g; 
                system.debug(g);
                iList.add(g); 
            }
            
            if (w.g.id != null){
                if (w.g.amount__c > 0){ //update record
                    uList.add(w.g);
                }
                else{ //delete record
                    dList.add(w.g);         
                }
            }
            
        }
        
        if (!ilist.isEmpty())
            insert iList;
        
        if (!uList.isEmpty())
            update uList;
        
        if (!dList.isEmpty())   
            delete dList;
        
        e.allow_email_to_charity__c = selectedEmail;
        
            
        loadTable();
         
        dataChanged = false;
        
        sendConfirmationEmail();
       
        PageReference p = new PageReference('/apex/AP_Home?showpopup=true');
        p.setRedirect(true);
        return p;  
       
       
    }
     
    /*****************************************************************************************************************************
    * SEND EMAIL 
    *
    ****************************************************************************************************************************/
    public void sendConfirmationEmail(){
        
        EmailTemplate t = [select id from EmailTemplate where developername = 'AP_Confirmation'];
        
        Messaging.singleEmailMessage email = new Messaging.singleEmailMessage();
        
        OrgWideEmailAddress owe = [Select o.Id, o.DisplayName, o.Address From OrgWideEmailAddress o where displayName = 'Annual Appeal'];
        
        Contact c = new Contact (firstname = 'dog1', lastname = 'dog1', email = owe.address);
        insert c;
                    
        List<String> emailToAddresses = new List<String>();
        if (System.Label.ORG_ENVIRONMENT == 'PROD'){
            emailToAddresses.add(u.email);
            email.setTargetObjectId(u.id);        
        }
        else{
            email.setTargetObjectId(c.id);
            emailToAddresses.add(owe.address);
        }
       
        email.setOrgWideEmailAddressId(owe.id);
        email.setTemplateId(t.id);
        email.setSaveAsActivity(false);
        
        Messaging.sendEmail(new Messaging.Email[] { email } , true);
        
        delete c;
    }
}