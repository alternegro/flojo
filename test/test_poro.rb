require 'flojo' 
require 'test/unit' 
require 'test_helper'

class Counter
  include Flojo
  
  workflow_states [:one, :two, :three, :four]

  event :up do
    transition :one, :two
	  transition :two, :three
	  transition :three, :four
  end
	
  event :reset do
    transition :two, :one
    transition :three, :one
    transition :four, :one
  end
  
  event :down do
    transition :one, :three
	  transition :two, :one
	  transition :three, :two
  end
	
  #enter and exit event handlers should take the form on_enter_xxx, on_exit_xxx where xxx is the state
  def wf_on_enter_one
    "on_enter_one"
  end
	
  def wf_on_exit_one
    "on_exit_one"
  end	
  
  def wf_on_down
  	"on_down"
  end
  
  def wf_on_up
  	"on_up"
  end
  
  
  def wf_after_transition
    "wf_after_transition"
  end 
  
  def wf_after_save
    "wf_after_save"
  end
  
   
end 


class TestState < Test::Unit::TestCase 
  include CommonTests 
  
  def setup  
    @c = Counter.new  
    @b = Baby.new 
  end 

end    

