trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
    List<Task> tsk = new List<Task>();
    if (trigger.IsInsert || trigger.IsUpdate ){
       for (Opportunity opp : trigger.new)
       
           if(opp.StageName == 'Closed Won')
           {Task t = new Task ();
              t.WhatId = opp.Id;
              t.Subject = 'Follow Up Test Task';
              t.OwnerId = UserInfo.getUserId();
              t.Status = 'Not Started';
             t.Priority = 'Normal';
            tsk.add(t); }
    
     Insert tsk;
    }}