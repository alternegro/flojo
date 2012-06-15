# Flojo
	  
Flojo is a simple ActiveRecord aware state machine module, but it will also work with any plain old ruby object.  
When used within an ActiveRecord subclass, flojo events can automatically save a record after a transition.     

After including the module in your class and configuring it with an `event`, and a `state`, 
you can interact with instances of that class using the dynamically generated methods of the following form:

Triggers event and invokes any applicable transitions
```ruby
object.wf_event
```	


Behaves just like object.wf_event but will also persist object.  
```ruby
object.wf_event!
```


Returns true if the current workflow state is _state_.
```ruby
object.wf_state?   
```


Returns the objects current state.
```ruby
object.wf_current_state
```

To avoid method name collisions with your classes, Flojo methods are usually prefixed with `wf_`.   
The `wf_` is also handy when you need to interact with your objects in irb. Just type `wf_` and tab...

See test.rb, test_active_record.rb and test_helper.rb for concrete examples.

## Install       

Install the gem with 
```console
gem install flojo
```
Alternatively, download lib/flojo.rb and copy it to your project's <b>lib</b> folder.   
	  
	
## Usage  
```ruby
require 'flojo' 

class Baby 
  # Include the module
  include Flojo

  # configure the states. The first element represents the initial state
  workflow_states [:asleep, :crying, :pooping, :chilling, :puking]

  # configure your transitions. Using: transition :begin_state, :end_state
  event :feed do
	transition :crying, :chilling
	transition :chilling, :pooping
  end

  event :rock do
	transition :crying, :chilling
	transition :chilling, :asleep
	transition :asleep, :pooping
  end

  event :burp do
	transition :crying, :chilling
	transition :chilling, :puking
  end

  event :wake do
	transition :asleep, :crying
  end
	
  event :spank do 
	# :any is a wildcard state and is only valid as a begin state.
	transition :any, :crying
  end


  # event, enter state and exit state callbacks should take the following forms:
  # wf_on_event, wf_on_enter_state and wf_on_exit_state and are only called if they are defined  
  def wf_on_spank
	puts "Never spank a baby! Somebody dial 911!"
  end

  def wf_on_enter_chilling
	puts "drool and fart"
  end

  def wf_on_exit_asleep
	puts "waaaaah waaaaah waaaaaah"
  end

  # called only after an event yields a transition.
  def wf_after_transition
	puts "Send a tweet baby is alive and kicking"
  end 

  # called only after an event triggers a save.
  def wf_after_save
	puts "Send a tweet saying baby was saved"
  end
  
end


baby = Baby.new
baby.wf_asleep? 
baby.wf_wake
baby.wf_current_state #Should return :awake          
```
## ActiveRecord specific details   
If you want the current workflow state persisted, your table needs to have a string column named _wf_state_. 
If your table has a _wf_last_event_ column, that column will store the most recent event triggered on the object.
The module will still work if the wf_state is absent but the workflow state will be transient.
When used within an ActiveRecord subclass, the "!" versions of the wf_event methods will -
trigger a record save immediately after transition.

eg:
```ruby
baby.wf_feed  #Will not trigger a save. 
baby.wf_feed! #Will trigger a save.
```  

## Copyright
	
Copyright (c) 2010 Joey Adarkwah
	 

