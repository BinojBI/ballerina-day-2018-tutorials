import ballerina/io;
function main(string... args) {
    json j1 = [1, false, null, "foo", { first: "John", last: "Pala" }];
    io:println(j1);

    json j2 = j1[4];
    io:println(j2.first);
    j1[4] = 8.00;
    io:println(j1);

    json p = {
        fname: "John", lname: "Stallone",
        family: [{ fname: "Peter", lname: "Stallone" },
        { fname: "Emma", lname: "Stallone" },
        { fname: "Jena", lname: "Stallone" },
        { fname: "Paul", lname: "Stallone" }]
    };

    p.family[2].fname = "Alisha";
    io:println(p);

    json family = p.family;
    int l = lengthof family;
    io:println("length of array: " + l);
    
    int i = 0;
    while (i < l) {
        io:println(family[i]);
        i = i + 1;
    }
}
