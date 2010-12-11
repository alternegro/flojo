module Flojo 
  def Flojo.included(host)
    
  	host.class_eval do          
  	  attr_writer :wf_current_state 
  	  attr_accessor :_wf_current_event_transition_map, :wf_previous_state
  	  protected :wf_current_state=, :_set_workflow_state 
      
      def wf_current_state
        wf_current_state = @wf_current_state.nil? ? wf_initial_state : @wf_current_state 
      end    
      
      def wf_initial_state
        st = self.respond_to?(:wf_state) ? (wf_state || self.class.wf_states[0]) : self.class.wf_states[0] 
        st.to_sym
      end
        	  
  	  def self.workflow_states(s)
        @workflow_states = s.uniq.compact
        
        s.each do |st|
          raise "Invalid Parameter. State array elements should be symbols" unless Symbol === st
        end
        
	      self.synthesize_state_query_methods
      end
	    
      def self.wf_states
        @workflow_states
      end                           

      def self.synthesize_state_query_methods
	      @workflow_states.each {|st| define_method("wf_#{st}?") { st.eql?(wf_current_state)}}
	    end  
	    
	    def self.valid_state(*states)
	      states.each {|st| return false if (!@workflow_states.include?(st) && (st != :any)) || !(Symbol === st)}                                               
        return true
      end 
            
  	end
      
    host.class_eval("def self.transition(start_state, end_state); raise 'Invalid Transition State' unless self.valid_state(start_state, end_state); @wf_current_event_transition_map[start_state]=end_state; end")
	      
    host.class_eval do
      def self.event(e, &actions)	  
        event_token = "wf_#{e}" 
        map_token = "#{event_token}_transition_map"   

        #setup a transition map class instance variable and corresponding accessors for each event. 
        self.class_eval("@#{map_token}={}") 
        self.class_eval("def self.#{map_token}; return @#{map_token}; end")    
        self.class_eval("def self.wf_current_event_transition_map=(cem); @wf_current_event_transition_map=cem; end" )                                                
        self.class_eval("@wf_current_event_transition_map = @#{map_token}={}")
        self.class_eval("def self.wf_current_event_transition_map; @wf_current_event_transition_map; end" ) 
        self.class_eval("def self.wf_current_event_transition_map=(cem); @wf_current_event_transition_map=cem; end" )
                      
        #instance event_methods  
        self.class_eval("def #{event_token}; self._wf_current_event_transition_map=self.class.#{map_token}; _set_workflow_state \"#{e}\"; end\n")
        self.class_eval("def #{event_token}!; #{event_token}; _wf_after_transition_save!; wf_after_save if self.class.method_defined? :wf_after_save; end\n" )
                
        #Calls transitions in event block
        actions.call
      end
    end
		
  end
  
  private  
  
  def _set_workflow_state(event=nil)
    self.wf_previous_state = self.wf_current_state 
    self.wf_last_event = event if self.respond_to?(:wf_last_event)
    
    state = self._wf_current_event_transition_map[self.wf_current_state] || self._wf_current_event_transition_map[:any]   
    
    if (state != self.wf_current_state) && (!state.nil?)
      self.wf_current_state=state
       
      eval("wf_on_#{event}") if event && (self.class.method_defined? "wf_on_#{event}")             
      eval("wf_on_exit_#{wf_current_state}") if self.class.method_defined? "wf_on_exit_#{wf_current_state}" 
      eval("wf_on_enter_#{state}") if self.class.method_defined? "wf_on_enter_#{state}"  
       
      wf_after_transition if self.class.method_defined? :wf_after_transition
    end
  end   
                                                                                   
  def _wf_after_transition_save! 
    self.wf_state = self.wf_current_state if self.respond_to?(:wf_state=)
    save! if self.respond_to?(:save!)
  end  
  
end



