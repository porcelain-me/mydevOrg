global with sharing class AngularTableController {
    public String userName {get;set;}

    public String minDate {get;set;}
    public String maxDate {get;set;}
    public String year{get;set;}
    public String month{get;set;}
    public String day{get;set;}
    public Boolean showMenu {get;set;}
    
    public String requester {get;set;}
    public String location {get;set;}
    public String dateoforder {get;set;}
    public String pickuptime {get;set;}
    public ApexPages.StandardSetController con{get; set;} 
    private Map<Id, FOODS_Wrapper> tempWrapperMap = new Map<Id, FOODS_Wrapper>();
       
    public Date todayDate {get;set;}
    private Map<String, Decimal> selectedMap;
    
    public Decimal totalPrice{get;set;}
    
    public Order__c ord{get;set;}
    
    public Boolean isAdmin{get;set;}
    
    public Category__c c{get;set;}
    
    public void getUserDetails(){
        
        Integer lmt = Limits.getLimitQueryRows();
        try{
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT id, Name, Date__c, Food_Items__c, OrderLocation__c, Pickup_Time__c, Quantity__c, Requestor__c, Total_Price__c, Cancelled__c FROM Order__c WHERE Requestor__c=:requester AND Cancelled__c <> TRUE ORDER BY Date__c ASC LIMIT: lmt]));
            
            if(con.getRecords().isEmpty()){
                con = null;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'No Records are there to Display.'));
            }
            else
                // sets the number of records in each page set   
                con.setPageSize(10);
       
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.Info, 'Error: '+e.getMessage()));
        }
    
    } // END public void getUserDetails()
    
    public List<Order__c> orderList
    {   
        get   
        {   
            if(con != null){   
                return (List<Order__c>)con.getRecords();
            }
            else{  
                return null ;   
            }
        }   
        set;
    }  
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    /* returns the first page of records */
    public void first() {
        try{
            con.first();
            // result.success = true;
        }catch(Exception e){
            // result.success = true;
            // result.message = Label.CS_ErrorMessage;
        }
    }

    /* returns the last page of records */
    public void last() {
        try{
            con.last();
            // result.success = true;
        }catch(Exception e){
            // result.success = true;
            // result.message = Label.CS_ErrorMessage;
        }

    }

    /* returns the previous page of records */
    public void previous() {
        try{
            con.previous();
            // result.success = true;
        }catch(Exception e){
            // result.success = true;
            // result.message = Label.CS_ErrorMessage;
        }
    }

    /* returns the next page of records */
    public void next() {
        try{
            con.next();
            // result.success = true;
        }catch(Exception e){
            // result.success = true;
            // result.message = Label.CS_ErrorMessage;

        }
    }
    
    
    
    public AngularTableController() {
    
        if([SELECT Id, Name FROM Profile WHERE Id=: userinfo.getProfileId()][0].Name.toLowerCase().contains('admin'))    
            isAdmin = true;
        else
            isAdmin = false;
        c = new Category__c();
        totalPrice = 0.0;
        todayDate = Date.today();
        showMenu = false; // TODO false to be made
       userName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
       Date todayDate = Date.today();
       minDate = todayDate.year()+'-'+todayDate.month()+'-'+todayDate.day();
       year = ''+todayDate.year();
       month = ''+todayDate.month();
       day = ''+todayDate.day();
       maxDate = todayDate.year()+'-12-31';
       location = getLocations().get(0).getValue();
       pickuptime = getPickupTimes().get(0).getValue();
       // requester = userName;
       dateoforder = todayDate.year()+'-'+todayDate.month()+'-'+todayDate.day();
       wrapperMap = new Map<Id, FOODS_Wrapper>();
        // system.debug('req: '+ApexPages.currentPage().getParameters().get('nickName')+' location: '+location + ' dateoforder: '+dateoforder+' pickuptime: '+pickuptime );
        // system.debug('Requester '+ApexPages.currentPage().getParameters().get('requester') + ' Location '+ApexPages.currentPage().getParameters().get('location') + ' Date of Order '+ApexPages.currentPage().getParameters().get('dateoforder') + ' Pick up time '+ApexPages.currentPage().getParameters().get('pickuptime') );
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap));
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+[ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c WHERE Cafeteria_Location__r.Name like: ApexPages.currentPage().getParameters().get('location')]));
        for( Category__c cat: [ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c] ){
            if( !cat.SubCategories__r.isEmpty() ){
                List<FOODS_tempWrapper> foodsWrapper = new List<FOODS_tempWrapper>();
            
                for(Subcategory__c sub: cat.SubCategories__r){
                    foodsWrapper.add(new Foods_tempWrapper(sub, 0));
                }
            
                // wrapperMap.put(cat.Id, new FOODS_Wrapper(cat, foodsWrapper) );
                
            }
        }
       
       selectedMap = new Map<String, Decimal>();
       
    }

    public String v_sobjectName     {get;set;}
    public String v_fieldSetName    {get;set;}
    public String v_fieldCsv        {get;set;}

    
    
    public List<String> getFields(){

        List<String> fields = new List<String>();
            
        if(v_fieldSetName != null && v_fieldSetName != ''){
            
            Schema.FieldSet fieldSet;

            for(Schema.FieldSet fSet : Schema.getGlobalDescribe().get(v_sobjectName).getDescribe().fieldSets.getMap().values()){
                if(fSet.getLabel().equalsIgnoreCase(v_fieldSetName)){
                    fieldSet = fSet;
                    break;
                }
            }

            if(fieldSet == null)
                throw new AngularException('Fieldset name provided is not found');

            for(Schema.FieldSetMember fm : fieldSet.getFields()){
                fields.add(fm.getFieldPath());
            }


        }else if(v_fieldCsv != null && v_fieldCsv != ''){
            for(String s : v_fieldCsv.split(',')){
                fields.add(s.trim());
            }

        }else{
            throw new AngularException('Either Fieldset or FieldCSV must be supplied');
        }

        return fields;
    }

    
    public Map<String,String> getfieldLabelMap(){
        return getFieldLabelMap(v_sobjectName); // returns the Map of Field Labels.
    }

    public List<String> getfieldList(){
        List<String> fields = new List<String>();
        for(String s : v_fieldCsv.split(','))
            fields.add(s.trim());

        return fields;    
    }
    
    public List<SelectOption> getLocations(){
        // return new List<String>{'1585 Broadway', '1 NY Plaza', '522 Fifth Ave', '750 7th Ave'};
        List<SelectOption> toReturn =  new List<SelectOption>();
        for(Cafeteria_Location__c cl: [SELECT Name FROM Cafeteria_Location__c LIMIT 5000]){
            toReturn.add(new SelectOption(cl.Name, cl.Name));
        }
        return toReturn;
    }

    public List<SelectOption> getPickupTimes(){
        // return new List<String>{'11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45','13:00', '13:15', '13:30', '13:45', '14:00', '14:15', '14:30', '14:45', '15:00', '15:15', '15:30', '15:45','16:00'};
    
        return new List<SelectOption>{ new SelectOption('11:00', '11:00'), new SelectOption('11:15', '11:15'), new SelectOption('11:30', '11:30'), new SelectOption('11:45', '11:45'), new SelectOption('12:00', '12:00'), new SelectOption('12:15', '12:15'), new SelectOption('12:30', '12:30'), new SelectOption('12:45', '12:45'), new SelectOption('13:00', '13:00'), new SelectOption('13:15', '13:15'), new SelectOption('13:30', '13:30'), new SelectOption('13:45', '13:45'), new SelectOption('14:00', '14:00'), new SelectOption('14:15', '14:15'), new SelectOption('14:30', '14:30'), new SelectOption('14:45', '14:45'), new SelectOption('15:00', '15:00'), new SelectOption('15:15', '15:15'), new SelectOption('15:30', '15:30'), new SelectOption('15:45', '15:45'), new SelectOption('16:00', '16:00')};
    }

    /**
     * Remoting method to get the fieldLabMap for any SObject, basically would return labels to show on a Table
     * @param sobjectName - Salesforce SObjectName
     * @return Map<String,String> 
     */

    @RemoteAction
    global static Map<String,String> getFieldLabelMap(String sobjectName){
        Map<String, String> fieldLabelMap       = new Map<String, String>();
        Map<String, Schema.SObjectField> FsMap  = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();
        
        for(String field : FsMap.keySet()){
                fieldLabelMap.put(
                FsMap.get(field).getDescribe().getName(),
                FsMap.get(field).getDescribe().getLabel());
        }
        
        return fieldLabelMap;
    }

    /**
     * Remoting method to getAllRecords
     * @param sobjectName - Salesforce SObjectName
     * @return List<SObject>
     */

    @RemoteAction
    global static List<SObject> getAllRecords(String sobjectName, String fieldSetName, String fieldCsv){

        List<SObject> records = new List<SObject>();

        if(fieldSetName == null && fieldCsv == null){
            throw new AngularException('Either FieldSet Name or FieldCSV must be provided');
        }

        String selectorCsv = '';
        if(fieldSetName != null && fieldSetName != ''){
            
            Schema.FieldSet fieldSet;
            // Get the fieldset based on the Name 
            for(Schema.FieldSet fSet : Schema.getGlobalDescribe().get(sobjectName).getDescribe().fieldSets.getMap().values()){
                if(fSet.getLabel().equalsIgnoreCase(fieldSetName)){
                    fieldSet = fSet;
                    break;
                }
            }

            if(fieldSet == null)
                throw new AngularException('Fieldset name provided is not found');

            for(Schema.FieldSetMember fm : fieldSet.getFields()){
                selectorCsv += fm.getFieldPath() + ',';
            }
        }else{
            selectorCsv = fieldCsv;
        }

        selectorCsv = selectorCsv.removeEnd(','); 

        // Add the Id if Selector does not contain Id.
        if(!selectorCsv.containsIgnoreCase('id'))
            selectorCsv = 'Id, ' + selectorCsv; 

        records =  Database.query('Select ' + selectorCsv + ' from ' + sobjectName + ' LIMIT 2000'); 
        
        return records;
    
    }

    public class AngularException extends Exception {}


    //////////////////////////// NEW LOGIC /////////////////////////////
    public PageReference GetSelected() {
        return null;
    }

    public Boolean selected {get;set;}

    public Map<Id, FOODS_Wrapper> wrapperMap {get;set;}
    
    public PageReference FOOD_showMenu() {
        if(requester == NULL || String.isEmpty(requester))
            return NULL;
    
        showMenu = true;
        wrapperMap = new Map<Id, FOODS_Wrapper>();
        // system.debug('req: '+ApexPages.currentPage().getParameters().get('nickName')+' location: '+location + ' dateoforder: '+dateoforder+' pickuptime: '+pickuptime );
        // system.debug('Requester '+ApexPages.currentPage().getParameters().get('requester') + ' Location '+ApexPages.currentPage().getParameters().get('location') + ' Date of Order '+ApexPages.currentPage().getParameters().get('dateoforder') + ' Pick up time '+ApexPages.currentPage().getParameters().get('pickuptime') );
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap));
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+[ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c WHERE Cafeteria_Location__r.Name like: ApexPages.currentPage().getParameters().get('location')]));
        for( Category__c cat: [ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c WHERE Cafeteria_Location__r.Name like: location] ){
            if( !cat.SubCategories__r.isEmpty() ){
                List<FOODS_tempWrapper> foodsWrapper = new List<FOODS_tempWrapper>();
            
                for(Subcategory__c sub: cat.SubCategories__r){
                    foodsWrapper.add(new Foods_tempWrapper(sub, 0));
                }
                wrapperMap.put(cat.Id, new FOODS_Wrapper(cat, foodsWrapper) );
            }
        }
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Requester '+requester + ' Location '+location + ' Date of Order '+dateoforder + ' Pick up time '+pickuptime   ));
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap));
        PageReference menuPage = null;
        if(dateoforder <> NULL){
            menuPage = new PageReference('/apex/FOODS_Menu');
            menuPage.setRedirect(false);
        }
        return menuPage;
        
    }

    public PageReference FOODS_save(){
        List<Subcategory__c> subcategoriesToSave = new List<Subcategory__c>();
        
        List<Category__c> catToUpdate = new List<Category__c>();
        List<Category__c> catList;
        if(selectedMap.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'Please select at least one value from the Categories.'));
            return null;
        } else{
            Map<Id, FOODS_Wrapper> wrapperMapUpdated = new Map<Id, FOODS_Wrapper>();
            
            // Map<Category__c, List<Subcategory__c>> tempMap = new Map<Category__c, List<Subcategory__c>>();
            
            Map<Category__c, List<FOODS_tempWrapper>> tmpMap = new Map<Category__c, List<FOODS_tempWrapper>>();
            
            
            for( String selectedKey: selectedMap.keySet() ) {
                String[] selectedRecs = selectedKey.split('>');
                String[] selectedSubCat = selectedKey.split('=');
                system.debug(selectedSubCat);
                String[] subCatData = selectedKey.split(';');
                // system.debug('new id: '+selectedRecs[0].replace('\'','');
                Category__c cat = new Category__c(
                                                    Id = selectedRecs[0].replace('\'',''),
                                                    Name = selectedRecs[1].split('-')[0]
                                                );
                Subcategory__c subCat = new Subcategory__c(
                                                    Id = selectedSubCat[0].split('-')[1],
                                                    Name = subCatData[0].split('=')[1],
                                                    Price__c = Decimal.valueOf(subCatData[1])
                                                  );
                FOODS_tempWrapper tempWrapper = new FOODS_tempWrapper();
                tempWrapper.subcategory = subCat;
                tempWrapper.quantity = Integer.valueOf(selectedMap.get(selectedKey));
                totalPrice = (totalPrice + subCat.Price__c) * tempWrapper.quantity;
                if(tmpMap.containsKey(cat)){
                    List<FOODS_tempWrapper> subCatList = tmpMap.get(cat);
                    
                    // TODO
                    subCatList.add(tempWrapper);
                    tmpMap.put(cat, subCatList);
                } else{
                    List<FOODS_tempWrapper> subCatList = new List<FOODS_tempWrapper>{tempWrapper};
                    // TODO
                    tmpMap.put(cat, subCatList);
                }                             
                
                
                // tempMap.put(cat, );
            
            }
            
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'TEMPMAP: '+tmpMap));
            
            
            for(Category__c cat: tmpMap.keySet()){
                
                
                // FOODS_Wrapper fw = new FOODS_Wrapper(cat, tmpMap.get(cat));
                // fw.quantity = 
                wrapperMapUpdated.put(cat.Id, new FOODS_Wrapper(cat, tmpMap.get(cat)));
            }
            wrapperMap.clear();
            
            wrapperMap.putAll(wrapperMapUpdated);
            
        }
        
        PageReference previewPage = null;
        if(!wrapperMap.isEmpty()){
            previewPage = new PageReference('/apex/FOODS_preview');
            previewPage.setRedirect(false);
        }
        
        return previewPage;
        
    }
    
    public PageReference confirmOrder(){
        PageReference confirmPage = null;
        confirmPage = new PageReference('/apex/FOODS_confirm');
        confirmPage.setRedirect(false);
        String[] dateOfOrderArr = dateoforder.split('-');
        ord = new Order__c(
                              Requestor__c = requester,
                              OrderLocation__c = location,
                              Pickup_Time__c = pickuptime,
                              Food_Items__c = 'zz',
                              Date__c = Date.newInstance(Integer.valueOf(dateOfOrderArr[0]), Integer.valueOf(dateOfOrderArr[1]), Integer.valueOf(dateOfOrderArr[2])),
                              Quantity__c = 12,
                              Total_Price__c = totalPrice
                              
                          );
        insert ord;
        ord = [SELECT id, Name FROM Order__c WHERE id =: ord.Id];
        
        List< Order_Item__c> orderItems = new List< Order_Item__c>();
        
        for(Id wrapperId: wrapperMap.keySet()){
            for(FOODS_tempWrapper ftemp: wrapperMap.get(wrapperId).subcategories){
                orderItems.add(new Order_Item__c(
                                                    Name = ftemp.subcategory.Name,
                                                    Date__c = Date.newInstance(Integer.valueOf(dateOfOrderArr[0]), Integer.valueOf(dateOfOrderArr[1]), Integer.valueOf(dateOfOrderArr[2])),
                                                    Food_Items__c = ftemp.subcategory.Name,
                                                    Order__c = ord.Id,
                                                    OrderLocation__c = location,
                                                    Time__c = pickuptime,
                                                    Quantity__c = ftemp.quantity,
                                                    Requestor__c = requester,
                                                    Price__c = ftemp.subcategory.Price__c,
                                                    Total_Price__c = totalPrice
                                                ));
            }
        }
        
        if( !orderItems.isEmpty() )
            insert orderItems;
        
        return confirmPage;
    }

    public class FOODS_Wrapper {
        public Category__c cat{get;set;}
        public List<FOODS_tempWrapper> subcategories {get;set;}
        
        public FOODS_Wrapper(){
            cat = new Category__c();
            subcategories =  new List<FOODS_tempWrapper>();
        }
        
        public FOODS_Wrapper(Category__c cat, List<FOODS_tempWrapper> subcategories){
            this.cat = cat;
            this.subcategories = subcategories;
        }
    }
    
    public class FOODS_tempWrapper{
        public SubCategory__c subcategory{get;set;}
        public Integer quantity{get;set;}
        
        public FOODS_tempWrapper(){
        
        }
        
        public FOODS_tempWrapper(SubCategory__c subcategory, Integer quantity){
            this.subcategory = subcategory;
            this.quantity = quantity;
        }
        
    }
    
    public void doNothing(){
        system.debug('location is: '+location);
        system.debug('dateoforder is: '+dateoforder);
        system.debug('requester is: '+requester);
        String quant = ApexPages.currentPage().getParameters().get('qty');
        Decimal quantity;
        system.debug('qaunt: '+quant);
        String val = ApexPages.currentPage().getParameters().get('vaalu');
        system.debug('value: '+val);
        
        if(!String.isEmpty(quant)){
            quantity = Decimal.valueOf(quant);
        } else
            return;
         
        if(quantity ==0) {
        
            if(selectedMap.containsKey(val)){
                selectedMap.remove(val);
            }
        
            // if(selectedVal.contains(val)){
                // selectedVal.replaceAll(val, '');
            // }
        } else {
            // selectedVal = selectedVal + val;
            selectedMap.put(val, quantity);
        }
        
        system.debug('selectedMap: '+selectedMap);
        
        
    }

    public PageReference cancelOrder(){
        if(String.isEmpty(requester))
            return null;
        ord.Cancelled__c = true;
        update ord;
        PageReference home = new PageReference('/apex/FOODS_donePage');
        home.setRedirect(false);
        return home;
    }
    
    public PageReference showHome(){
        if(String.isEmpty(requester))
            return null;
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = 
        new Messaging.SingleEmailMessage();
        User activeUser = [Select Email, Id From User where Id = : userInfo.getUserId() limit 1];

        String userEmail = activeUser.Email;
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        sendTo.add(userEmail);
        mail.setToAddresses(sendTo);
        
        // Step 3: Set who the email is sent from
        mail.setReplyTo(userEmail);
        mail.setSenderDisplayName(requester);
        
        // (Optional) Set list of people who should be CC'ed
        List<String> ccTo = new List<String>();
        ccTo.add('Prashant.Gupta1@morganstanley.com');
        mail.setCcAddresses(ccTo);
        
        // Step 4. Set email contents - you can use variables!
        mail.setSubject('Order Confirmation - Your order with '+ord.Name+' has been successfully placed!');
        String body = 'Dear ' + requester + ', <br/>';
        body+='</p><p>This is a receipt of your Order <b>'+ord.Name+'.</b></p>'+
        '        <div style="float:left; clear:both;margin-bottom:1.5rem;padding-left:4rem;font-weight:bold;">'+
        '            <div style="float:left;margin-top:0.25rem;border:2.5px outset #262221;font-weight:normal;text-align:center;">'+
        '                <div style="display:inline;float:left; clear:both;">'+
        '                    <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
        '                        Order Details'+
        '                    </div>'+
        '                </div>'+
        '                <div style="display:inline;float:left; clear:both;">'+
        '             <div style="display:inline-block;float:left;width:20rem; height:2rem;color:black;text-align:center;">'+
        '                            <b style="color: green;">(Success)</b>&nbsp; Please find below, the summary of your Order '+ord.Name+
        '                            <br/><br/>'+
        '                        </div><br/><br/><br/>'+
        '                    <b>Delivery Address</b>     <p style="padding:0;margin:15px 0 10px 0;font-size:18px;color:#333333">'+requester+'&nbsp;&nbsp;&nbsp;&nbsp; '+
        '                </p> '+
        '            <p style="padding:0;margin:15px 0 10px 0;font-size:18px;color:#333333">'+location+'&nbsp;&nbsp;&nbsp;&nbsp; '+
        '                </p>'+
        '            <p style="padding:0;margin:15px 0 10px 0;font-size:18px;color:#333333">Total Price: '+totalPrice+'&nbsp;&nbsp;&nbsp;&nbsp; '+
        '                </p> </div><br/><br/>'+
        '               </div><br/><br/>'+
        '            </div><br/>       <br/><br/><br/> <br/>  <br/><br/>  <br/><br/> <br/><br/> <br/><br/><br/><br/><br/><br/>'+
        '            <p>Sincerely,</p>'+
        '            <p>FOODS Online Application.</p>';
        mail.setHtmlBody(body);
        // Step 6: Send all emails in the master list
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        // PageReference home = new PageReference('/home/home.jsp');
        PageReference home = new PageReference('/apex/FOODS_donePage');
        home.setRedirect(false);
        return home;
    }
    
    public PageReference editMenu(){
        if(String.isEmpty(location))
            return null;
        showMenu = true;
        wrapperMap = new Map<Id, FOODS_Wrapper>();
        tempWrapperMap = new Map<Id, FOODS_Wrapper>();
        
        // system.debug('req: '+ApexPages.currentPage().getParameters().get('nickName')+' location: '+location + ' dateoforder: '+dateoforder+' pickuptime: '+pickuptime );
        // system.debug('Requester '+ApexPages.currentPage().getParameters().get('requester') + ' Location '+ApexPages.currentPage().getParameters().get('location') + ' Date of Order '+ApexPages.currentPage().getParameters().get('dateoforder') + ' Pick up time '+ApexPages.currentPage().getParameters().get('pickuptime') );
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap));
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+[ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c WHERE Cafeteria_Location__r.Name like: ApexPages.currentPage().getParameters().get('location')]));
        for( Category__c cat: [ SELECT Id, Name, Cafeteria_Location__r.Name, (SELECT Id, Name, Price__c FROM SubCategories__r) FROM Category__c WHERE Cafeteria_Location__r.Name like: location] ){
            if( !cat.SubCategories__r.isEmpty() ){
                List<FOODS_tempWrapper> foodsWrapper = new List<FOODS_tempWrapper>();
                List<FOODS_tempWrapper> foodsWrapperClone = new List<FOODS_tempWrapper>();
            
                for(Subcategory__c sub: cat.SubCategories__r){
                    foodsWrapper.add(new Foods_tempWrapper(sub, 0));
                    Subcategory__c cloneSub = sub.clone();
                    cloneSub.id = sub.Id;
                    foodsWrapperClone.add(new Foods_tempWrapper(cloneSub, 0));
                }
                Category__c cloneCat = cat.clone();
                cloneCat.id = cat.Id;
                wrapperMap.put(cat.Id, new FOODS_Wrapper(cat, foodsWrapper) );
                tempWrapperMap.put(cat.Id, new FOODS_Wrapper(cloneCat, foodsWrapperClone) );
                // wrapperMap.put(cat.Id, new FOODS_Wrapper(cat, cat.SubCategories__r, new List<Integer>()) );
            }
        }
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Requester '+requester + ' Location '+location + ' Date of Order '+dateoforder + ' Pick up time '+pickuptime   ));
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap));
        PageReference menuPage = null;
        if(dateoforder <> NULL){
            menuPage = new PageReference('/apex/FOODS_EDIT_Menu');
            menuPage.setRedirect(false);
        }
        return menuPage;
        
    }
    
    public PageReference selectLocation(){
        PageReference home = new PageReference('/apex/FOODS_EditLocation');
        home.setRedirect(false);
        return home;
       
    }
    
    public PageReference placeOrder(){
        PageReference home = new PageReference('/apex/FOODS_Homepage');
        home.setRedirect(false);
        return home;
    }
    
    public PageReference FOODS_menuSave(){
        system.debug('wrapperMap: '+wrapperMap);
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ''+wrapperMap+' tempWrapperMap: '+tempWrapperMap));
        List<Category__c> categoriesToUpdate = new List<Category__c>();
        List<Subcategory__c> subcategoriesToUpdate = new List<Subcategory__c>();
        
        for(Id catId: tempWrapperMap.keySet()){
            FOODS_Wrapper oldFw =  tempWrapperMap.get(catId);
            FOODS_Wrapper newFw = wrapperMap.get(catId);
            
            if(oldFw.cat.Name <> newFw.cat.Name)
                categoriesToUpdate.add(newFw.cat);
            
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'oldFw: '+oldFw+ ' newFw: '+newFw ));
            for(FOODS_tempWrapper newSubCat: newFw.subcategories){
                for(FOODS_tempWrapper tempSubCat: oldFw.subcategories)
                    if( tempSubCat.subcategory.Id == newSubCat.subcategory.Id ) {
                        if( tempSubCat.subcategory.Name <> newSubCat.subcategory.Name || tempSubCat.subcategory.Price__c <> newSubCat.subcategory.Price__c  ) { // 
                            subcategoriesToUpdate.add(newSubCat.subcategory);
                        }
                    }
                
                
            }
            
            
        }
        
        // ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'subcategoriesToUpdate: '+subcategoriesToUpdate+' categoriesToUpdate: '+categoriesToUpdate));
        
        if( !subcategoriesToUpdate.isEmpty() || !categoriesToUpdate.isEmpty() ){ // 
            if(!subcategoriesToUpdate.isEmpty())
                Database.update(subcategoriesToUpdate);
            if(!categoriesToUpdate.isEmpty())
                Database.update(categoriesToUpdate);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'Records updated successfully.'));
        } else
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, 'No Records to update.'));
        PageReference home = new PageReference('/apex/FOODS_Admin_Homepage');
        home.setRedirect(false);
        return home;
    }

    public PageReference saveCategories(){
        PageReference home = new PageReference('/apex/FOODS_EditLocation');
        home.setRedirect(false);
        return home;
        
    }

}