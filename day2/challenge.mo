import Array "mo:base/Array";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

actor {
  
  public query func average_array(array : [Int]) : async Int {
    return Array.foldLeft<Int, Int>(array, 0, Int.add) / array.size();
  };

  
  public query func count_character(t : Text, c : Char) : async Nat {
    var n : Nat = 0;
    for (letters in t.chars()) {
      if( letters == c ){
        n += 1;
      };
    };
    return n;
  };

  
  public query func factorial(n : Nat) : async Nat {
    var factorial : Nat = n; 
    for(i in Iter.range(1, n - 1)){
      factorial *= i;
    };
    return factorial;
  };

  
  public query func number_of_words(t : Text) : async Nat {
    var n : Nat = 0;
    let splited_text = Text.split(t, #char(' '));
    // Debug.print(debug_show splited_text) ;
      for (e in  splited_text) {
        if (Text.contains(e, #predicate( func(x) {Char.isDigit(x)} ))) {
          // do nothing
          } else { n += 1 };
      };
    return n;
  };

  
  public query func find_duplicates(a : [Nat]) : async [Nat] { 
    var newArray : [Nat] = [];
      for (n in a.vals()) {
          let duplicate_no : [Nat] = Array.filter<Nat>(a, func (x: Nat) : Bool {x == n});
          if(duplicate_no.size() > 1) {
            newArray := Array.append(newArray, [n]);
          };
      };
      return newArray;
  };

  
  public func convert_to_binary(n : Nat) : async Text {
    var bits = 0;
    var number = n;
    var one = 1;
    while(number > 0) {
      let rest = number % 2;
      bits += rest * one;
      number /= 2;
      one *= 10;
    };
    return Nat.toText(bits);
  };

}
  