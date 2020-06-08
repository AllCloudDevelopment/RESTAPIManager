public class APICalloutInterfaceImpl implements APICalloutInterface {
    public String getClassName() { return 'APICalloutInterfaceImpl'; }
    public String getUrl() { return 'http://allcloud.io'; }
    public String getMethod() { return 'GET'; }
    public Integer getSuccessCode() { return 200; }
    public Map<String,String> getRequestHeaders() { return new Map<String, String>(); }
    public String getRequestBody(){ return 'body'; }
    public void responseHandler(integer responseCode, String response){ }
    public REST_Callout_Queue__c createRESTCallout() { return null; }
}