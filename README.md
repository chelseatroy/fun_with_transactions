## Running Tests

From inside the engineering directory, run `ruby test_database.rb`

## Using the Database

Two options:

1. Straight from command line (does not work)
    1. Navigate to 'engineering' directory
    1. Run `sh setup.sh`
    1. type database commands like:
        - SET Hello World
        - GET Hello
        - DELETE Hello
    1. WARNING: I was attempting to replicate exactly the input and output mechanism delineated in the prompt. However, the database does not hold state by this method. I messed with it for about 20 minutes, then decided that you're probably more interested in my database implementation than the exact input mechanism, and I moved on.  
    
2. Via irb
    1. Navigate to 'engineering' directory
    1. Type `irb`
    1. Type `load 'database.rb'`
    1. Instantiate database via, for example `db = Database.instance`
    1. Call methods on the `db` instance
    1. All method names are the lower case version of what is described in the prompt. For example, `db.begin`, `db.commit`, `db.end`
    1. I attempted to name these methods exactly as described in the prompt (removing the database object and having a file full of methods named things like BEGIN, DELETE, COMMIT), but it turns out a few of these are keywords in ruby. I'm not in the business of bogarting ruby keywords to make my databases, so I left it as an object.
     
Here is a screenshot of my irb console demonstrating the database at work:

![database at work](https://chelseatroy.com/wp-content/uploads/2019/04/Screen-Shot-2019-04-14-at-7.44.44-PM.png)
    

    

