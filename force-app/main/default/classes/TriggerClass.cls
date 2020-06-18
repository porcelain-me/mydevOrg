public class TriggerClass {
    public static void trigger_method(List<Opportunity> ops)
    {
        Double Total_Amount = 0;
        
        for (Opportunity o1 :[select Amount from Opportunity where CreatedDate =TODAY AND Createdbyid = :userinfo.getuserid()])
        {
            Total_Amount = Total_Amount + o1.Amount;
        }
        for (Opportunity o2 :ops)
        {
            Total_Amount = Total_Amount + o2.Amount;
            if (Total_Amount > 10000)
                o2.addError('not good ');
        }
    }

}