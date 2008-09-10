# = pdf/stamper.rb -- PDF template stamping.
#
#  Copyright (c) 2007 Jason Yates

require 'fileutils'
require 'rubygems'
require 'rjb'
require 'tmpdir'

include FileUtils

Rjb::load(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext', 'itext-2.0.6.jar'))

# PDF::Stamper provides an interface into iText's PdfStamper allowing for
# the editing of existing PDF's as templates.  Unlike the available PDF 
# generators, PDF::Stamper, via RJB and iText, allows you to edit
# existing PDF's and use them as templates.
#
# == Creation of templates
#
# Templates currently can only be created using Adobe LiveCycle
# Designer which comes with the lastest versions of Adobe Acrobat
# Professional.  Using LiveCycle Designer you can create a form and
# add textfield's for text and button's for images.
#
# == Caveats
#
# RJB needs the LD_LIBRARY_PATH and JAVA_HOME environment set for it
# to work correctly.  For example on my system:
#
# export LD_LIBRARY_PATH=/usr/java/jdk1.6.0/jre/lib/i386/:/usr/java/jdk1.6.0/jre/lib/i386/client/:./
# export JAVA_HOME=/usr/java/jdk1.6.0/
#
# Check the RJB documentation if you are having issues with this.
module PDF
  # PDF::Stamper
  #
  # == Example
  #
  # pdf = PDF::Stamper.new("my_template.pdf")
  # pdf.text :first_name, "Jason"
  # pdf.text :last_name, "Yates"
  # pdf.image :photo, "photo.jpg"
  # pdf.save_as "my_output"
  class Stamper    
    def initialize(pdf = nil, options = {})
      @bytearray    = Rjb::import('java.io.ByteArrayOutputStream')
      @filestream   = Rjb::import('java.io.FileOutputStream')
      @acrofields   = Rjb::import('com.lowagie.text.pdf.AcroFields')
      @pdfreader    = Rjb::import('com.lowagie.text.pdf.PdfReader')
      @pdfstamper   = Rjb::import('com.lowagie.text.pdf.PdfStamper')

      template(pdf) if ! pdf.nil?
    end
    
    def template(template)
      reader = @pdfreader.new(template)
      @baos = @bytearray.new
      @stamp = @pdfstamper.new(reader, @baos)
      @form = @stamp.getAcroFields()
    end

    # Set a textfield defined by key and text to value.
    def text(key, value)
      @form.setField(key.to_s, value.to_s) # Value must be a string or itext will error.
    end

    # Set a button field defined by key and replaces with an image.
    def image(key, image_path)
      # Idea from here http://itext.ugent.be/library/question.php?id=31 
      # Thanks Bruno for letting me know about it.
      image = Rjb::import('com.lowagie.text.Image')
      img = image.getInstance(image_path)
      img_field = @form.getFieldPositions(key.to_s)

      rectangle = Rjb::import('com.lowagie.text.Rectangle')
      rect = rectangle.new(img_field[1], img_field[2], img_field[3], img_field[4])
      img.scaleToFit(rect.width, rect.height)
      img.setAbsolutePosition(
        img_field[1] + (rect.width - img.scaledWidth) / 2,
        img_field[2] + (rect.height - img.scaledHeight) /2
      )

      cb = @stamp.getOverContent(img_field[0].to_i)
      cb.addImage(img)
    end

    # Takes the PDF output and sends as a string.  Basically it's sole
    # purpose is to be used with send_data in rails.
    def to_s
      fill
      @baos.toByteArray
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
