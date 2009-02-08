$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'pdf/stamper'
require 'spec/rake/spectask'

%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }

$hoe = Hoe.new('pdf-stamper', PDF::Stamper::VERSION) do |p|
  p.name = 'pdf-stamper'
  p.author = 'Jason Yates'
  p.email = 'jaywhy@gmail.com'
  p.summary = "Super cool PDF templates using iText's PdfStamper."
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]

  # p.spec_extras['platform'] = 'jruby' # JRuby gem created, e.g. pdf-stamper-X.Y.Z-jruby.gem
  
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.warning = true
  t.rcov = false
end