/******************************************************************************
 *      Name        :       APICalloutSystem
 *      Author      :       Shivram
 *      Date        :       15 Apr 2020
 *      Description :       Enqueue and executes API Callouts
 */
global class APICalloutSystem {

    //List of all cloouts
    private static List<APICalloutInterface> callouts = new List<APICalloutInterface>();

    /**
 * Add callout in queue list
 *
 * ## callout (APICallout): 
 */
    public static void registerCallout(APICalloutInterface callout) {
        callouts.add(callout);
    }

    public static void enqueueCallout(APICalloutInterface callout) {
        registerCallout(callout);
        enqueueCallouts();
    }
    public static void enqueueCallout() {
        enqueueCallouts();
    }
    /**
     * Enqueue callouts by inserting REST_Callout_Queue__c record
     *
     */
    public static void enqueueCallouts() {
        List<REST_Callout_Queue__c> calloutQueueList = new List<REST_Callout_Queue__c>();
        for (APICalloutInterface callout : callouts) {
            String name = String.valueOf(callout).split(':')[0];
            REST_Callout_Queue__c calloutQueue = new REST_Callout_Queue__c();
            calloutQueue.End_Point__c = callout.getUrl();
            calloutQueue.Request_Method__c = callout.getMethod();
            calloutQueue.Request_Params__c = callout.getRequestBody();
            calloutQueue.Status__c = 'Not Started';
            calloutQueue.Callout_Name__c = name;
            if (callout instanceof APIAuthenticatedCalloutInterface) {
                APIAuthenticatedCalloutInterface acall = (APIAuthenticatedCalloutInterface) callout;
                calloutQueue.Authentication__c = acall.getAuthentication();
                calloutQueue.Authentication_Header__c = acall.getAuthenticationHeader();
                calloutQueue.Authentication_Digest__c = acall.getAuthenticationDigest();
            }
            calloutQueueList.add(calloutQueue);
        }
        if (calloutQueueList.size() > 0) {
            insert calloutQueueList;
        }
    }
    
    /**
     * Add callout in queue list
     *
     * ## callout (APICallout): 
     */
    public static CalloutParameters runCallout(CalloutParameters params) {
        HttpResponse response;
        response = handleRequest(params);
        handleResponse(params, response);
        return params;        
    }

    public static HttpResponse handleRequest(CalloutParameters params) {
        //Make HTTP Callout
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        System.debug(params.endpoint);
        request.setEndpoint(params.endpoint);
        request.setMethod(params.requestMethod);
        if (params.requestMethod == 'POST') {
            if(params.authentication != null &&
                params.authentication == 'HMAC') {
                request.setHeader(
                    params.authenticationHeader,
                    params.authenticationDigest);
            }
            request.setBody(params.requestParams);
        }
        return http.send(request);        
    }
    
    public static void handleResponse(CalloutParameters params, HttpResponse response) {
        //Call Response handler
        Type t = Type.forName(params.calloutName);
        APICalloutInterface callout = (APICalloutInterface) t.newInstance();
        //Update Callout Queue record
        params.resultCode = response.getStatusCode();
        params.resultBody = response.getBody();
        params.status = response.getStatusCode() == callout.getSuccessCode() ? 'Complete' : 'Fail';
        
        //Process Response
        callout.responseHandler(response.getStatusCode(), response.getBody());
    }
    
    /**
     * Execute HTTP callout request and call response handler
     *
     * ## calloutQueueRec (REST_Callout_Queue__c)
     */
    public static void runCallout(Id calloutId) {
        // query for params
        CalloutParameters cparams = new CalloutParameters(calloutId);
        cparams = runCallout(cparams);
        cparams.updateSObject();
    }
    
    public class CalloutParameters {
        public Id thisid;
        public String error { get; set; }
        public String endpoint { get; set; }
        public String requestMethod { get; set; }
        public String authentication { get; set; }
        public String authenticationDigest { get; set; }
        public String authenticationHeader { get; set; }
        public String calloutName { get; set; }
        public String requestParams { get; set; }
        public Decimal retryCount { get; set; }
        public String status { get; set; }
        public Integer resultCode { get; set; }
        public String resultBody { get; set; }

        public CalloutParameters(Id td) {
            thisid = td;
            populateFromSObject(thisid);
        }

        public CalloutParameters(String s) {
            fromJSON(s);
        }
        
        public String toJSON() {
             return JSON.serialize(this);
        }
        
        public Boolean fromJSON(String s) {
            CalloutParameters that = null;
            try {
                that = (CalloutParameters) JSON.deserialize(s, CalloutParameters.class);
            } catch (Exception e) {
                return false;
            }
            if(that==null) return false;
            this.endpoint = that.endpoint;
            this.requestParams = that.requestParams;
            this.requestMethod = that.requestMethod;
            this.authentication = that.authentication;
            this.authenticationHeader = that.authenticationHeader;
            this.authenticationDigest = that.authenticationDigest;
            this.calloutName = that.calloutName;
            this.status = that.status;
            this.resultBody = that.resultBody;
            this.retryCount = that.retryCount;
            this.resultCode = that.resultCode == null ? 0 : Integer.valueOf(that.resultCode);
            return true;
        }
        
        public Boolean populateFromSObject(Id id) {
            thisid = id;
            List<REST_Callout_Queue__c> cqr = [select  Id, Callout_Name__c, End_Point__c,Retry_Count__c,
                Request_Method__c, Request_Params__c, Status__c, Result_Body__c, Result_Code__c,
                Authentication__c, Authentication_Header__c, Authentication_Digest__c
            from REST_Callout_Queue__c where Id = :id];
            if(cqr.isEmpty()) {
                return false;
            }
            REST_Callout_Queue__c calloutQueueRec = cqr[0];
            // populate params
            this.endpoint = calloutQueueRec.End_Point__c;
            this.requestParams = calloutQueueRec.Request_Params__c;
            this.requestMethod = calloutQueueRec.Request_Method__c;
            this.authentication = calloutQueueRec.Authentication__c;
            this.authenticationHeader = calloutQueueRec.Authentication_Header__c;
            this.authenticationDigest = calloutQueueRec.Authentication_Digest__c;
            this.calloutName = calloutQueueRec.Callout_Name__c;
            this.status = calloutQueueRec.Status__c;
            this.resultBody = calloutQueueRec.Result_Body__c;
            this.retryCount = calloutQueueRec.Retry_Count__c;
            this.resultCode = calloutQueueRec.Result_Code__c == null ? 0 : Integer.valueOf(calloutQueueRec.Result_Code__c);
            return true;
        }
        
        
        
        public Boolean updateSObject() {
            // update the callout record
            try {
                REST_Callout_Queue__c rcq = new REST_Callout_Queue__c(
                    Id = thisid,
                    End_Point__c = endpoint,
                    Request_Params__c = requestParams,
                    Request_Method__c = requestMethod,
                    Authentication__c = authentication,
                    Authentication_Header__c = authenticationHeader,
                    Authentication_Digest__c = authenticationDigest,
                    Callout_Name__c = calloutName,
                    Status__c = status,
                    Result_Body__c = resultBody,
                    Result_Code__c = String.valueOf(resultCode),
                    Retry_Count__c = retryCount 
                );
            
                update rcq;
            }
            catch(Exception e) {
                String errMsg =  e.getMessage() + ' at line ' + e.getLineNumber() + ' ' + e.getStackTraceString();
                Logger.error('APICalloutSystem Error', errMsg, errMsg);
                return false;
            }
            return true;
        }
    }
}