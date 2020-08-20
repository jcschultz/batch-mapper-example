public with sharing class BikeMapper {
    
    public BikeMapper() {}
    
    public Bicycle saveBike(Bicycle bikeInput) {
        // here we'll map from apex object to sObjects.
        
        Bicycle__c bike = new Bicycle__c();
        bike.Id = bikeInput.id;
        
        if (String.isNotBlank(bikeInput.name)) {
            bike.Name = bikeInput.name;
        }
        
        upsert bike;
        
        Frame__c bikeFrame = new Frame__c();
        bikeFrame.Id = bikeInput.bikeFrame.id;
        bikeFrame.Bicycle__c = bike.Id;
        
        if (bikeInput.bikeFrame.height != null) {
            bikeFrame.Height__c = bikeInput.bikeFrame.height;
        }
        
        if (bikeInput.bikeFrame.width != null) {
            bikeFrame.Width__c = bikeInput.bikeFrame.width;
        }
        
        upsert bikeFrame;
        
        List<Wheel__c> wheels = new List<Wheel__c>();
        for (Wheel w : bikeInput.wheels) {
            Wheel__c wheel = new Wheel__c();
            wheel.Id = w.id;
            wheel.bikeId = bike.Id;
            
            if (w.radius != null) {
                wheel.Radius__c = w.radius;
            }
            
            wheels.add(wheel);
        }
        
        upsert wheels;
        
        List<Reflector__c> reflectors = new List<Reflector__c>();
        Integer wheelIdx = 0;
        for (Wheel__c wheel : wheels) {
            Wheel w = bikeInput.wheels.get(wheelIdx);
            
            for (Reflector r : w.reflectors) {
                Reflector__c refl = new Reflector__c();
                refl.Id = r.id;
                refl.Wheel__c = wheel.Id;
                
                if (String.isNotBlank(r.color)) {
                    refl.Color__c = r.color;
                }
                
                if (r.width != null) {
                    refl.Width__c = r.width;
                }
                
                reflectors.add(refl);
            }
        }
        
        upsert reflectors;
        
        return getBike(bike.Id);
    }
    
    public Bicycle getBike(Id bikeId) {
        
        Bicyle__c bikeRecord = [
            SELECT 
                Id, 
                Name, 
                (
                    SELECT
                        Id,
                        Height__c,
                        Width__c
                    FROM Frames__r
                ),
                (
                    SELECT
                        Id,
                        Radius__c
                    FROM Wheels__r
                )
            FROM Bicycle__c
            WHERE Id = :bikeId
        ];
        
        Set<Id> wheelIds = new Set<Id>();
        for (Wheel__c wheel : bikeRecord.Wheels__r) {
            wheelIds.add(wheel.Id);
        }
        
        List<Reflector__c> reflectors = [
            SELECT
                Id,
                Color__c,
                Width__c,
                Wheel__c
            FROM Reflector__c
            WHERE Id IN :wheelIds
        ];
        
        Map<Id, <List>Reflector__c>> wheelToReflectorMap = new Map<Id, List<Reflector__c>>();
        
        for (Reflector__c r : reflectors) {
            if (!wheelToReflectorMap.contains(r.Wheel__c)) {
                wheelToReflectorMap.put(r.Wheel__c, new List<Reflector__c>());
            }
            
            wheelToReflectorMap.get(r.Wheel__c).add(r);
        }
        
        // send the records to the mapper method
        Bicycle bike = mapToApex(bikeRecord, wheelToReflectorMap);
        
        return bike;
    }
    
    private Bicycle mapToApex(Bicycle bikeRecord, Map<Id, List<Reflector__c>> reflectorRecords) {
        // this method maps the sobject fields to our apex object properties
        Bicycle bike = new Bicycle();
        bike.bikeFrame = new Frame();
        bike.wheels = new List<Wheel>();
        
        bike.bikeFrame.height = bikeRecord.Height__c;
        bike.bikeFrame.width = bikeRecord.Width__c;
        
        for (Wheel__c wheel : bikeRecord.Wheels__r) {
            Wheel w = new Wheel();
            w.id = wheel.Id;
            w.radius = wheel.Radius__c;
            w.reflectors = new List<Reflector>();
            
            for (Reflector__c r : reflectorRecords.get(wheel.Id)) {
                Reflector reflector = new Reflector();
                reflector.id = r.Id;
                reflector.color = r.Color__c;
                reflector.width = r.Width__c;
                
                w.reflectors.add(reflector);
            }
            
            bike.wheels.add(w);
        }
        
        return bike;
    }
}
