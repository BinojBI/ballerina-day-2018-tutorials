import ballerina/http;
import ballerina/io;
import ballerina/log;

endpoint http:Client clientEndpoint {
    url: "https://postman-echo.com"
};

function main(string... args) {    http:Request req = new;
    var response = clientEndpoint->get("GET /v3.1/{100008447202023} HTTP/1.1
Host: graph.facebook.com");    match response {
        http:Response resp => {
            io:println("GET request:");
            var msg = resp.getJsonPayload();
            match msg {
                json jsonPayload => {
                    io:println(jsonPayload);
                }
                error err => {
                    log:printError(err.message, err = err);
                }
            }
        }
        error err => { log:printError(err.message, err = err); }
    }
    
}
