import ballerina/http;
import ballerina/io;

http:Client clientEP = new ("https://api.github.com");

@http:ServiceConfig {
    basePath: "/github",
    cors: {
        allowOrigins: ["*"]
    }
}

service githubService on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/issues/{repositoryOwner}/{repository}"
    }
    resource function retrieveAllIssuesFromRepository(http:Caller caller, http:Request req, string repositoryOwner, string repository) {

        http:Response response = new;
        string url = "/repos/" + repositoryOwner + "/" + repository + "/issues?state=all";
        http:Response | error githubResponse = clientEP->get(<@untained>url);

        json | error jsonPayload = checkGithubResponse(githubResponse);

        if (jsonPayload is json) {
            response.statusCode = 200;
            response.setJsonPayload(<@untained>jsonPayload);
        } else {
            response.statusCode = 500;
            response.setPayload(<@untained>jsonPayload.reason());
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/repositories/{repositoryOwner}"
    }
    resource function retrieveAllRepositories(http:Caller caller, http:Request req, string repositoryOwner) {

        http:Response response = new;
        string url = "/users/" + repositoryOwner + "/repos";
        http:Response | error githubResponse = clientEP->get(<@untained>url);

        if (githubResponse is http:Response) {

            json | error jsonPayload = githubResponse.getJsonPayload();

            if (jsonPayload is json[]) {

                json | error formattedPayload = convertRepositoriesToJSONFormat(jsonPayload);
                if (formattedPayload is json) {
                    response.statusCode = 200;
                    response.setJsonPayload(<@untained>formattedPayload);
                } else {
                    response.statusCode = 500;
                    response.setPayload(<@untained>formattedPayload.reason());
                }
            } else if (jsonPayload is error) {
                response.statusCode = 500;
                response.setPayload(<@untained>jsonPayload.reason());
            }
        } else {
            response.statusCode = 500;
            response.setPayload(githubResponse.reason());
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/repositories/{repositoryOwner}/{repository}"
    }
    resource function postAnIssue(http:Caller caller, http:Request req, string repositoryOwner, string repository) {

        http:Response response = new;
        string url = "users/" + repositoryOwner + "/repos";
        http:Response | error githubResponse = clientEP->get(<@untained>url);

        json | error jsonPayload = checkGithubResponse(githubResponse);

        if (jsonPayload is json) {
            response.statusCode = 200;
            response.setJsonPayload(<@untained>jsonPayload);
        } else {
            response.statusCode = 500;
            response.setPayload(<@untained>jsonPayload.reason());
        }

        error? respond = caller->respond(response);
    }
}

function checkGithubResponse(http:Response | error response) returns @tainted json | error {

    if (response is http:Response) {
        json | error jsonPayload = response.getJsonPayload();

        if (jsonPayload is error) {
            return error(jsonPayload.reason());
        } else {
            return jsonPayload;
        }
    } else {
        return error(response.reason());
    }
}

function convertRepositoriesToJSONFormat(json[] repositoriesList) returns @tainted json | error {

    string stringRepositories = "[ ";

    foreach json repository in repositoriesList {
        map<json> repoDetails = <map<json>>repository;

        json JSON = {"id": repoDetails.id.toString(), "name": repoDetails.name.toString(), "description": repoDetails.description.toString()};
        stringRepositories = stringRepositories + JSON.toJsonString() + ", ";
    }
    stringRepositories = stringRepositories.substring(0, stringRepositories.length() - 2);
    stringRepositories = stringRepositories + " ]";

    io:StringReader stringReader = new (stringRepositories, encoding = "UTF-8");
    json | error jsonRepositories = stringReader.readJson();

    return jsonRepositories;
}
