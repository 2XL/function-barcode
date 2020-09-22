# function-barcode
Cloud function barcode

Example
```bash

$ terraform apply
data.template_file.package_json: Refreshing state... [id=##]
data.template_file.index_js: Refreshing state... [id=##]
null_resource.example: Refreshing state... [id=##]
data.archive_file.index: Refreshing state... [id=##]
data.google_project.p: Refreshing state... [id=projects/##]
google_project_service.cloudfunctions: Refreshing state... [id=##/cloudfunctions.googleapis.com]
google_project_service.cloudbuild: Refreshing state... [id=##/cloudbuild.googleapis.com]
google_storage_bucket.bucket: Refreshing state... [id=##-cloud-functions-bucket]
google_storage_bucket_object.archive: Refreshing state... [id=##-cloud-functions-bucket-index.zip]
google_cloudfunctions_function.function: Refreshing state... [id=projects/##/locations/europe-west1/functions/function-barcode]
google_cloudfunctions_function_iam_member.invoker: Refreshing state... [id=projects/##/locations/europe-west1/functions/function-barcode/roles/cloudfunctions.invoker/allusers]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

archive_file = archive_file.index.zip t+h+ngPo6EL1rEHsf+f0h06+cEL5OqW95XH5Cd7egq0=
function_endpoint = https://europe-west1-##.cloudfunctions.net/function-barcode
function_endpoint_example_query = https://europe-west1-##.cloudfunctions.net/function-barcode/?format=upc&value=796030114977

```

### TODO
- use jsBarcode - nodejs container
- create Container with api
- deploy to google cloud functions



### GOAL

```bash

endpoint 

URL/api/{FORMAT}/{VALUE}

example

URL/api/UPC/123456789012

response

"image file"
```


### ENV

```
FUNCTION_TARGET=convertBarcode



```


### SETPS

1. preparing the cloud function

    ```bash
    index.js
    package.json
    ```

2. test cloud function locally
   
   ```
   npm install @google-cloud/functions-framework
   
   ```
   
   package.json
   ```js
       [{
       "scripts" : {
            "start": "functions-framework --target=convertBarcode"
          }
       }]   
    ```
   
   npm start
   
   ```

3. generating a github personal access token

   ```
   SET CLOUD PROVIDER API TOKEN
   
   gcloud auth login

   
   ```

4. Deploying the Cloud Function

   ```
   terraform plan
   ```

5. Manual deployment
    
   ```
   gcloud functions deploy ${FUNCTION_TARGET} \
    --trigger-http \
    --runtime="nodejs10"
   
   output:
   ... url endpoint where the function is exposed.
    
   ```

6. Logging
    
   ```
   logs are exposed through cloud  events.
   ```

### resources

- [functions](https://cloud.google.com/functions)
- [jsBarcode](https://github.com/lindell/JsBarcode)

### common issues

- the user does not have permission to access project "..." or it may not exist

