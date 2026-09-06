public with sharing class ResumeParseQueueable implements Queueable {


    private Id candidateId;

    public ResumeParseQueueable(Id candidateId){
            this.candidateId = candidateId;
    }
    
    public void execute(QueueableContext context) {
    
        // TODO: implement job logic here
        String mockResponseJson = '{"data":{"name":{"first":"Abhishek","last":"Kumar"},"totalYearOfExperince":3,"skills":[{"name":"Apex","name":"LWC","name":"Flows"}]}}';

        //Converts the JSON string into a real, typed ParsedResumeWrapper object, matching fields by name.
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
