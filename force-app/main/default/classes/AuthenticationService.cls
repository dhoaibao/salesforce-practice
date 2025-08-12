public with sharing class AuthenticationService {
    @AuraEnabled(cacheable=false)
    public static String createSession() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:API_URL_CONVOSO/api/v1/agent/sessions');
        request.setMethod('POST');
        
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                return response.getBody();
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' - ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
            return null;
        }
    }
}