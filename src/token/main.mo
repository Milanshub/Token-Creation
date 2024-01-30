import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Debug "mo:base/Debug";

actor Token {
    // assigning the owner of all the tokens created as "Principal"
    var owner : Principal = Principal.fromText("uba75-igbiv-rvhvl-nhfvp-57dxu-ag2kt-empkc-amle6-dle4s-4olai-mqe");

    // quantity of tokens 
    var totalSupply : Nat = 1000000000;

    // token name 
    var symbol : Text = "ANGL";


    // creating storage and configuration in that storage by id and value. 
    var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash); 

    // placing the owner inside the balance with the total value included  
    balances.put(owner, totalSupply); 

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
             balances.put(msg.caller, amount);
             return "success";
        } else {
            return "Already Claimed";
        }
    };
};