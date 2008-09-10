require 'rubygems'
require 'rake'

spec = Gem::Specification.new do |s|
  s.name 		    = "pdf_stamper"
  s.version 		= "0.2.0"
  s.author     		= "Jason Yates"
  s.email       	= "jaywhy@gmail.com"
  s.homepage    	= "http://pdf-stamper.rubyforge.org/"
  s.platform    	= Gem::Platform::RUBY
  s.summary     	= "PDF::Stamper provides an interface into iText's PdfStamper allowing for the editing of existing PDF's as templates."
  s.files		= FileList["{ext,lib,spec}/**/*"].exclude("rdoc").to_a
  s.require_path 	= "lib"
  s.has_rdoc		= true
  s.test_file		= "spec/pdf_stamper_spec.rb"
  s.add_dependency("rjb", ">= 1.0.4")
end
