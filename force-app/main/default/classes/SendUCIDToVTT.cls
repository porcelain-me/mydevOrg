public class SendUCIDToVTT {


    public static HttpResponse makeGetCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal: animals) {
                System.debug(animal);
            }
        }
        return response;
    }
    public static HttpResponse makePostCallout(String UCID, String langCode, Boolean isPhonecall) { //String UCID, String langCode, Boolean isPhonecall
       
        String requestBody = '{\"uniqueID\": '+ UCID +',\"languageCode\": '+ langCode +',\"isPhonecall\": '+ isPhonecall +'}';
        String jsonBody  = Json.serialize(requestBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://vtt.observanteye.com/api/vtt/convertvoicetotext');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug('recived from web is '+response.getBody());
        }
        return response;
    }        
}