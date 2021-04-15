
# Flutter MapmyIndia GL  

  
This Flutter plugin allows to show embedded interactive and customizable vector maps inside a Flutter widget. For the Android and iOS integration. This project only supports a subset of the API exposed by these libraries.   
  
  
 
## Adding MapmyIndia Keys  
   
  
The **recommended** way to provide your keys through the `MapmyIndiaAccountManager` calss:

~~~dart
MapmyIndiaAccountManager.setMapSDKKey(ACCESS_TOKEN);  
MapmyIndiaAccountManager.setRestAPIKey(REST_API_KEY);  
MapmyIndiaAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);  
MapmyIndiaAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);
~~~
 
