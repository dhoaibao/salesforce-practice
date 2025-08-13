public with sharing class ApiResponse {
    public Boolean isSuccess { get; set; }
    public String data { get; set; }
    public String errorMessage { get; set; }
    public Integer statusCode { get; set; }
    
    // Constructor for success response
    public ApiResponse(String responseData) {
        this.isSuccess = true;
        this.data = responseData;
        this.errorMessage = null;
        this.statusCode = 200;
    }
    
    // Constructor for error response
    public ApiResponse(String errorMsg, Integer httpStatusCode) {
        this.isSuccess = false;
        this.data = null;
        this.errorMessage = errorMsg;
        this.statusCode = httpStatusCode;
    }
    
    // Constructor for exception
    public ApiResponse(Exception ex) {
        this.isSuccess = false;
        this.data = null;
        this.errorMessage = ex.getMessage();
        this.statusCode = -1;
    }
    
    // Helper method to create success response
    public static ApiResponse success(String data) {
        return new ApiResponse(data);
    }
    
    // Helper method to create error response
    public static ApiResponse error(String message, Integer statusCode) {
        return new ApiResponse(message, statusCode);
    }
    
    // Helper method to create exception response
    public static ApiResponse exception(Exception ex) {
        return new ApiResponse(ex);
    }
}