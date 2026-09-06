public class ParsedResumeWrapper {
    
    public Data data;
    public class Data{
        public Name name;
        public Integer totalYearsExperience;
        public List<Skill> skills;
    }
    
    public class Name{
        public String first;
        public String last;
    }
    
    public class Skill{
        public String name;
    }
    public ParsedResumeWrapper() {
        
    }
}