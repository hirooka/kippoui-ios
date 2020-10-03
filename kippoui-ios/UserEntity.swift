import CoreData

extension UserEntity {
    static func create(in managedObjectContext: NSManagedObjectContext) {
        let newUserEnriry = self.init(context: managedObjectContext)
        newUserEnriry.uuid = UUID()
        newUserEnriry.timestamp = Date()
        newUserEnriry.name = "名無し"
        
        do {
            try managedObjectContext.save()
        } catch {
            //
        }
    }
}
