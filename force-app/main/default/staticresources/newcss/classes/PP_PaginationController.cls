public with sharing class PP_PaginationController {

    List<PP_categoryWrapper> categories {get;set;}

    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select id,name,BUILDING_NAME__c from Building_Locations__c where InScopeFrom__c=false]));
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

    // displays the selected items
     public PageReference process() {
         for (PP_CategoryWrapper cw : categories) {
             if (cw.checked)
                 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.cat.name));
         }
         return null;
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