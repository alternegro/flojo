# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flojo}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joey Adarkwah"]
  s.date = %q{2010-12-07}
  s.description = %q{ActiveRecord aware workflow (state machine) module that will also work with any plain old ruby object.}
  s.email = %q{alternegro @nospam@ me.com}
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "lib/flojo.rb"]
  s.files = ["CHANGELOG", "MIT_LICENSE", "Manifest", "README.rdoc", "Rakefile", "flojo.gemspec", "lib/flojo.rb", "test/test_active_record.rb", "test/test_helper.rb", "test/test_poro.rb", "test_db.sqlite3"]
  s.homepage = %q{http://github.com/alternegro/flojo}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Flojo", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{flojo}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{When used within an ActiveRecord subclass, flojo events can automatically save a record after a transition.       After including the module in your class and configuring it with an event _event_, and a state _state_, you can interact with instances of that class using the dynamically generated methods of the following form:  +object.wf_event+  - Triggers event and invokes any applicable transitions +object.wf_event!+ - Behaves just like +object.wf_event+ but will also persist object. +object.wf_state?+ - Returns true if the current workflow state is _state_.    +object.wf_current_state+ - Returns the objects current state.}
  s.test_files = ["test/test_active_record.rb", "test/test_helper.rb", "test/test_poro.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
