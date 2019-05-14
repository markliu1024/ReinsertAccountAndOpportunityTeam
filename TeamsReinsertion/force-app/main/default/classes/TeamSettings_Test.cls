@isTest
private class TeamSettings_Test{
    
    //Variable Declaration
    public static UserRole r ;
        
    public static testMethod void AgronomistTest1(){
            
        r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Jay',
            Email = 'Jay@test.com',
            Username = 'Jay@test.com' + System.currentTimeMillis(),
            CompanyName = 'test company',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            Country = 'United States'
        );
        
        insert u1;
      
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Raju',
            Email = 'raju@test.com',
            Username = 'raju@test.com' + System.currentTimeMillis(),
            CompanyName = 'Test pvt ltd',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            Country = 'United States'
        );    
        insert u2;         
                
        System.runAs(u1){
            
            //Set up account
            Account acc = new Account();
            acc.OwnerId=u1.Id;
            acc.Name = 'Acme Account Test';
            //acc.BillingCountryCode = 'US';        
            //acc.BillingStateCode = 'IL';
            //acc.ShippingCountryCode = 'US';
            //acc.ShippingStateCode = 'NY';
            insert acc;
            System.debug('account owner Id'+acc.OwnerId);   
            
            //Set up Opportunity
            Opportunity opp = new Opportunity(
            	CloseDate = System.Today(),
                Name = 'test Opp',
                StageName = 'Prospecting',
                AccountId = acc.Id
            );
            insert opp;
            
            OpportunityTeamMember otm = new OpportunityTeamMember(
                UserId = u1.Id,
                OpportunityId = opp.Id,
                OpportunityAccessLevel = 'Edit',
                TeamMemberRole = 'Account Manager'
            );
            insert otm;
            
            
            /*Agronomist_Mapping__c AM = new Agronomist_Mapping__c();
            AM.Account_Manager__c =u1.id;
            AM.Agronomist__c = u2.id;        
            insert AM;
            AM.Agronomist__c = u1.id;
            update AM;
            System.debug('Account manager Id'+ AM.Account_Manager__c);        
    
            Agronomist_Mapping__c AM1 = new Agronomist_Mapping__c();
            AM1.Account_Manager__c =u1.id;
            AM1.Agronomist__c = u2.id;        
            insert AM1;
            AM1.Agronomist__c = u1.id;
            update AM1;    
			*/
    
            AccountTeamMember atm=new AccountTeamMember();
            atm.userId=u1.Id;
            atm.AccountId=acc.Id;
            atm.AccountAccessLevel='Edit';
            atm.ContactAccessLevel='Read';
            atm.OpportunityAccessLevel='Edit';
            atm.CaseAccessLevel='Read';
            atm.TeamMemberRole='Account Manager';
            insert atm;

            AccountTeamMember atm1 = new AccountTeamMember(
                UserId = u2.Id,
                AccountId = acc.Id,
                AccountAccessLevel = 'Edit',
                ContactAccessLevel = 'Read',
                OpportunityAccessLevel = 'Edit',
                CaseAccessLevel = 'Read',
                TeamMemberRole = 'Account Manager'
                );
            insert atm1;

            acc.OwnerId = u2.Id;
            update acc;
            
            opp.OwnerId = u2.Id;
            update opp;
        }

    }//End of the method, AgronomistTest1
    
    public static testMethod void AgronomistTest2(){
                    
        r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
            
        User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Jay',
            Email = 'Jay@test.com',
            Username = 'Jay@test.com' + System.currentTimeMillis(),
            CompanyName = 'test company',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            Country = 'United States'
        );
        
        insert u1;
      
        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Raju',
            Email = 'raju@test.com',
            Username = 'raju@test.com' + System.currentTimeMillis(),
            CompanyName = 'Test pvt ltd',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.Id,
            Country = 'United States'
        );    
        insert u2;
             
        System.runAs(u1) {
            
            //Set up account
            Account acc = new Account();
            acc.OwnerId=u1.Id;
            acc.Name = 'Acme Account Test';
            //acc.BillingCountryCode = 'US';        
            //acc.BillingStateCode = 'IL';
            //acc.ShippingCountryCode = 'US';
            //acc.ShippingStateCode = 'NY';
            insert acc;
            System.debug('account owner Id'+acc.OwnerId); 
            
            
            /*Agronomist_Mapping__c AM = new Agronomist_Mapping__c();
            AM.Account_Manager__c =u1.id;
            AM.Agronomist__c = u2.id;        
            insert AM;
            AM.Agronomist__c = u1.id;
            update AM;
            System.debug('Account manager Id'+ AM.Account_Manager__c);         
            delete AM;        
			*/
  
            AccountTeamMember atm=new AccountTeamMember();
            atm.userId=u1.Id;
            atm.AccountId=acc.Id;
            atm.AccountAccessLevel='Edit';
            atm.ContactAccessLevel='Read';
            atm.OpportunityAccessLevel='Edit';
            atm.CaseAccessLevel='Read';
            atm.TeamMemberRole='Account Manager';
            insert atm;
        }

    }//End of the Method, AgronomistTest2
}//End of the Test Class