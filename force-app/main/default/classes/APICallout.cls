/**
 * Created by sebastianschepis on 5/5/20.
 */

public abstract class APICallout implements APICalloutInterface {
    public virtual REST_Callout_Queue__c createRESTCallout() {
        REST_Callout_Queue__c calloutQueue = new REST_Callout_Queue__c();
        calloutQueue.End_Point__c = ((APICalloutInterface)this).getUrl();
        calloutQueue.Request_Method__c = ((APICalloutInterface)this).getMethod();
        calloutQueue.Request_Params__c = ((APICalloutInterface)this).getRequestBody();
        calloutQueue.Status__c = 'Not Started';
        calloutQueue.Callout_Name__c =  ((APICalloutInterface)this).getClassName();
        return calloutQueue;
    }
}