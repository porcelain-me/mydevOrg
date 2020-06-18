public class myJavascriptController {
    
   
    
    public string field1 {get;set;}
    
    
    
    /*****************************************************************
    * Constructor
    *
    ******************************************************************/
    public myJavascriptController(){
        
        field1 = 'show data';
        
    }
    
    @RemoteAction
    public static boolean getData(){
        return true;      
    }
}