# function-barcode
Cloud function barcode



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
   ```json
       {
         "scripts": {
            "start": "functions-framework --target=convertBarcode"
          }
       }
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





### resources

- [functions](https://cloud.google.com/functions)
- [jsBarcode](https://github.com/lindell/JsBarcode)
