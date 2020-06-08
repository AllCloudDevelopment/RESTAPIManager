/******************************************************************
 *      Name        :       APICallout
 *      Author      :       Shivram
 *      Date        :       3 Apr, 2020
 *      Description :       Interface to define callout structor
 ********************************************************************/
public interface APICalloutInterface {
    String getClassName();
    String getUrl();
    String getMethod();
    Integer getSuccessCode();
    
    Map<String,String> getRequestHeaders();
    String getRequestBody();
    
    void responseHandler(integer responseCode, String response);
    
    REST_Callout_Queue__c createRESTCallout();
}