## Setup 

Two options:

1. Straight from command line (does not totally work)
    1. Navigate to 'engineering' directory
    1. Run `sh setup.sh`
    1. type database commands like:
        - SET Hello World
        - GET Hello
        - DELETE Hello
    1. WARNING: I was attempting to replicate exactly the input and output mechanism delineated in the prompt. However, the database does not hold state by this method. I messed with it for about 20 minutes, then decided that the code challenge is more interested in my database implementation than the exact input mechanism, and I moved on. I expect to be able to get this working with the person I'm talking to at noon on Tuesday.  
    
2. Via irb
    1. Navigate to 'engineering' directory
    1. Type `irb`
    1. Type `load 'database.rb'`
    1. Instantiate database via, for example 'db = Database.instance' 
    1. Call methods on the db instance
    1. Instead of an END command, you'll type 'exit()'
    

