public without sharing class AccountTriggerHandler {

    private static Map<Id, List<AccountTeamMember>> bulkifyMap = new Map<Id, List<AccountTeamMember>>();
	
    public static void BeforeUpdate(List<Account> scope, Map<Id, Account> oldMap) {
        CollectAccountTeamMembers(scope);
    }
    
    public static void AfterUpdate(List<Account> scope, Map<Id, Account> oldMap) {
        ReinsertAccountTeamMembers(scope, oldMap);
    }
    
    public static void CollectAccountTeamMembers(List<Account> scope) {
        List<Team_Setting__mdt> ats = [SELECT MasterLabel, Account_Team_Exclusion__c FROM Team_Setting__mdt WHERE Account_Team_Exclusion__c = true];
        Set<String> roleSet = new Set<String>();
        if (ats.isEmpty() == false) {
            
            for (Team_Setting__mdt atSettings: ats) {
                roleSet.add(atSettings.MasterLabel);
            }
            
        }
        List<AccountTeamMember> accountTeamMembers = [SELECT Id, AccountId, AccountAccessLevel, CaseAccessLevel, ContactAccessLevel, OpportunityAccessLevel, TeamMemberRole, UserId
                                FROM AccountTeamMember
                                WHERE AccountId IN :scope /*AND TeamMemberRole != 'ISR'*/ AND TeamMemberRole NOT IN: roleSet];

        Set<Id> userIds = new Set<Id>();
        for(AccountTeamMember accountTeamMember : accountTeamMembers) {
            userIds.add(accountTeamMember.UserId);
        }

        List<User> inactiveUsers = [SELECT Id FROM User WHERE Id IN :userIds AND IsActive = FALSE];
        Set<Id> inactiveUserIds = new Set<Id>();
        for(User inactiveUser : inactiveUsers) {
            inactiveUserIds.add(inactiveUser.Id);
        }
        for(Integer i = 0; i < accountTeamMembers.size(); i++) {
            if(inactiveUserIds.contains(accountTeamMembers[i].UserId)) {
                accountTeamMembers.remove(i);
                i--;
            }
        }
                                
        if (accountTeamMembers.isEmpty() == false) {
            for (AccountTeamMember accT: accountTeamMembers) {
                if (bulkifyMap.containsKey(accT.AccountId)) {
                    List<AccountTeamMember> lstAtm = bulkifyMap.get(accT.AccountId);
                    lstAtm.add(accT);
                } else {
                    List<AccountTeamMember> lstAtm = new List<AccountTeamMember>();
                    lstAtm.add(accT);
                    bulkifyMap.put(accT.AccountId, lstAtm);
                }
            }
        }
    }
    
    public static void ReinsertAccountTeamMembers(List<Account> scope, Map<Id, Account> oldMap) {
        if (bulkifyMap.isEmpty() == false) {
        List<AccountTeamMember> toInsertAccountTeamMembers = new List<AccountTeamMember>();
        
        for(Account account : scope) {
            if(account.OwnerId != oldMap.get(account.Id).OwnerId) {
                for(AccountTeamMember accountTeamMember : bulkifyMap.get(account.Id)) {
                    if(accountTeamMember != null) {
                        if(accountTeamMember.AccountId == account.Id) {
                            toInsertAccountTeamMembers.add(new AccountTeamMember(AccountId = accountTeamMember.AccountId,
                                                                                    AccountAccessLevel = accountTeamMember.AccountAccessLevel,
                                                                                    CaseAccessLevel = accountTeamMember.CaseAccessLevel,
                                                                                    ContactAccessLevel = accountTeamMember.ContactAccessLevel,
                                                                                    OpportunityAccessLevel = accountTeamMember.OpportunityAccessLevel,
                                                                                    TeamMemberRole = accountTeamMember.TeamMemberRole,
                                                                                    UserId = accountTeamMember.UserId));
                        }
                    }
                }
            }
        }
        insert(toInsertAccountTeamMembers);
        }

        
    }

}