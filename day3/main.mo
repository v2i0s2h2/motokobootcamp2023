import List "mo:base/List";
import Book "book";

actor {
   public type Book = Book.Book;
    public type List<T> = ?(T, List<T>) ;

  //challenge 6

var book_list : List<Book> = null ;
    
    //challenge 7
  public func add_book(book : Book) : () {
    book_list := List.push<Book>(book, book_list);
  };
  
  public query func get_books() : async [Book] {
    return List.toArray(book_list);
  };
}