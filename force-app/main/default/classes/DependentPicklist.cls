public class DependentPicklist {
    public String country {get;set;}
    public String state {get;set;}
    //Public List<Account> acc = new List<Account>([Select name from Account Limit 5]);
    //Public List<String> accnames = new List<String> ();
     
    
    public List<SelectOption> getCountries()
    {
        //for (Account acc1:acc)
        // accnames.add(acc1.name);
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- Select ---'));        
        options.add(new SelectOption('US','USA'));
        options.add(new SelectOption('IN','India'));
        return options;
    } 
    
    public List<SelectOption> getStates()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(country == 'US')
        {       
            options.add(new SelectOption('CO','Colorado'));
            options.add(new SelectOption('NE','Nevada'));
            options.add(new SelectOption('TE','Texas'));
        }
        else if(country == 'IN')
        {       
            options.add(new SelectOption('BI','Bihar'));
            options.add(new SelectOption('KE','Kerala'));
            options.add(new SelectOption('MA','Manipur'));
        }
        else
        {
            options.add(new SelectOption('None','--- Select ---'));
        }      
        return options;
    }       
}