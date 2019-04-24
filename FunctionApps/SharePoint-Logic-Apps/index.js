module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');
    context.log(req.body);
    
    //https://westus.dev.cognitive.microsoft.com/docs/services/5a93fcf85b4ccd136866eb37/operations/5ac266295b4ccd1554da7600
    var objtemplate = {
        "add":
        {
            "qnaList":
            [
                {
                    "id": 0,
                    "answer": req.body.Title,
                    "source": 'sharepoint',
                    "questions": [
                        "Test question?"
                    ],
                    "metadata": []
                }
            ]
        }
    };
    var resp = JSON.stringify(objtemplate);
    if (resp) {
        context.res = {
            // status: 200, /* Defaults to 200 */
            body: resp
        };
    }
    else {
        context.res = {
            status: 400,
            body: "Please pass a name on the query string or in the request body"
        };
    }
};