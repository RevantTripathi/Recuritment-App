public with sharing class ResumeParseQueueable implements Queueable {
    
    
    private Id candidateId;
    
    public ResumeParseQueueable(Id candidateId){
        this.candidateId = candidateId;
    }
    
    public void execute(QueueableContext context) {
        
        // TODO: implement job logic here
        String mockResponseJson = '{"data":{"name":{"first":"Abhishek","last":"Kumar"},"totalYearOfExperince":3,"skills":[{"name":"Apex"},{"name":"LWC"},{"name":"Flows"}]}}';
        
    //VersionData is the actual FILE CONTENT itself, stored as a Blob — this is the binary data we need to send.
        ContentVersion cv = [ SELECT VersionData, Title FROM ContentVersion WHERE FirstPublishLocationId = :candidateId ORDER BY CreatedDate DESC LIMIT 1 ];
        //Converts the JSON string into a real, typed ParsedResumeWrapper object, matching fields by name (including nested objects/lists). Cast is required since JSON.deserialize() returns a generic Object.

        //JSON is just a text, and apex code needs real object to iterate and access the nested data (throught dot notation)
        ParsedResumeWrapper parsed = (ParsedResumeWrapper) JSON.deserialize(mockResponseJson, ParsedResumeWrapper.class);
        
        List<String> skillNames = new List<String>();
        for (ParsedResumeWrapper.Skill skill : parsed.data.skills) {
            skillNames.add(skill.name);
        }
        
        String skillsJoined = String.join(skillNames, ', ');
        Candidate__c candToUpdate = new Candidate__c( Id = candidateId, Parsed_Skills__c = skillsJoined, Parsed_JSON__c = mockResponseJson, Parse_Status__c = 'Success' );
        
        update candToUpdate;
    }
    
    
}