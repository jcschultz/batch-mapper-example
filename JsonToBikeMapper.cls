public with sharing class JsonToBikeMapper {
    public JsonToBikeMapper() {
        
    }
    
    public Bicycle parseJson(String jsonString) {
        Map<String, Object> jsonObject = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        
        Bicycle bike = new Bicycle();
        bike.bikeFrame = new Frame();
        bike.wheels = new List<Wheel>();
        
        bike.bikeFrame.height = (Integer)jsonObject.get('frameHeight');
        bike.bikeFrame.width = (Integer)jsonObject.get('frameWidth');
        
        Wheel frontWheel = new Wheel();
        frontWheel.radius = (Integer)jsonObject.get('wheelOneRadius');
        
        frontWheel.reflectors = new List<Reflector>();
        
        Reflector ref1 = new Reflector();
        ref1.color = jsonObject.get('wheelOneReflectorOneColor');
        ref1.width = (Integer)jsonObject.get('wheelOneReflectorOneWidth');
        
        Reflector ref2 = new Reflector();
        ref2.color = jsonObject.get('wheelOneReflectorTwoColor');
        ref2.width = (Integer)jsonObject.get('wheelOneReflectorTwoWidth');
        
        frontWheel.reflectors.add(ref1, ref2);
        
        Wheel backWheel = new Wheel();
        backWheel.radius = (Integer)jsonObject.get('wheelTwoRadius');
        
        backWheel.reflectors = new List<Reflector>();
        
        Reflector ref3 = new Reflector();
        ref3.color = jsonObject.get('wheelTwoReflectorOneColor');
        ref3.width = (Integer)jsonObject.get('wheelTwoReflectorOneWidth');
        
        Reflector ref4 = new Reflector();
        ref4.color = jsonObject.get('wheelTwoReflectorTwoColor');
        ref4.width = (Integer)jsonObject.get('wheelTwoReflectorTwoWidth');
        
        backWheel.reflectors.add(ref3, ref4);
        
        bike.wheels.add(frontWheel, backWheel);
        
        
        return bike;
    }
}
