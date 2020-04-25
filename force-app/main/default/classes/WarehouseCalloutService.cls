public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {       
        // Construct the Http request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        
        // Make the Http request
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            // Deserialize JSON response and parse it into a list of Objects
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            
            List<Product2> productsList = new List<Product2>();
            
            for(Object objectLooper : results)
            { 
                // Convert each record into a map, with the field names in the keyset
                Map<String, Object> objectsMap = (Map<String, Object>) objectLooper;
                
                Product2 product = new Product2();
                
                product.ProductCode = (String)objectsMap.get('_id');
                product.Cost__c = (Integer)objectsMap.get('cost');
                product.Lifespan_Months__c = (Integer)objectsMap.get('lifespan');
                product.Maintenance_Cycle__c = (Integer)objectsMap.get('maintenanceperiod');
                product.Name  = (String)objectsMap.get('name'); 
                product.Current_Inventory__c = (Integer)objectsMap.get('qIntegerntity');
                product.Replacement_Part__c = (Boolean)objectsMap.get('replacement');
                product.Warehouse_SKU__c = (String) objectsMap.get('sku');
                
                productsList.add(product);
            }
            upsert productsList;
        }    
    }
}