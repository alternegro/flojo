module CommonTests
  def test_events	
    assert_equal(:one, @c.wf_current_state, "Initial state must be :one")     
    assert_equal(@c.wf_up!, "wf_after_save", "Last method called should be wf_after_save hook")  
    assert_equal(:one, @c.wf_previous_state) 
    assert_equal(:two, @c.wf_current_state) 
    
    @c.wf_down!
    
    assert_equal(:one, @c.wf_current_state)
    
    assert_respond_to(@c, :wf_up!)
    assert_respond_to(@c, :wf_down!)
    assert_respond_to(@c, :wf_reset!)
    
    @c.wf_up #to :two
    @c.wf_up #to :three
    
    @c.wf_up #to :four
    
    @c.wf_up #to :four
    
    assert_nil(@c.wf_up, "No transition expected") 
    
    @c.wf_up! #to :four

    assert_nil(@c.wf_up, "No transition expected")
 
 	  assert(@c.wf_four?, "Should still be at :four")
    
  end 
 
  def test_states
    assert_equal(Counter.wf_states, [:one, :two, :three, :four]) 
    assert_equal(Baby.wf_states, [:asleep, :crying, :pooping, :chilling, :puking] )
    assert_respond_to(@c, :wf_one?)
    assert_respond_to(@c, :wf_two?)
    assert_respond_to(@c, :wf_three?)
    assert_respond_to(@c, :wf_four?)
    
    #states are mutually exclusive and there is always one state
    assert(@c.wf_one? || @c.wf_two? || @c.wf_three? || @c.wf_four?)
    assert(!(@c.wf_one? && @c.wf_two? && @c.wf_three? && @c.wf_four?))
    
    @c.wf_up! #to :two
    assert(@c.wf_two?)
    assert(!(@c.wf_one? || @c.wf_three? || @c.wf_four?))
    
  end   
  
  def test_wildcard
    assert_equal(@b.wf_current_state, :asleep)
    assert(@b.wf_asleep?, "Initial state is asleep")
    @b.wf_spank; assert(@b.wf_crying?, "Spanking must always lead to crying")
    @b.wf_feed; assert(@b.wf_chilling?, "Feed must move from crying to chilling")
    @b.wf_burp; assert(@b.wf_puking?, "Burp must move from chilling to puking")
    @b.wf_spank; assert(@b.wf_crying?, "Spanking must always lead to crying")  
    @b.wf_rock; assert(@b.wf_chilling?, "Rock must move from crying to chilling") 
    @b.wf_spank; assert(@b.wf_crying?, "Spanking must always lead to crying")
  end                    
  
  def test_inheritance
    oc = OtherCounter.new
    assert(oc.wf_a?) 
    oc.wf_up; assert(oc.wf_b?, "State must be :b after wf_up")
  end 
end

class Baby
  include Flojo
  
  workflow_states [:asleep, :crying, :pooping, :chilling, :puking]

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
    transition :any, :crying
  end
	
  #enter and exit event handlers should take the form on_enter_xxx, on_exit_xxx where xxx is the state
  def wf_on_enter_asleep
    puts "I peed all over the bed"
  end
	
  def wf_on_enter_chilling
    puts "drool and fart"
  end	
  
  def wf_on_exit_asleep
    puts "waaaaah waaaaah waaaaaah"
  end 
   
end


class OtherCounter < Baby 
  include Flojo   
  
  workflow_states [:a, :b, :c, :d]

  event :up do
    transition :a, :b
	  transition :b, :c
	  transition :c, :d
  end
end