public with sharing class AuthenticationController {
    @AuraEnabled(cacheable=false)
    public static Object createSession() {
        return AuthenticationService.createSession();
    }

    @AuraEnabled(cacheable=false)
    public static Object sessionLogin(String sessionId, Object payload) {
        return AuthenticationService.sessionLogin(sessionId, payload);
    }

    @AuraEnabled(cacheable=false)
    public static Object getSession(String sessionId) {
        return AuthenticationService.getSession(sessionId);
    }

    @AuraEnabled(cacheable=false)
    public static Object deleteSession(String sessionId) {
        return AuthenticationService.deleteSession(sessionId);
    }
}