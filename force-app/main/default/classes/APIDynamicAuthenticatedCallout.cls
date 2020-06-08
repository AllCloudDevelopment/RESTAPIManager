/**
 * Created by sebastianschepis on 5/4/20.
 */

public abstract class APIDynamicAuthenticatedCallout 
    extends APIDynamicCallout 
    implements APIAuthenticatedCalloutInterface {

    public static String generateSHA256Digest(String toSign) {
        return EncodingUtil.convertToHex(Crypto.generateDigest(
            'SHA-256',
            Blob.valueOf(toSign)));
    }
    public REST_Callout_Queue__c createSobject() {
        REST_Callout_Queue__c calloutQueue = new REST_Callout_Queue__c();
        calloutQueue.End_Point__c = ((APICalloutInterface)this).getUrl();
        calloutQueue.Request_Method__c = ((APICalloutInterface)this).getMethod();
        calloutQueue.Request_Params__c = ((APICalloutInterface)this).getRequestBody();
        calloutQueue.Status__c = 'Not Started';
        calloutQueue.Callout_Name__c = ((APIAuthenticatedCalloutInterface)this).getClassName();
        calloutQueue.Authentication__c = ((APIAuthenticatedCalloutInterface)this).getAuthentication();
        calloutQueue.Authentication_Digest__c = ((APIAuthenticatedCalloutInterface)this).getAuthenticationDigest();
        calloutQueue.Authentication_Header__c = ((APIAuthenticatedCalloutInterface)this).getAuthenticationHeader();
        return calloutQueue;
    }
}