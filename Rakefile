require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/sshpublisher'
gem 'gem_version', '>=0.0.6'
require 'gem_version'

spec = Gem::Specification.new do |s|
  s.name = 'enumerated_attribute'
  s.version = GemVersion.next_version
  s.platform = Gem::Platform::RUBY
  s.description = 'Enumerated model attributes and view helpers'
  s.summary = 'Add enumerated attributes to your models and expose them in drop-down lists in your views'

  s.add_dependency('meta_programming', '>= 0.2.1')

  exclude_folders = 'spec/rails/{doc,lib,log,nbproject,tmp,vendor,test}'
  exclude_files = FileList['**/*.log'] + FileList[exclude_folders+'/**/*'] + FileList[exclude_folders]
  s.files = FileList['{examples,lib,tasks,spec}/**/*'] + %w( CHANGELOG.rdoc init.rb LICENSE Rakefile README.rdoc .gitignore ) - exclude_files
  s.require_path = 'lib'
  s.has_rdoc = true
  s.test_files = Dir['spec/*_spec.rb']

  s.author = 'Jeff Patmon'
  s.email = 'jpatmon@gmail.com'
  s.homepage = 'http://github.com/jeffp/enumerated_attribute/tree/master'
end

require 'rspec/version'
require 'rspec/core/rake_task'

desc "Run specs"

namespace :spec do
  RSpec::Core::RakeTask.new(:object) do |t|
    t.pattern = 'spec/*_spec.rb'
    t.rcov = false
    #t.rcov_dir = 'coverage'
    #t.rcov_opts = ['--exclude', "kernel,load-diff-lcs\.rb,instance_exec\.rb,lib/spec.rb,lib/spec/runner.rb,^spec/*,bin/spec,examples,/gems,/Library/Ruby,\.autotest,#{ENV['GEM_HOME']}"]
  end
=begin
	Spec::Rake::RakeTask.new(:sub) do |t|
		t.pattern = 'spec/inheritance_spec.rb'
		t.rcov = false
	end
	Spec::Rake::RakeTask.new(:poro) do |t|
		t.pattern = 'spec/poro_spec.rb'
		t.rcov = false
	end
=end
  desc "Run ActiveRecord integration specs"
  RSpec::Core::RakeTask.new(:ar) do |t|
    t.pattern = 'spec/active_record/*_spec.rb'
    t.ruby_opts = '-Ispec/active_record'
    t.rcov = false
  end

  RSpec::Core::RakeTask.new(:forms) do |t|
    t.pattern = 'spec/rails/spec/integrations/*_spec.rb'
    t.rcov = false
  end
#	Spec::Rake::RakeTask.new(:associations) do |t|
#		t.pattern = 'spec/active_record/associations_spec.rb'
#		
#		t.rcov = false
#	end
  desc "Run Sequel integration specs"
  RSpec::Core::RakeTask.new(:sequel) do |t|
    t.pattern = 'spec/sequel/*_spec.rb'
    t.ruby_opts = '-Ispec/sequel'
    t.rcov = false
  end

  desc "Run DataMapper integration specs"
  RSpec::Core::RakeTask.new(:datamapper) do |t|
    t.pattern = 'spec/datamapper/*_spec.rb'
    t.ruby_opts = '-Ispec/datamapper'
    t.rcov = false
  end

  desc "Run all specs"
  task :all => [:object, :ar, :forms, :datamapper, :sequel]

  desc "Run all specs, excluding rails2 forms"
  task :nonrails => [:object, :ar, :datamapper, :sequel]
end

desc "Run all specs, excluding rails2 forms"
task :spec => 'spec:nonrails'

desc "Generate documentation for the #{spec.name} plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = spec.name
  #rdoc.template = '../rdoc_template.rb'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'LICENSE', 'lib/**/*.rb')
end

desc 'Generate a gemspec file.'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |f|
    f.write spec.to_ruby
  end
  GemVersion.increment_version
  GemVersion.commit_and_push do |git|
    git.add("#{spec.name}.gemspec")
  end
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = RUBY_PLATFORM =~ /mswin/ ? false : true
  p.need_zip = true
end

Dir['tasks/**/*.rake'].each { |rake| load rake }
