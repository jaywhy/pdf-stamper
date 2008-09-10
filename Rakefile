# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'spec/rake/spectask'
require './lib/pdf/stamper.rb'

Hoe.new('pdf-stamper', Pdf-stamper::VERSION) do |p|
  p.rubyforge_name = 'pdf-stamper'
  p.author = 'Jason Yates'
  p.email = 'jason@peabrane.com'
  p.summary = "PDF::Stamper provides an interface into iText's PdfStamper allowing for the editing of existing PDF's as templates."
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.warning = true
  t.rcov = false
end

# vim: syntax=Ruby
