/*********************************************************
 * 		Name		:		RESTCalloutBatch
 * 		Author		:		Shivram
 * 		Date		:		1 Apr, 2020
 * 		Description	:		Apex job runs every minute and execute rest callout stored in Rest Callout Queue object.
**********************************************************/
global class RESTCalloutBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer maxRetryLimit = 1;
        String settingValue = CustomSettings.getValue(Constants.MAX_CALLOUT_RETRY);
        if(settingValue != null)
            maxRetryLimit = Integer.valueOf(settingValue);
        //Query Rest Callout Queue records
        return Database.getQueryLocator([SELECT Id
            FROM REST_Callout_Queue__c 
            WHERE (Status__c ='Not Started' OR (Status__c='Fail' AND Retry_Count__c<:maxRetryLimit))
        ]);
    }
    global void execute(Database.BatchableContext BC,List<sObject> batch){
        List<REST_Callout_Queue__c> calloutQueueRecords = (List<REST_Callout_Queue__c>) batch;
        for(REST_Callout_Queue__c calloutQueueRec : calloutQueueRecords ){
            APICalloutSystem.runCallout(calloutQueueRec.Id);
        }
    }
    global void finish(Database.BatchableContext BC){

    }
}