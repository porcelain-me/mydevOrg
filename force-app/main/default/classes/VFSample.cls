public class VFSample {
 Account account;
    public PageReference Save() {
     PageReference secondPage = Page.mySecondPage;
        secondPage.setRedirect(false);
        return secondPage;
    }

public string getName(){return 'Pandey';}
public Account getAccount() {
  if(account ==null)
        account = [select id, name from Account
                 where id = :ApexPages.currentPage().getParameters().get('id')]; 
                return account; 
    }

}