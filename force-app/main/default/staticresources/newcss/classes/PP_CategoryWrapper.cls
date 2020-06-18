public class PP_CategoryWrapper {


    public Boolean checked{ get; set; }
    public Building_Locations__c cat { get; set;}

    public PP_CategoryWrapper(){
        cat = new Building_Locations__c();
        checked = false;
    }

    public PP_CategoryWrapper(Building_Locations__c c){
        cat = c;
        checked = false;
    }


}