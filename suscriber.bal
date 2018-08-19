import ballerina/http;
import ballerina/log;
import ballerina/websub;endpoint http:Listener listener {
    port: 9090
};
@final string ORDER_TOPIC = "http://localhost:9090/ordermgt/ordertopic";
map<json> orderMap;
websub:WebSubHub webSubHub = startHubAndRegisterTopic();@http:ServiceConfig {
    basePath: "/ordermgt"
}
service<http:Service> orderMgt bind listener {
    @http:ResourceConfig {
        methods: ["GET", "HEAD"],
        path: "/order"
    }
    discoverPlaceOrder(endpoint caller, http:Request req) {
        http:Response response;
        websub:addWebSubLinkHeader(response, [webSubHub.hubUrl], ORDER_TOPIC);
        response.statusCode = 202;
        caller->respond(response) but {
            error e => log:printError("Error responding on ordering", err = e)
        };
    }
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order"
    }
    placeOrder(endpoint caller, http:Request req) {
        json orderReq = check req.getJsonPayload();
        string orderId = orderReq.Order.ID.toString();
        orderMap[orderId] = orderReq;
        http:Response response;
        response.statusCode = 202;
        caller->respond(response) but {
            error e => log:printError("Error responding on ordering", err = e)
        };
        string orderCreatedNotification = "New Order Added: " + orderId;
        log:printInfo(orderCreatedNotification);
        webSubHub.publishUpdate(ORDER_TOPIC, orderCreatedNotification) but {
            error e => log:printError("Error publishing update", err = e)
        };
    }}
function startHubAndRegisterTopic() returns websub:WebSubHub {
    websub:WebSubHub internalHub = websub:startHub(9191) but {
        websub:HubStartedUpError hubStartedUpErr => hubStartedUpErr.startedUpHub
    };
    internalHub.registerTopic(ORDER_TOPIC) but {
        error e => log:printError("Error registering topic", err = e)
    };
    return internalHub;
}
import ballerina/log;
import ballerina/websub;
endpoint websub:Listener websubEP {
    port: 8181
};
@websub:SubscriberServiceConfig {
    path: "/ordereventsubscriber",
    subscribeOnStartUp: true,
    resourceUrl: "http://localhost:9090/ordermgt/order",
    leaseSeconds: 3600,
    secret: "Kslk30SNF2AChs2"
}
service websubSubscriber bind websubEP {
    onNotification(websub:Notification notification) {
        match (notification.getPayloadAsString()) {
            string payloadAsString => log:printInfo("WebSub Notification Received: "
                    + payloadAsString);
            error e => log:printError("Error retrieving payload as string", err = e);
        }
    }
}
