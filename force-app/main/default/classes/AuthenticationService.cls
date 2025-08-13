public with sharing class AuthenticationService {
    private static final String BASE_ENDPOINT = 'callout:API_URL_CONVOSO/api/v1/agent/sessions';
    
    /**
     * Creates a new session
     * @return Session data or null on error
     */
    public static Object createSession() {
        return HttpCalloutService.post(BASE_ENDPOINT, null, 'Create session');
    }

    /**
     * Logs into an existing session
     * @param sessionId The session ID
     * @param payload Login payload
     * @return Session data or null on error
     */
    public static Object sessionLogin(String sessionId, Object payload) {
        String endpoint = BASE_ENDPOINT + '/' + sessionId;
        String requestBody = payload != null ? JSON.serialize(payload) : null;
        return HttpCalloutService.post(endpoint, requestBody, 'Session login');
    }

    /**
     * Gets session information
     * @param sessionId The session ID
     * @return Session data or null on error
     */
    public static Object getSession(String sessionId) {
        String endpoint = BASE_ENDPOINT + '/' + sessionId;
        return HttpCalloutService.get(endpoint, 'Get session');
    }

    /**
     * Deletes a session
     * @param sessionId The session ID
     * @return Response data or null on error
     */
    public static Object deleteSession(String sessionId) {
        String endpoint = BASE_ENDPOINT + '/' + sessionId;
        return HttpCalloutService.deleteRequest(endpoint, 'Delete session');
    }
}