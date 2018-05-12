/**
 * Created by Olgun on 17/09/2017.
 */

trigger CloneThatShit on Account (before update,before insert ) {

    Set<String> accountID=new Set<String>();

    List<Account> accountList=new List<Account>();
    List<Account> tmpAccountList=new List<Account>();
    List<Contact> tmpContact=new List <Contact>();
    List<Contact> tmpContact2=new List <Contact>();
    Map<Id,List<Contact>> mapContacsClone=new Map<Id, List<Contact>>();



    for(Account acc:Trigger.new){

        if(acc.CloneAccount__c==True&&acc.ClonedAccount__c==False){

            accountList.add(acc);
            accountID.add(acc.Id);

        }

    }


    for(Contact con:[Select Id,AccountId, LastName,account.Name,AccountCloneName__c From Contact Where Accountid IN:accountID]){

        if(mapContacsClone.containsKey(con.AccountId)){

            mapContacsClone.get(con.AccountId).add(con);

        }
        else{

            mapContacsClone.put(con.AccountId,new List<Contact>{con});

        }


    }



    for (Account accCopy : accountList) {

        String accountID=accCopy.Id;
        accCopy.ClonedAccount__c=True;
        Account tmpAccount=accCopy.clone(false,true,false,false);
        tmpAccount.CloneAccount__c=false;
        tmpAccount.Old_Account_ID__c=accountID;
        tmpAccount.Name += ' Clone';
        tmpAccount.Id=null;
        tmpAccountList.add(tmpAccount);


        }

    insert tmpAccountList;



    for(Account tmpAccount2:tmpAccountList){

        if(mapContacsClone.containsKey(tmpAccount2.Old_Account_ID__c)){

            for(Contact conTmp: mapContacsClone.get(tmpAccount2.Old_Account_ID__c)){

                Contact cloneContact=conTmp.clone(false,true,false,false);
                cloneContact.LastName+= ' Clone';
                cloneContact.AccountId=tmpAccount2.Id;
                cloneContact.Id=null;
                tmpContact2.add(cloneContact);

            }


        }


    }
    insert tmpContact2;



}

