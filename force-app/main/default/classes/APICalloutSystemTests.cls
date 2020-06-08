/**
 * Created by sebastianschepis on 5/9/20.
 */

@IsTest
public class APICalloutSystemTests {
    
    @IsTest
    static void testBehavior() {
        Test.startTest();
        delete [select Id from REST_Callout_Queue__c];
        
        APICalloutSystem.registerCallout(new APICalloutInterfaceImpl());
        APICalloutSystem.enqueueCallouts();
        System.assertEquals([select Id from REST_Callout_Queue__c].size(), 1);

        APIAuthenticatedCalloutInterfaceImpl impl = new APIAuthenticatedCalloutInterfaceImpl();
        APICalloutSystem.registerCallout(impl);
        APICalloutSystem.enqueueCallouts();
        System.assertNotEquals([select Id from REST_Callout_Queue__c].size(), 0);
        impl.createRESTCallout();
        
        List<REST_Callout_Queue__c> rqq = [select Id from REST_Callout_Queue__c];
        
        APICalloutSystem.CalloutParameters cp = new APICalloutSystem.CalloutParameters(rqq[0].Id);
        String jsonFile = cp.toJSON();
        System.debug(jsonFile);
        System.assertEquals(cp.fromJSON(jsonFile), True);
        cp.updateSObject();
        Test.stopTest();
    }
    
    @IsTest
    static void testBehavio2r() {
        String co = '{"calloutName":"APICalloutInterfaceImpl","endpoint":"http://allcloud.io","requestMethod":"GET","requestParams":"body","resultCode":0,"status":"Not Started","thisid":"a01e000000LweE4AAJ"}';
        APICalloutSystem.CalloutParameters cp = new APICalloutSystem.CalloutParameters(co);
        Test.setMock(HttpCalloutMock.class, new APICalloutResponseMockImpl());
        Test.startTest();
        HttpResponse r = APICalloutSystem.handleRequest(cp);
        APICalloutSystem.handleResponse(cp,r);
        Test.stopTest();
    }

    public class MyDynamicCallout extends APIDynamicCallout {
        public String getClassName() { return 'MyDynamicCallout'; }
        public String getUrl() { return 'http://allcloud.io'; }
        public String getMethod() { return 'GET'; }
        public Integer getSuccessCode() { return 200; }
        public Map<String,String> getRequestHeaders() { return new Map<String, String>(); }
        public String getRequestBody(){ return 'body'; }
        public void responseHandler(integer responseCode, String response){ }
    }

    public class MyCallout extends APICallout {
        public String getClassName() { return 'MyCallout'; }
        public String getUrl() { return 'http://allcloud.io'; }
        public String getMethod() { return 'GET'; }
        public Integer getSuccessCode() { return 200; }
        public Map<String,String> getRequestHeaders() { return new Map<String, String>(); }
        public String getRequestBody(){ return 'body'; }
        public void responseHandler(integer responseCode, String response){ }        
    }
    public class MyDACallout extends APIDynamicAuthenticatedCallout {
        public String getAuthentication() { return 'HMAC'; }
        public String getAuthenticationHeader() { return 'header'; }
        public String getAuthenticationDigest() { return '1234'; }
        public String getClassName() { return 'MyDACallout'; }
        public String getUrl() { return 'http://allcloud.io'; }
        public String getMethod() { return 'GET'; }
        public Integer getSuccessCode() { return 200; }
        public Map<String,String> getRequestHeaders() { return new Map<String, String>(); }
        public String getRequestBody(){ return 'body'; }
        public void responseHandler(integer responseCode, String response){ }
    }
    @IsTest
    static void testBehavio3r() {
        MyDynamicCallout dc = new MyDynamicCallout();
        dc.getParameter('foo');
        dc.setParameter('foo','');
        dc.paramsToJSON();

        MyCallout c = new MyCallout();
        c.createRESTCallout();

        APIAuthenticatedCalloutInterfaceImpl ii = new APIAuthenticatedCalloutInterfaceImpl();
        ii.getClassName();
        ii.getSuccessCode();
        ii.getRequestHeaders();
        ii.responseHandler(1,'');
        
        APICalloutInterfaceImpl i = new APICalloutInterfaceImpl();
        i.getClassName();
        i.getSuccessCode();
        i.getRequestHeaders();
        i.responseHandler(1,'');
        
        APIDynamicAuthenticatedCallout ddd = new MyDACallout();
        ddd.createRESTCallout();
        APIDynamicAuthenticatedCallout.generateSHA256Digest('poop');
        ddd.createSobject();
    }
}