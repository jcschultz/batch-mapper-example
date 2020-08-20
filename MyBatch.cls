public with sharing class MyBatch {
    
    public MyBatch() {}
    
    public void runBatch() {
        // this is the json string that will be parsed by the json mapper.
        // in our situation, this resides in a content note.
        String jsonString = '{' +
            '"frameHeight" : "32",' +
            '"frameWidth" : "2",' +
            '"wheelOneRadius" : "27",' +
            '"wheelOneReflectorOneColor" : "red",' +
            '"wheelOneReflectorOneWidth" : "3",' +
            '"wheelOneReflectorTwoColor" : "white",' +
            '"wheelOneReflectorTwoWidth" : "4",' +
            '"wheelTwoRadius" : "27",' +
            '"wheelTwoReflectorOneColor" : "white",' +
            '"wheelTwoReflectorOneWidth" : "4",' +
            '"wheelTwoReflectorTwoColor" : "blue",' +
            '"wheelTwoReflectorTwoWidth" : "1"' +
        '}';
        
        // call the json mapper to parse the json into an apex object.
        JsonToBikeMapper jsonMapper = new JsonToBikeMapper();
        Bicycle bikeFromJson = jsonMapper.parseJson(jsonString);
        
        // now that we've got an apex object, we'll call the mapper that
        // knows the database schema.
        BikeMapper myBikeMapper = new BikeMapper();
        Bicycle savedBike = myBikeMapper.saveBike(bikeFromJson);
    }
}
