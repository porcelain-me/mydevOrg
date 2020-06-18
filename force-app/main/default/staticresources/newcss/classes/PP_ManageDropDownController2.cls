public class PP_ManageDropDownController2 {

     public String selectRegion {get;set;}                                 //Editing started by susidham
     public list<Building_Locations__c> TempValueList{get;set;}                 
         
   public List<SelectOption> getRegionOptions() {                             //Method for selecting region (Region field picklist)

      List<selectOption> seleopt = new List<selectOption>();
        
      for (PP_Region_Mapping__c regdescmap : PP_Region_Mapping__c.getAll().values())          //PP_Region_Mapping__c --> a custom setting  
      {
        seleopt.add(new SelectOption(regdescmap.Arena_Description__c,regdescmap.Name));
      }
              return seleopt;
 
   }                                                     
          
  
   public pageReference regionFilter(){                                      //Method to filter the buildings according to their region.
                                                                            //this method is called when user selects a value from Region picklist
      List<SelectOption> options = new List<SelectOption>();
      TempValueList = [select id,name,InScopeFrom__c from Building_Locations__c where ARENA_DESCRIPTION__c =: selectRegion limit 1000];
      return null;                                                         //returns nothing if None is selected in the picklist    
   }
         
    //**filter end
    //variable declr for building from 
    public list<String> LeftSelectedListFrom{get;set;}
    public list<String> RightSelectedListFrom{get;set;}
    map<String, Building_Locations__c> LeftOptionMap = new map<String, Building_Locations__c>(); 
    map<String, Building_Locations__c> RightOptionMap = new map<String, Building_Locations__c>();
    

    
    Public boolean showmessage{get;set;}     
    public String tabType{get;set;}
    public boolean showlistsize{get;set;}
      
    public PP_ManageDropDownController2(){
    
        tabType = apexpages.currentPage().getParameters().get('tab');
        LeftSelectedListFrom = new list<String>();
        RightSelectedListFrom = new list<String>();
        TempValueList=new list<Building_Locations__c>();
    }
    
    
    //to get the selectoption list from
    public list<selectoption> getFromLeftList(){
    list<SelectOption> TempOptionList = new list<SelectOption>();
             TempValueList.sort();  // sort by name  
             for (Building_Locations__c  u : TempValueList) {      
                 if(u.InScopefrom__c  == false){                            //allow only those buildings which have scope false on left side
                    TempOptionList.add(new SelectOption(u.Id, u.name)); 
                     LeftOptionMap.put(u.id,u);
                       
                     }
                 
                } 
                   return TempOptionList;  
             }
             
              
    map<String,Building_Locations__c> CurrentRightListFrom=new map<String,Building_Locations__c>(); 
    
    public list<selectoption> getFromRightList(){
    list<SelectOption> TempOptionList = new list<SelectOption>();  
             TempValueList.sort();  // sort by name    
             for (Building_Locations__c  u : TempValueList) {      
                    if(u.InScopeFrom__c  == true){                    //allow only those buildings which have scope true in right side
                    TempOptionList.add(new SelectOption(u.Id, u.name));
                                         
                     RightOptionMap.put(u.id,u);  
                 }
                }    return TempOptionList;  
             } 
            
 
        
    list<Building_Locations__c> UpdateValues=new list<Building_Locations__c>(); 
    
   public pagereference ClickRight(){
    UpdateValues.clear();
   RightSelectedListFrom.clear();
   for(String S:LeftSelectedListFrom){
   If(LeftOptionMap.containsKey(S)){
   RightOptionMap.put(S,LeftOptionMap.get(S));
        
    }
    LeftOptionMap.remove(s);
    
    
        
    }
    for(Building_Locations__c X:RightOptionMap.values()){
        X.InScopeFrom__c=true;
        UpdateValues.add(X);
    }
    
    update UpdateValues;
    
    showmessage=true; 
    showdemessage=false;   
    return null;
   }    
   
   
   
   public boolean showdemessage{get;set;}
   public pagereference ClickLeft(){
   UpdateValues.clear();    
   LeftSelectedListFrom.clear();
   for(String S:RightSelectedListFrom){
   If(RightOptionMap.containsKey(S)){
   LeftOptionMap.put(S,RightOptionMap.get(S));      
    }
    
    
    RightOptionMap.remove(s);
        
    }
    
    for(Building_Locations__c X:LeftOptionMap.values()){
        X.InScopeFrom__c=false;
        UpdateValues.add(X);
    }
    
   
   
    update UpdateValues;
    showdemessage=true;
    showmessage=false; 
    return null;
   }
   
   
  
  
        
   Public pagereference ManageFrom(){
       showmessage = true;
       return null;
   }    
    
    public PageReference goBackToAdminPage(){
        PageReference pr2 = new PageReference('/apex/PP_AdminScreens?tab=Admin');
        pr2.setRedirect(true);
        return pr2;
    }
    
    
 
    List<PP_categoryWrapper> categories {get;set;}

    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(PP_Util.getAllBuildings());
                // sets the number of records in each page set
                con.setPageSize(100);
            }
            return con;
        }
        set;
    }

    // returns a list of wrapper objects for the sObjects in the current page set
    public List<PP_categoryWrapper> getCategories() {
        categories = new List<PP_categoryWrapper>();
        for (Building_Locations__c category : (List<Building_Locations__c>)con.getRecords())
            categories.add(new PP_categoryWrapper(category));

        return categories;
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

    // returns the first page of records
     public void first() {
         con.first();
     }

     // returns the last page of records
     public void last() {
         con.last();
     }

     // returns the previous page of records
     public void previous() {
         con.previous();
     }

     // returns the next page of records
     public void next() {
         con.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
    
}