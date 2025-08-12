@RestResource(urlMapping='/lead-api')
global with sharing class LeadAPI {
    global class LeadWrapper {
        public String firstName;
        public String lastName;
        public String email;
        public String company;

        public LeadWrapper(Lead l) {
            this.firstName = l.FirstName;
            this.lastName = l.LastName;
            this.email = l.Email;
            this.company = l.Company;
        }
    }

    @HttpGet
    global static List<LeadWrapper> getLeads() {
        List<LeadWrapper> leads = new List<LeadWrapper>();
        for (Lead l : [SELECT FirstName, LastName, Email, Company FROM Lead]) {
            leads.add(new LeadWrapper(l));
        }
        return leads;
    }
}