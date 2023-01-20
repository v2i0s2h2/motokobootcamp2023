import Text "mo:base/Text";
import Nat "mo:base/Nat";

module{
    public type Book = {
        title : Text ;
        pages : Nat ;
    };

    public func create_book (title : Text, pages : Nat) :async Book {
return let newBook : Book = {
    title = title ;
    pages = pages ;
}
    }
}