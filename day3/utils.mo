  import Int "mo:base/Int";
  import Array "mo:base/Array";
  
  
  module {
  //challenge 1
  public query func second_maximum(array : [Int]) : async Int {
    let assending_array : [Int] = Array.sort(array, Int.compare);
    return assending_array[assending_array.size() - 2];
  };

  //challenge 2
  public query func remove_even(array : [Nat]) : async [Nat] {
    return Array.filter<Nat>(
      array,
      func (x) { x % 2 != 0 }    ); 
  };

  //challenge 3
  public func drop<T>(array : [T], n : Nat) : [T] {
    return Array.tabulate<T>(
      array.size() - n, 
      func i = array[i + n]
    );
  };
}