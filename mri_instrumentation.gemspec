# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mri_instrumentation}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lourens Naud\303\251"]
  s.date = %q{2009-04-22}
  s.default_executable = %q{instrument}
  s.description = %q{Piggy backs of the dtrace pid provider for visibility into the Ruby VM.}
  s.email = %q{lourens@methodmissing.com}
  s.executables = ["instrument"]
  s.files = ["Rakefile", "README", "README.textile", "VERSION.yml", "lib/instrumentation.rb", "lib/mri", "lib/mri/instrumentation", "lib/mri/instrumentation/argument.rb", "lib/mri/instrumentation/definition.rb", "lib/mri/instrumentation/probe.rb", "lib/mri/instrumentation/probe_collection.rb", "lib/mri/instrumentation/runner", "lib/mri/instrumentation/runner/base.rb", "lib/mri/instrumentation/runner/command.rb", "lib/mri/instrumentation/runner/inline.rb", "lib/mri/instrumentation/strategy", "lib/mri/instrumentation/strategy/base.rb", "lib/mri/instrumentation/strategy/builder.rb", "lib/mri/instrumentation/strategy/calltime.rb", "test/fixtures", "test/fixtures/probes", "test/fixtures/probes/gc.yml", "test/fixtures/target.rb", "test/helper.rb", "test/instrumentation", "test/instrumentation/argument_test.rb", "test/instrumentation/definition_test.rb", "test/instrumentation/probe_collection_test.rb", "test/instrumentation/probe_test.rb", "test/instrumentation/runner", "test/instrumentation/runner/base_test.rb", "test/instrumentation/strategy", "test/instrumentation/strategy/base_test.rb", "test/instrumentation/strategy/builder_test.rb", "test/instrumentation/strategy/calltime_test.rb", "test/instrumentation_test.rb", "probes/18", "probes/18/block.yml", "probes/18/cache.yml", "probes/18/gc.yml", "probes/19", "bin/instrument"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/methodmissing/mri_instrumentation}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Piggy backs of the dtrace pid provider for visibility into the Ruby VM}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
