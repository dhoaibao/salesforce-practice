public with sharing class HttpCalloutService {
    
    // Inner class for API request configuration
    public class ApiRequest {
        public String endpoint { get; set; }
        public String method { get; set; }
        public String body { get; set; }
        public Map<String, String> headers { get; set; }
        public Integer timeout { get; set; }
        public String operationName { get; set; }
        
        public ApiRequest() {
            this.headers = new Map<String, String>();
            this.timeout = 10000; // 10 seconds
            this.operationName = 'API Call';
        }
        
        public ApiRequest(String endpoint, String method) {
            this();
            this.endpoint = endpoint;
            this.method = method;
        }
    }
    
    public class ApiResponse {
        public Boolean isSuccess { get; set; }
        public String responseBody { get; set; }
        public Integer statusCode { get; set; }
        public String errorMessage { get; set; }
        public Map<String, String> responseHeaders { get; set; }
        
        public ApiResponse() {
            this.responseHeaders = new Map<String, String>();
        }
    }
    
    /**
     * Generic method to make HTTP callouts
     * @param apiRequest Configuration for the API call
     * @return ApiResponse with success/error information
     */
    public static ApiResponse makeCallout(ApiRequest apiRequest) {
        ApiResponse apiResponse = new ApiResponse();
        
        // Validation
        if (String.isBlank(apiRequest.endpoint)) {
            apiResponse.isSuccess = false;
            apiResponse.errorMessage = 'Endpoint cannot be blank';
            return apiResponse;
        }
        
        if (String.isBlank(apiRequest.method)) {
            apiResponse.isSuccess = false;
            apiResponse.errorMessage = 'HTTP method cannot be blank';
            return apiResponse;
        }
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        try {
            // Set basic request properties
            request.setEndpoint(apiRequest.endpoint);
            request.setMethod(apiRequest.method.toUpperCase());
            request.setTimeout(apiRequest.timeout);
            
            // Set headers
            if (apiRequest.headers != null && !apiRequest.headers.isEmpty()) {
                for (String headerName : apiRequest.headers.keySet()) {
                    request.setHeader(headerName, apiRequest.headers.get(headerName));
                }
            }
            
            // Set request body for POST/PUT/PATCH methods
            if (String.isNotBlank(apiRequest.body)) {
                request.setBody(apiRequest.body);
                // Set default Content-Type if not already set
                if (!apiRequest.headers.containsKey('Content-Type')) {
                    request.setHeader('Content-Type', 'application/json');
                }
            }
            
            // Make the callout
            HttpResponse response = http.send(request);
            
            // Process response
            apiResponse.statusCode = response.getStatusCode();
            apiResponse.responseBody = response.getBody();
            
            // Get response headers
            for (String headerKey : response.getHeaderKeys()) {
                apiResponse.responseHeaders.put(headerKey, response.getHeader(headerKey));
            }
            
            // Determine success based on status code
            if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
                apiResponse.isSuccess = true;
                System.debug(LoggingLevel.INFO, apiRequest.operationName + ' successful: ' + response.getStatusCode());
            } else {
                apiResponse.isSuccess = false;
                apiResponse.errorMessage = 'HTTP ' + response.getStatusCode() + ': ' + response.getStatusMessage();
                System.debug(LoggingLevel.ERROR, apiRequest.operationName + ' error: ' + 
                           response.getStatusCode() + ' - ' + response.getBody());
            }
            
        } catch (Exception e) {
            apiResponse.isSuccess = false;
            apiResponse.errorMessage = e.getMessage();
            apiResponse.statusCode = -1;
            System.debug(LoggingLevel.ERROR, apiRequest.operationName + ' exception: ' + e.getMessage());
        }
        
        return apiResponse;
    }
    
    /**
     * Convenience method for simple GET requests
     * @param endpoint The API endpoint
     * @param operationName Name for logging purposes
     * @return Object response body or null on error
     */
    public static Object get(String endpoint, String operationName) {
        ApiRequest request = new ApiRequest(endpoint, 'GET');
        request.operationName = operationName;
        
        ApiResponse response = makeCallout(request);
        return response.isSuccess ? response.responseBody : null;
    }
    
    /**
     * Convenience method for simple POST requests
     * @param endpoint The API endpoint
     * @param requestBody JSON request body
     * @param operationName Name for logging purposes
     * @return Object response body or null on error
     */
    public static Object post(String endpoint, String requestBody, String operationName) {
        ApiRequest request = new ApiRequest(endpoint, 'POST');
        request.body = requestBody;
        request.operationName = operationName;
        
        ApiResponse response = makeCallout(request);
        return response.isSuccess ? response.responseBody : null;
    }
    
    /**
     * Convenience method for simple DELETE requests
     * @param endpoint The API endpoint
     * @param operationName Name for logging purposes
     * @return Object response body or null on error
     */
    public static Object deleteRequest(String endpoint, String operationName) {
        ApiRequest request = new ApiRequest(endpoint, 'DELETE');
        request.operationName = operationName;
        
        ApiResponse response = makeCallout(request);
        return response.isSuccess ? response.responseBody : null;
    }
}
