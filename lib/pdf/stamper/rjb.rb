# = pdf/stamper/rjb.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2012 Jason Yates

require 'rubygems'
require 'rjb'

Rjb::load(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext', 'iText-4.2.0.jar'), ['-Djava.awt.headless=true'])

# PDF::Stamper::RJB
#
# RJB needs the LD_LIBRARY_PATH and JAVA_HOME environment set for it
# to work correctly.  For example on my system:
#
# export LD_LIBRARY_PATH=/usr/java/jdk1.6.0/jre/lib/i386/:/usr/java/jdk1.6.0/jre/lib/i386/client/:./
# export JAVA_HOME=/usr/java/jdk1.6.0/
#
# Check the RJB documentation if you are having issues with this.
module JRubyToRjb
  class << self; attr_reader :java_class; end
  def initialize(args)
    @object = self.java_class.new(args)
  end

  def method_missing(meth, *args, &block)
    @object.send meth, *args, &block
  end
end

class PdfReader
  include JRubyToRjb
  @java_class = Rjb::import('com.lowagie.text.pdf.PdfReader')
end

class PdfStamper
  include JRubyToRjb
  @java_class = Rjb::import('com.lowagie.text.pdf.PdfStamper')
end

class ByteArrayOutputSream
  include JRubyToRjb
  @java_class = Rjb::import('java.io.ByteArrayOutputStream')
end

class FileOutputStream
  include JRubyToRjb
  @java_class = Rjb::import('java.io.FileOutputStream')
end

class AcroFields
  include JRubyToRjb
  @java_class = Rjb::import('com.lowagie.text.pdf.AcroFields')
end

class PdfWriter
  include JRubyToRjb
  @java_class = Rjb::import('com.lowagie.text.pdf.PdfWriter')
end

class Image
  include JRubyToRjb
  @java_class = Rjb::import('com.lowagie.text.Image')
end
