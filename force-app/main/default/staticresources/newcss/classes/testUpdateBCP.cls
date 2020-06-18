@IsTest(seeAlldata=true)
public class testUpdateBCP
{
    public static testMethod void Test_1()
	{
	Test.startTest();
	UpdateBCP m = new UpdateBCP();
	String sch = '20 30 8 10 2 ?';
	String jobID = system.schedule('Merge Job', sch, m);
	Test.stopTest();
	}
}