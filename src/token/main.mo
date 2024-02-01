import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Hash "mo:base/Hash";


actor Token {
    // assigning the owner of all the tokens created as "Principal"
    var owner : Principal = Principal.fromText("uba75-igbiv-rvhvl-nhfvp-57dxu-ag2kt-empkc-amle6-dle4s-4olai-mqe");

    // quantity of tokens 
    var totalSupply : Nat = 1000000000;

    // token name 
    var symbol : Text = "ANGL";


    private stable var balanceEntries: [(Principal, Nat)] =[ ]; 

    // creating storage and configuration in that storage by id and value. 
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); 
   if(balances.size() < 1){
         balances.put(owner, totalSupply); 
    };

    // Query to understand who owns what 
    public query func balanceOf(who: Principal) :async Nat {
        let balance : Nat = switch (balances.get(who) ){
            case null 0;
            case (?result) result; 
        };

        return balance; 
    };

    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
        // Debug.print(debug_show(msg.caller)); 
        if (balances.get(msg.caller) == null) {
             let amount = 10000;
             let result = await transfer(msg.caller, amount);
             return result;
        } else {
            return "Already Claimed";
        }
    };

    public shared(msg) func transfer(to:Principal, amount: Nat): async Text{
        let fromBalance = await balanceOf(msg.caller); 
        if (fromBalance > amount){
            let newBalanceFrom: Nat  =  fromBalance - amount; 
            balances.put(msg.caller, newBalanceFrom); 

            let toBalance = await balanceOf(to); 
            let toNewBalace = toBalance + amount; 
            balances.put(to, toNewBalace); 

            return "success" 
        } else {
            return "Insufficient funds"
        }
    };

    system func preupgrade(){
        balanceEntries := Iter.toArray(balances.entries()); 
    };
    
    system func postupgrade(){
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash); 
        if(balances.size() < 1){
         balances.put(owner, totalSupply); 
    }; };
};