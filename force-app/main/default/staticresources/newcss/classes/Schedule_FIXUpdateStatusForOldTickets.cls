global class Schedule_FIXUpdateStatusForOldTickets implements schedulable
{    
	global void execute(SchedulableContext sc)
	{    
		FIXUpdateStatusForOldTickets b = new FIXUpdateStatusForOldTickets();      
		database.executebatch(b);
	}
}