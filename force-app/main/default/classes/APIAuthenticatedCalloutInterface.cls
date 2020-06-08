/******************************************************************
 *      Name        :       APIAuthenticatedCallout
 *      Author      :       Shivram
 *      Date        :       3 Apr, 2020
 *      Description :       Interface to define callout structor
 ********************************************************************/
public interface APIAuthenticatedCalloutInterface extends APICalloutInterface {
    String getAuthentication();
    String getAuthenticationHeader();
    String getAuthenticationDigest();
}