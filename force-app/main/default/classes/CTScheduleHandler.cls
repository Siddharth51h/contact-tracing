public with sharing class CTScheduleHandler implements Schedulable {
    
    public static final string cron = '0 0 3 * * ?';
    public void execute(SchedulableContext sc){
        CTPeopleTracingBatch ptBatch= new CTPeopleTracingBatch();
        Database.executeBatch(ptBatch,200);       
       
}
}
 