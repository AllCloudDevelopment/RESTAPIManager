/*********************************************************
 * 		Name		:		RESTCalloutScheduler
 * 		Author		:		Shivram
 * 		Date		:		1 Apr, 2020
 * 		Description	:		Schedule job runs every minute and execute rest callout stored in Rest Callout Queue object.
**********************************************************/
global class RESTCalloutScheduler implements Schedulable{
    global void execute(SchedulableContext Sc) {
        //Call Batch Job
        Database.executeBatch(new RESTCalloutBatch(),1);
        
        //Abort current schedule job
        System.abortJob(sc.getTriggerId());
        
        //Schedule job for next minute
        DateTime dt = System.now().addMinutes(1);
        String cronStr = '0 '+ dt.minute() + ' '+ dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        if(!Test.isRunningTest())
            system.schedule('Rest Callout Job', cronStr , new RESTCalloutScheduler());
        
        
    }
}