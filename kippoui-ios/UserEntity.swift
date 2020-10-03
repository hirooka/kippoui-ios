import CoreData

extension UserEntity {
    static func create(name: String, birthday: Date, in managedObjectContext: NSManagedObjectContext) {
        let newUserEnriry = self.init(context: managedObjectContext)
        newUserEnriry.uuid = UUID()
        newUserEnriry.timestamp = Date()
        if name == "" {
            newUserEnriry.name = "名無し"
        } else {
            newUserEnriry.name = name
        }
        newUserEnriry.birthday = birthday
        
        do {
            try managedObjectContext.save()
        } catch {
            //
        }
    }
}

extension Collection where Element == UserEntity, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach {
            managedObjectContext.delete(self[$0])
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            //
        }
    }
}
