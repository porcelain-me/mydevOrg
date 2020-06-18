global class WV_ReadAndPopulateBatch implements Schedulable {
   public String m_csvFile;
   public String fileId;
   public Map<Integer,string>  OrderMap;
   
   global WV_ReadAndPopulateBatch (string csvfile,string fileid,Map<Integer,string> maps){
       this.m_csvFile=csvfile;
       this.fileId=fileid;
       this.OrderMap=maps;
   }
   
   global void execute(SchedulableContext sc) {
        try{
            if (([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')]) < 5){
                ReadAndPopulateBatch b = new ReadAndPopulateBatch(); 
                b.m_csvFile=this.m_csvFile;
                b.fileId=this.fileId;
                b.OrderMap=this.OrderMap;
                database.executebatch(b);
                b=null;
                system.debug('********sindisede');
            } else {
                WV_ReadAndPopulateBatch m = new WV_ReadAndPopulateBatch (this.m_csvFile,this.fileId,this.OrderMap);
                String sch = system.now().second()+' '+system.now().addminutes(1).minute()+' '+system.now().hour()+' '+system.now().day()+' '+system.now().month()+' ? '+system.now().year();
                system.debug('********scheduled time'+sch);
                string name='Custom data Job'+system.now()+system.now().millisecond();
                String jobID = system.schedule(name, sch, m);
                m=null;
            }
            system.debug('********final');      
        }
        Catch(Exception e){
            Integer i=[SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing' OR Status = 'Queued')];
            System.debug('************'+i);
        }
   }
}