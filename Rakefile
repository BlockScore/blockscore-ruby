# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'
require 'devtools'

Devtools.init_rake_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/blockscore/*_test.rb'
  test.verbose = true
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

task default: :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "blockscore #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task('metrics:mutant').clear

namespace :metrics do
  config = Devtools.project.mutant

  desc 'Measure mutation coverage'
  task mutant: :coverage do
    require 'mutant'

    arguments = %W(
      --jobs 1
      --use #{config.strategy}
      --since #{config.since}
      --include lib
      --expect-coverage #{config.expect_coverage}
      --
    ).concat(Array(config.namespace).map { |namespace| "#{namespace}*" })

    unless Mutant::CLI.run(arguments)
      Devtools.notify_metric_violation('Mutant task is not successful')
    end
  end
end
