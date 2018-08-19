import ballerina/io;
type Student object {
    public int age;
     public string name;
     new (name, age) {
        io:println(name);
        io:println(age);
    }

    // public int age=32,
    // public string name = "binoj",
    // public Student? parent,
    // private string email = "default@abc.com",
    // public string address = "No 20, Palm grove",
};

function main(string... args) {
     Student p1 = new Student("garu", 45);
    // io:println(p1);   
    // Student p2 = new();
    // io:println(p2);
    // Student p3 = new Student();
    // io:println(p2);
}
