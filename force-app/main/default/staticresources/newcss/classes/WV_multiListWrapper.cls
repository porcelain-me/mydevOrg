public class WV_multiListWrapper{
    public string controltype{get; set;}
    public boolean showCurrency{get; set;}
    public string name{get; set;}
    public string value{get; set;}
    public string currencycode {get; set;}
    public string Error {get; set;}
    
    public WV_multiListWrapper(){
        this.Error=null;
    }
}