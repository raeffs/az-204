import { AzureFunction, Context, HttpRequest } from "@azure/functions";

const httpTrigger: AzureFunction = async function (
    context: Context,
    request: HttpRequest,
    document: any
): Promise<void> {
    context.log("HTTP trigger function processed a request.");

    if (!document) {
        const message = `Todo item with id ${request.query.id} not found`;
        context.log(message);

        context.res = {
            status: 404,
            body: message,
        };

        context.bindings.output = message;
    } else {
        context.log(`Todo item found, description: ${document.desc}`);
        context.res = {
            body: document.desc,
        };
    }
};

export default httpTrigger;
