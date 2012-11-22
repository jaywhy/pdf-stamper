# = pdf/stamper/rjb.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2009 Jason Yates

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext'))
require 'java'
require 'iText-4.2.0.jar'

java_import 'java.io.FileOutputStream'
java_import 'java.io.ByteArrayOutputStream'
java_import 'com.lowagie.text.Image'
java_import 'com.lowagie.text.Rectangle'
java_import 'com.lowagie.text.pdf.GrayColor'

module PDF
  include_package 'com.lowagie.text.pdf'

  class Stamper
    def initialize(pdf = nil)
      template(pdf) if ! pdf.nil?
    end
  
    def template(template)
      # NOTE I'd rather use a ByteArrayOutputStream.  However I
      # couldn't get it working.  Patches welcome.
      #@tmp_path = File.join(Dir::tmpdir, 'pdf-stamper-' + rand(10000).to_s + '.pdf')
      reader = PDF::PdfReader.new(template)
      @baos = ByteArrayOutputStream.new
      @stamp = PDF::PdfStamper.new(reader, @baos)#FileOutputStream.new(@tmp_path))
      @form = @stamp.getAcroFields()
      @black = GrayColor.new(0.0)
      @canvas = @stamp.getOverContent(1)
    end
  
    # Set a button field defined by key and replaces with an image.
    def image(key, image_path)
      # Idea from here http://itext.ugent.be/library/question.php?id=31 
      # Thanks Bruno for letting me know about it.
      img = Image.getInstance(image_path)
      img_field = @form.getFieldPositions(key.to_s)

      rect = Rectangle.new(img_field[1], img_field[2], img_field[3], img_field[4])
      img.scaleToFit(rect.width, rect.height)
      img.setAbsolutePosition(
        img_field[1] + (rect.width - img.scaledWidth) / 2,
        img_field[2] + (rect.height - img.scaledHeight) /2
      )

      cb = @stamp.getOverContent(img_field[0].to_i)
      cb.addImage(img)
    end

    def create_barcode(format)
      PDF.const_get("Barcode#{format}").new
    end
    
    # Takes the PDF output and sends as a string.  Basically it's sole
    # purpose is to be used with send_data in rails.
    def to_s
      fill
      String.from_java_bytes(@baos.toByteArray)
    end
  end
end
