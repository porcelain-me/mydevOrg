@istest
public class exampleCon1test {
 static testmethod void callinghello()
 {
     string n;
     string uname = UserInfo.getName();
     exampleCon1 exc = new exampleCon1();
     exc.sayhello();
     exc.getState();
     exc.setState(n);
     exc.methodOne();
     exc.getUsername();
 }
}