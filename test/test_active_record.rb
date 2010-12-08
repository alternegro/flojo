require 'rubygems'
require 'active_record'  
require 'test/unit'    
require 'flojo' 
require 'test_helper'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "test/test_db.sqlite3"
)

class Counter < ActiveRecord::Base 
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


class TestWorkflow < Test::Unit::TestCase  
  include CommonTests
  def setup 
    Counter.delete_all    
    @b = Baby.new
    @c = Counter.new 
    @c.name = "First"
    @c.save          
  end   
  
  def teardown
    Counter.delete_all
  end 
  
  def test_stored_counter   
    stored_counter = Counter.first
    assert_equal(:one, stored_counter.wf_current_state, "Initial state must be :one")   
    
    stored_counter.wf_up!
    assert_equal(:two, stored_counter.wf_current_state, "Current state must be :two")   
    
    stored_counter.reload           
    assert_equal("two", stored_counter.wf_state, "Stored state must be two")
    assert_equal(:two, stored_counter.wf_current_state, "Current state must be :two")
    
    stored_counter.wf_state = "three"  
    stored_counter.save!
    
    assert_equal("three", stored_counter.wf_state, "Stored state must be three") 
     
    stored_counter = Counter.first
    assert_equal(:three, stored_counter.wf_current_state, "Current state must be :three")
  end    
  
  def test_new_counter 
    new_counter = Counter.new   
    assert_equal(nil, new_counter.wf_state, "Stored state must be nil")
    assert_equal(:one, new_counter.wf_current_state, "Initial state must be :one")  
    assert_equal(1, Counter.count)
    
    new_counter.wf_up!
    assert_equal(2, Counter.count)
    assert_equal("up", new_counter.wf_last_event)  
    
    new_counter = Counter.last          
    assert_equal("two", new_counter.wf_state, "Stored state must be nil")
    assert_equal(:two, new_counter.wf_current_state, "Initial state must be :two")  
    assert_equal("up", new_counter.wf_last_event)
    new_counter.wf_down
    assert_equal("down", new_counter.wf_last_event)  
  
  end
  
end   