# Ruby Docs : ruby-doc.org/stdlib-2.7.0/

require 'json' # requires json library
 
class Cat
    CAT_SAYS = 'meow'.freeze # static class constant
    attr_accessor :name # creates instance var name that can be accessed and changed
    def initialize(name) # initialize function = constructor
        @name = name.capitalize # use @ for instance var
    end
    def meow
        puts "#{@name} says #{CAT_SAYS}"
    end
    def self.meow # static method meow (overloaded from instance method above)
        puts "#{CAT_SAYS}"
    end
end

class HungryCat < Cat # HungryCat extends Cat
    def meow
        super
        puts "#{@name} is very hungry"
    end
end

class Greeter
    attr_accessor :names # accessor for class var name
    
    def initialize(names = "World")
        if names.respond_to?("each")
            @names = []
            names.each do |name|
                @names.push(name.capitalize)
            end
        else
            @names = names.capitalize
        end
    end
    
    def say_hi
        if @names.nil? # if names is nil (null)
            puts "..."
        elsif @names.respond_to?("each") # if names is a list of some sort
            @names.each do |name| # for each loop : saves each element of @names in name
                puts "Hello #{name}"
            end
        else # @names just has one name and is not a list
            puts "Hello #{@names}"
        end
    end

    def say_bye
        if @names.nil? # methods in ruby ending with ? return true/false - & (and), | (or), ^ (xor) are boolean operators
            puts "..."
        elsif @names.respond_to?("join")
            puts "Goodbye #{@names.join(", ")}. Come back soon!" # prints list separated by a comma and a space
        else
            puts "Goodbye #{@names}. Come back soon!"
        end
    end

end

if __FILE__ == $0 # if present file is only file being run, rub this script (main method)

    parameter = true
    ARGV.each { |arg| puts "arg is: #{arg}" } # ARGV = command line arguments

    # Tests Classes Above
    cat = true
    greet = true

    if cat
        puts "Hello World!"
        puts Cat::CAT_SAYS
        cat = Cat.new("alfred")
        cat.meow
        Cat.meow
        hcat = HungryCat.new("marshal")
        hcat.meow
        HungryCat.meow
    end

    if greet
        g1 = Greeter.new
        g1.say_hi
        g1.say_bye
        g2 = Greeter.new("eric")
        g2.say_hi
        g2.say_bye
        g3 = Greeter.new(["alfred", "Alfonzo", "Ponch", "poncho villa"])
        g3.say_hi
        g3.say_bye
    end

end

