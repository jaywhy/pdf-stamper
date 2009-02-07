# = pdf/stamper.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2009 Jason Yates

require 'rbconfig'
require 'fileutils'
require 'tmpdir'

include FileUtils

module PDF
  class Stamper
    VERSION = "0.3.0"
    
    if RUBY_PLATFORM =~ /java/ # ifdef to check if your using JRuby
      require 'pdf/stamper/jruby'
    else
      require 'pdf/stamper/rjb'
    end
    # PDF::Stamper provides an interface into iText's PdfStamper allowing for the
    # editing of existing PDF's as templates. PDF::Stamper is not a PDF generator,
    # it allows you to edit existing PDF's and use them as templates.
    #
    # == Creation of templates
    #
    # Templates currently can only be created using Adobe LiveCycle
    # Designer which comes with the lastest versions of Adobe Acrobat
    # Professional.  Using LiveCycle Designer you can create a form and
    # add textfield's for text and button's for images.
    #
    # == Example
    #
    # pdf = PDF::Stamper.new("my_template.pdf")
    # pdf.text :first_name, "Jason"
    # pdf.text :last_name, "Yates"
    # pdf.image :photo, "photo.jpg"
    # pdf.save_as "my_output"
    
    # Set a textfield defined by key and text to value.
    def text(key, value)
      @form.setField(key.to_s, value.to_s) # Value must be a string or itext will error.
    end
    
    # Saves the PDF into a file defined by path given.
    def save_as(file)
      f = File.new(file, "w")
      f.syswrite to_s
    end
    
    private

    def fill
      @stamp.setFormFlattening(true)
      @stamp.close
    end
  end
end
    
    