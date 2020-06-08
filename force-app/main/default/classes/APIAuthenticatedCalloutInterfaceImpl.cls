public class APIAuthenticatedCalloutInterfaceImpl implements APIAuthenticatedCalloutInterface {
    public String getAuthentication() { return 'HMAC'; }
    public String getAuthenticationHeader() { return 'header'; }
    public String getAuthenticationDigest() { return '1234'; }
    public String getClassName() { return 'APIAuthenticatedCalloutInterfaceImpl'; }
    public String getUrl() { return 'http://allcloud.io'; }
    public String getMethod() { return 'GET'; }
    public Integer getSuccessCode() { return 200; }
    public Map<String,String> getRequestHeaders() { return new Map<String, String>{'header' => '1234'}; }
    public String getRequestBody(){ return 'body'; }
    public void responseHandler(integer responseCode, String response){ }
    public REST_Callout_Queue__c createRESTCallout() { return null; }
}