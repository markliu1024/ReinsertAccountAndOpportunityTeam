public without sharing class OpportunityTriggerHandler {

    private static Map<Id, List<OpportunityTeamMember>> bulkifyMap = new Map<Id, List<OpportunityTeamMember>>();

    public static void BeforeUpdate(List<Opportunity> triggerNew) {
        CollectOpportunityTeamMembers(triggerNew);
    }


    public static void CollectOpportunityTeamMembers (List<Opportunity> scope) {
        List<Team_Setting__mdt> ats = [SELECT MasterLabel FROM Team_Setting__mdt WHERE Opportunity_Team_Exclusion__c = true];
        Set<String> roleSet = new Set<String>();
        if (ats.isEmpty() == false) {
            
            for (Team_Setting__mdt atSettings: ats) {
                roleSet.add(atSettings.MasterLabel);
            }
            
        }
        List<OpportunityTeamMember> opptyTeamMembers = [SELECT Id, OpportunityId, OpportunityAccessLevel, TeamMemberRole, UserId
                                FROM OpportunityTeamMember
                                WHERE OpportunityId IN :scope AND TeamMemberRole NOT IN: roleSet];
                                
        if (opptyTeamMembers.isEmpty() == false) {
            for (OpportunityTeamMember oppT: opptyTeamMembers) {
                if (bulkifyMap.containsKey(oppT.OpportunityId)) {
                    List<OpportunityTeamMember> lstAtm = bulkifyMap.get(oppT.OpportunityId);
                    lstAtm.add(oppT);
                } else {
                    List<OpportunityTeamMember> lstAtm = new List<OpportunityTeamMember>();
                    lstAtm.add(oppT);
                    bulkifyMap.put(oppT.OpportunityId, lstAtm);
                }
            }
        }
    }

    public static void ReinsertOpportunityTeamMembers(List<Opportunity> triggerNew, Map<Id, Opportunity> triggerOldMap) {
        if (bulkifyMap.isEmpty() == false) {
            List<OpportunityTeamMember> toInsertOpportunityTeamMembers = new List<OpportunityTeamMember>();
        
            for(Opportunity opp:triggerNew) {
                if(opp.OwnerId != triggerOldMap.get(opp.Id).OwnerId) {
                    for(OpportunityTeamMember oppTeamMember : bulkifyMap.get(opp.Id)) {
                        if(oppTeamMember.OpportunityId == opp.Id) {
                            toInsertOpportunityTeamMembers.add(new OpportunityTeamMember(OpportunityId = oppTeamMember.OpportunityId,
                                                                                    //CurrencyIsoCode = oppTeamMember.CurrencyIsoCode,
                                                                                    OpportunityAccessLevel = oppTeamMember.OpportunityAccessLevel,
                                                                                    TeamMemberRole = oppTeamMember.TeamMemberRole,
                                                                                    UserId = oppTeamMember.UserId));
                        }
                    }
                }
            }
            insert(toInsertOpportunityTeamMembers);
        }

        
    }

}