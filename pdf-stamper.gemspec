# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ps-pdf-stamper}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Steele"]
  s.date = %q{2010-09-15}
  s.description = %q{Fill out PDF forms (templates) using iText's PdfStamper.  == CAVEAT:  You have to use JRuby or RJB. You need Adobe LiveCycle Designeror Acrobat Professional to create the templates.  == EXAMPLE: pdf = PDF::Stamper.new("my_template.pdf") pdf.text :first_name, "Jason" pdf.text :last_name, "Yates" pdf.image :photo, "photo.jpg" pdf.checkbox :hungry pdf.save_as "my_output.pdf"}
  s.email = %q{paulschreiber@gmail.com}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "ext/iText-5.0.4.jar", "lib/pdf/stamper.rb", "lib/pdf/stamper/jruby.rb", "lib/pdf/stamper/rjb.rb", "spec/logo.gif", "spec/pdf_stamper_spec.rb", "spec/test_template.pdf"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/paulschreiber/pdf-stamper/}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{pdf-stamper}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Super cool PDF templates using iText's PdfStamper.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
