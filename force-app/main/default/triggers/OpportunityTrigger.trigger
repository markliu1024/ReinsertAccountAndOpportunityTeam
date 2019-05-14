trigger OpportunityTrigger on Opportunity(before update, after update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
      OpportunityTriggerHandler.BeforeUpdate(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
      OpportunityTriggerHandler.ReinsertOpportunityTeamMembers(Trigger.new, Trigger.OldMap);
    }

}