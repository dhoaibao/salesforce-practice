/**
 * Example service demonstrating how to use HttpCalloutService
 * This file shows various patterns for using the generic HTTP service
 */
public with sharing class ExampleService {
    private static final String BASE_ENDPOINT = 'callout:API_URL_CONVOSO/api/v1';
    
    // Example 1: Simple GET request using convenience method
    public static Object getUser(String userId) {
        String endpoint = BASE_ENDPOINT + '/users/' + userId;
        return HttpCalloutService.get(endpoint, 'Get User');
    }
    
    // Example 2: Simple POST using convenience method
    public static Object createUser(Object userData) {
        String endpoint = BASE_ENDPOINT + '/users';
        String requestBody = JSON.serialize(userData);
        return HttpCalloutService.post(endpoint, requestBody, 'Create User');
    }
    
    // Example 3: Advanced usage with custom headers and timeout
    public static Object advancedApiCall() {
        HttpCalloutService.ApiRequest request = new HttpCalloutService.ApiRequest();
        request.endpoint = BASE_ENDPOINT + '/advanced-endpoint';
        request.method = 'PUT';
        request.body = '{"data": "custom payload"}';
        request.operationName = 'Advanced API Call';
        request.timeout = 30000; // 30 seconds
        
        // Add custom headers
        request.headers.put('Authorization', 'Bearer token123');
        request.headers.put('X-Custom-Header', 'custom-value');
        request.headers.put('Content-Type', 'application/json');
        
        HttpCalloutService.ApiResponse response = HttpCalloutService.makeCallout(request);
        
        if (response.isSuccess) {
            System.debug('Success: ' + response.responseBody);
            return response.responseBody;
        } else {
            System.debug('Error: ' + response.errorMessage);
            return null;
        }
    }
    
    // Example 4: Handling different response codes
    public static Map<String, Object> getDetailedResponse(String endpoint) {
        HttpCalloutService.ApiRequest request = new HttpCalloutService.ApiRequest();
        request.endpoint = endpoint;
        request.method = 'GET';
        request.operationName = 'Detailed Response Check';
        
        HttpCalloutService.ApiResponse response = HttpCalloutService.makeCallout(request);
        
        Map<String, Object> result = new Map<String, Object>();
        result.put('success', response.isSuccess);
        result.put('statusCode', response.statusCode);
        result.put('body', response.responseBody);
        result.put('headers', response.responseHeaders);
        
        if (!response.isSuccess) {
            result.put('errorMessage', response.errorMessage);
        }
        
        return result;
    }
    
    // Example 5: Batch operations
    public static List<Object> batchGetUsers(List<String> userIds) {
        List<Object> results = new List<Object>();
        
        for (String userId : userIds) {
            String endpoint = BASE_ENDPOINT + '/users/' + userId;
            Object userdata = HttpCalloutService.get(endpoint, 'Batch Get User ' + userId);
            results.add(userdata);
        }
        
        return results;
    }
}
