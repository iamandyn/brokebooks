require 'httparty'
require 'rubygems'

class IsbnChecker
    include HTTParty

    @base_uri = 'https://www.googleapis.com/books/v1/volumes?q=isbn:'
    @key = '&key=AIzaSyAfGsYAIletzGKRLE46MhaZuXA26K2LDqA'

    def self.getBookInfo isbn
        bookInfo = get(@base_uri + isbn + @key)
        if bookInfo['items'] == nil 
            return nil
        else
            #[ [isbns 10 & 13], title, [authors], description ]
            puts bookInfo
            items = bookInfo['items']
            [
                [
                    items[0]['volumeInfo']['industryIdentifiers'][0]['identifier'],
                    items[0]['volumeInfo']['industryIdentifiers'][1]['identifier'] 
                ],
                items[0]['volumeInfo']['title'],
                items[0]['volumeInfo']['authors'],
                items[0]['volumeInfo']['description']
            ]
        end
    end
end

info = IsbnChecker.getBookInfo('9781285741550') #9781111222376, 0321884914
if info != nil
    puts "\n\n\n"
    puts info[0][0]
    puts info[0][1]
    puts info[1]
    puts info[2][0]
    puts info[3]
else
    puts "no data, invalid isbn"
end


