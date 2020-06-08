/**
 *      Name        :       RESTCalloutSchedulerTest
 *      Author      :       Shivram
 *      Date        :       8 Apr 2020
 *      Description :       Test class for RESTCalloutScheduler & RESTCalloutBatch
 */ 
@isTest
public class RESTCalloutSchedulerTest {

    /**
     * Shivram, 8 Apr 2020
     * Test method for GET rest callout request
     */
    @isTest
    public static void testGET(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APICalloutResponseMockImpl());

        Test.startTest();
        
        //Create callout queue record
        APICalloutSystem.enqueueCallout(new APICalloutInterfaceImpl());

        //Run schedule job
        DateTime dt = System.now().addMinutes(1);
        String cronStr = '0 '+ dt.minute() + ' '+ dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('Rest Callout Job Test', cronStr , new RESTCalloutScheduler());
        Test.stopTest();
    }
    
    /**
     * Shivram, 8 Apr 2020
     * Test method for POST rest callout request
     */
    @isTest
    public static void testPOST(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APICalloutResponseMockImpl());

        Test.startTest();
        
        APICalloutSystem.enqueueCallout(new APICalloutInterfaceImpl());
        
        //Run schedule job
        DateTime dt = System.now().addMinutes(1);
        String cronStr = '0 '+ dt.minute() + ' '+ dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('Rest Callout Job Test', cronStr , new RESTCalloutScheduler());

        Test.stopTest();
    }


    /**
     * Shivram, 8 Apr 2020
     * Test method for failed rest callout request
     */
    @isTest
    public static void testFailed(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APICalloutResponseMockImpl());

        Test.startTest();
        
        //Create callout queue record
        APICalloutSystem.enqueueCallout(new APICalloutInterfaceImpl());
        
        //Run schedule job
        DateTime dt = System.now().addMinutes(1);
        String cronStr = '0 '+ dt.minute() + ' '+ dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('Rest Callout Job Test', cronStr , new RESTCalloutScheduler());

        Test.stopTest();
    }

    /**
     * Shivram, 8 Apr 2020
     * Test method for retry callout request
     */
    @isTest
    public static void testRetry(){
        ATestDataFactory.setupCustomSettings();

        APICalloutSystem.enqueueCallout(new APICalloutInterfaceImpl());
        REST_Callout_Queue__c calloutQueue = [select Status__c, Retry_Count__c from REST_Callout_Queue__c limit 1];
        calloutQueue.Status__c = 'Fail';
        calloutQueue.Retry_Count__c = 1;
        update calloutQueue;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new APICalloutResponseMockImpl());

        Test.startTest();
        //Run schedule job
        DateTime dt = System.now().addMinutes(1);
        String cronStr = '0 '+ dt.minute() + ' '+ dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        system.schedule('Rest Callout Job Test', cronStr , new RESTCalloutScheduler());

        Test.stopTest();
    }
}