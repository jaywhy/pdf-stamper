# = pdf/stamper/rjb.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2009 Jason Yates

$:.unshift(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext'))
require 'java'
require 'iText-2.1.4.jar'

include_class 'java.io.FileOutputStream'
include_class 'java.io.ByteArrayOutputStream'
include_class 'com.lowagie.text.pdf.AcroFields'
include_class 'com.lowagie.text.pdf.PdfReader'
include_class 'com.lowagie.text.pdf.PdfStamper'
include_class 'com.lowagie.text.Image'
include_class 'com.lowagie.text.Rectangle'

module PDF
  class Stamper
    def initialize(pdf = nil)
      template(pdf) if ! pdf.nil?
    end
  
    def template(template)
      # NOTE I'd rather use a ByteArrayOutputStream.  However I
      # couldn't get it working.  Patches welcome.
      #@tmp_path = File.join(Dir::tmpdir, 'pdf-stamper-' + rand(10000).to_s + '.pdf')
      reader = PdfReader.new(template)
      @baos = ByteArrayOutputStream.new
      @stamp = PdfStamper.new(reader, @baos)#FileOutputStream.new(@tmp_path))
      @form = @stamp.getAcroFields()
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
    
    # Takes the PDF output and sends as a string.  Basically it's sole
    # purpose is to be used with send_data in rails.
    def to_s
      fill
      String.from_java_bytes(@baos.toByteArray)
    end
  end
end
