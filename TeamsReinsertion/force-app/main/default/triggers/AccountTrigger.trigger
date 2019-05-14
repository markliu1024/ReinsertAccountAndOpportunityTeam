trigger AccountTrigger on Account(before update, after update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.BeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        AccountTriggerHandler.AfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
}