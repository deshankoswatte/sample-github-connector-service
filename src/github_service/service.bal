import ballerina/http;

http:Client gitHubAPIEndpoint = new (GITHUB_API_URL);
listener http:Listener servicesEndPoint = new (SERVICES_PORT);

@http:ServiceConfig {
    basePath: BASEPATH,
    cors: {
        allowOrigins: ["*"]
    }
}

service githubService on servicesEndPoint {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/issues/{issueNumber}"
    }
    resource function retrieveAnIssueFromRepository(http:Caller caller, http:Request request, string issueNumber) {

        http:Request callBackRequest = new;
        callBackRequest.addHeader("Authorization", ACCESS_TOKEN);
        http:Response response = new;

        string url = "/repos/" + ORGANIZATION_NAME + "/" + REPOSITORY_NAME + "/issues/" + issueNumber;
        http:Response | error gitHubResponse = gitHubAPIEndpoint->get(<@untained>url, callBackRequest);

        if (gitHubResponse is http:Response) {
            if (gitHubResponse.statusCode == http:STATUS_OK) {
                json | error jsonPayload = gitHubResponse.getJsonPayload();
                if (jsonPayload is json) {
                    response.statusCode = http:STATUS_OK;
                    response.setJsonPayload(<@untained>jsonPayload);
                } else {
                    response.statusCode = http:STATUS_BAD_REQUEST;
                    response.setPayload(<@untained>jsonPayload.reason());
                }
            } else {
                response.statusCode = gitHubResponse.statusCode;
                response.setPayload("The github response status code was not at the acceptable status code of 200.");
            }

        } else {
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload(gitHubResponse.reason());
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/issues"
    }
    resource function retrieveAllIssuesFromRepository(http:Caller caller, http:Request request) {

        http:Request callBackRequest = new;
        callBackRequest.addHeader("Authorization", ACCESS_TOKEN);
        http:Response response = new;

        string url = "/repos/" + ORGANIZATION_NAME + "/" + REPOSITORY_NAME + "/issues?state=all";
        http:Response | error gitHubResponse = gitHubAPIEndpoint->get(<@untained>url, callBackRequest);

        if (gitHubResponse is http:Response) {
            if (gitHubResponse.statusCode == http:STATUS_OK) {
                json | error jsonPayload = gitHubResponse.getJsonPayload();
                if (jsonPayload is json) {
                    response.statusCode = http:STATUS_OK;
                    response.setJsonPayload(<@untained>jsonPayload);
                } else {
                    response.statusCode = http:STATUS_BAD_REQUEST;
                    response.setPayload(<@untained>jsonPayload.reason());
                }
            } else {
                response.statusCode = gitHubResponse.statusCode;
                response.setPayload("The github response status code was not at the acceptable status code of 200.");
            }

        } else {
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload(gitHubResponse.reason());
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/issues/postIssue"
    }
    resource function postAnIssueInARepository(http:Caller caller, http:Request request) {

        http:Request callBackRequest = new;
        callBackRequest.addHeader("Authorization", ACCESS_TOKEN);
        http:Response response = new;

        string url = "/repos/" + ORGANIZATION_NAME + "/" + REPOSITORY_NAME + "/issues";
        json | error receivedRequestPayload = request.getJsonPayload();

        if (receivedRequestPayload is json) {
            callBackRequest.setPayload(<@untained>receivedRequestPayload);
            http:Response | error gitHubResponse = gitHubAPIEndpoint->post(<@untained>url, callBackRequest);
            if (gitHubResponse is http:Response) {
                if (gitHubResponse.statusCode == http:STATUS_CREATED) {
                    response.statusCode = http:STATUS_CREATED;
                    response.setPayload("Issue created successfully.");
                } else {
                    response.statusCode = gitHubResponse.statusCode;
                    response.setPayload("The github response status code was not at the acceptable status code of 201.");
                }
            } else {
                response.statusCode = http:STATUS_BAD_REQUEST;
                response.setPayload(gitHubResponse.reason());
            }
        } else {
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload(<@untained>receivedRequestPayload.reason());
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["PATCH"],
        path: "/issues/editIssue/{issueNumber}"
    }
    resource function editAnIssueInARepository(http:Caller caller, http:Request request, string issueNumber) {

        http:Request callBackRequest = new;
        callBackRequest.addHeader("Authorization", ACCESS_TOKEN);
        http:Response response = new;

        string url = "/repos/" + ORGANIZATION_NAME + "/" + REPOSITORY_NAME + "/issues/" + issueNumber;
        json | error receivedRequestPayload = request.getJsonPayload();

        if (receivedRequestPayload is json) {
            callBackRequest.setJsonPayload(<@untained>receivedRequestPayload);
            http:Response | error gitHubResponse = gitHubAPIEndpoint->patch(<@untained>url, callBackRequest);
            if (gitHubResponse is http:Response) {
                if (gitHubResponse.statusCode == http:STATUS_OK) {
                    response.statusCode = http:STATUS_OK;
                    response.setPayload("Issue updated successfully.");
                } else {
                    response.statusCode = gitHubResponse.statusCode;
                    response.setPayload("The github response status code was not at the acceptable status code of 200.");
                }
            } else {
                response.statusCode = http:STATUS_BAD_REQUEST;
                response.setPayload(gitHubResponse.reason());
            }
        } else {
            response.statusCode = http:STATUS_BAD_REQUEST;
            response.setPayload(<@untained>receivedRequestPayload.reason());
        }

        error? respond = caller->respond(response);
    }
}
