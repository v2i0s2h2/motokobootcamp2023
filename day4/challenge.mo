import List "mo:base/List";
import Prim "mo:⛔";

actor {

  //challenge 1
  public type List<T> = List.List<T>;
  
  private func unique<T>(l : List<T>, equal: (T,T) -> Bool) : List<T> {
      
       return l;
    };
  
  //challenge 2
  private func reverse<T>(l : List<T>) : List<T> {
    func rec(l : List<T>, r : List<T>) : List<T> {
      switch l {
        case null { r };
        case (?(h, t)) { rec(t, ?(h, r)) }
      }
    };
    rec(l, null)
  };

  //challenge 3
  
  //challenge 4
  
  //challenge 5
  


}