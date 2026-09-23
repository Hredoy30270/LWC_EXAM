public with sharing class OpportunityController {

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {

        return [
            SELECT Id,
                   Name,
                   StageName,
                   Amount,
                   Probability,
                   Expected_Revenue_Overridden__c,
                   CloseDate
            FROM Opportunity
            WHERE CloseDate = THIS_MONTH
              AND StageName NOT IN (
                  'Proposal/Price Quote',
                  'Negotiation/Review',
                  'Closed Won',
                  'Closed Lost'
              )
        ];
    }


    @AuraEnabled
    public static void calculateRevenue(string id) {

        Opportunity opp = [
            SELECT Id,
                   Name,
                   StageName,
                   Amount,
                   Probability,
                   Expected_Revenue_Overridden__c,
                   CloseDate
            FROM Opportunity
            WHERE Id = :id
        ];

        opp.Expected_Revenue_Overridden__c = getERO(opp.Amount,opp.Probability);

        update opp;

    }

    private static Decimal getERO( Decimal amount,Decimal probability){

        if (amount>2000000 && probability>50){
            return amount*0.15;
        }
        else {
            return amount*0.1;
        }
    }

}