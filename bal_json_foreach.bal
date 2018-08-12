import ballerina/io;

function main (string... args) {
    string path="sample.json";

    io:ByteChannel byteChannel = io:openFile(path, io:READ);
    io:CharacterChannel ch=new io:CharacterChannel(byteChannel,"UTF8");

    json|error result = ch.readJson();

    json bookStore;
    match result {
        json j => {
          bookStore=j;  
          io:println(j.store.name);
        }
        error e => {
            io:println("Error occured while reading the file:", e.message);
            return;
        }
    }

    // io:println(bookStore.store.name);
    // io:println(bookStore["store"]["name"]);

//io:println(bookStore.store.books[0]);

foreach book in bookStore.store.books {
    //io:println(book);
    match book.year{
        int year => {
            if (year>1900) {
                io:println(book);
            }
        }
        any a =>{
            io:println("incorrect year:",a);
        }
    }
}
}
