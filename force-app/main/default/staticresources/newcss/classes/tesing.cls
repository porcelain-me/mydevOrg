public class tesing{

    public void test(){
        decimal dec=1111053253200.98;
        List<String> args = new String[]{'0','number','###,###,##0.00'};
        string str=String.format(dec.format(), args);
        system.debug('8*****************'+str);
    }
}