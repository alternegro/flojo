require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('flojo', '0.5.1') do |p|
  p.description    = "ActiveRecord aware workflow (state machine) module that will also work with any plain old ruby object." 
  p.summary    = "When used within an ActiveRecord subclass, flojo events can automatically save a record after a transition.     
	
	After including the module in your class and configuring it with an event _event_, and a state _state_, you can interact with instances of that class using the dynamically generated methods of the following form:
	
	+object.wf_event+  - Triggers event and invokes any applicable transitions
	+object.wf_event!+ - Behaves just like +object.wf_event+ but will also persist object.
	+object.wf_state?+ - Returns true if the current workflow state is _state_.   
	+object.wf_current_state+ - Returns the objects current state."  
	
  p.url            = "http://github.com/alternegro/flojo"
  p.author         = "Joey Adarkwah"
  p.email          = "alternegro @nospam@ me.com"
  p.development_dependencies = []
end