# = pdf/stamper/rjb.rb -- PDF template stamping.
#
#  Copyright (c) 2007-2009 Jason Yates

require 'rubygems'
require 'rjb'

Rjb::load(File.join(File.dirname(__FILE__), '..', '..', '..', 'ext', 'iText-2.1.4.jar'), ['-Djava.awt.headless=true'])

module PDF
  # PDF::Stamper::RJB
  #
  # RJB needs the LD_LIBRARY_PATH and JAVA_HOME environment set for it
  # to work correctly.  For example on my system:
  #
  # export LD_LIBRARY_PATH=/usr/java/jdk1.6.0/jre/lib/i386/:/usr/java/jdk1.6.0/jre/lib/i386/client/:./
  # export JAVA_HOME=/usr/java/jdk1.6.0/
  #
  # Check the RJB documentation if you are having issues with this.
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
      @pagesize = reader.getPageSize(1)
      @numpages = reader.getNumberOfPages()
      @baos = @bytearray.new
      @stamp = @pdfstamper.new(reader, @baos)
      @form = @stamp.getAcroFields()
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
        img_field[1] + (rect.width - img.getScaledWidth) / 2,
        img_field[2] + (rect.height - img.getScaledHeight) /2
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
    
    def add_images(images)
      image = Rjb::import('com.lowagie.text.Image')
      image_size = []
      image_size[0] = @pagesize.width() / 2
      image_size[1] = @pagesize.height() / 2
      pages = (images.length / 4.0).ceil
      pages.times do |index|
        page_number = index + @numpages + 1
        image_index = index * 4
        @stamp.insertPage(page_number, @pagesize)
        over = @stamp.getOverContent(page_number)
        4.times do |n|
          if image_path = images[image_index + n]
            img = image.getInstance(image_path)
            img.scaleToFit(image_size[0], image_size[1])
            case n
            when 0
              img.setAbsolutePosition(0, image_size[1])
            when 1
              img.setAbsolutePosition(image_size[0], image_size[1])
            when 2
              img.setAbsolutePosition(0, 0)
            when 3
              img.setAbsolutePosition(image_size[0], 0)
            end
            over.addImage(img)
          end
        end
      end
    end
    
    def add_image_on_page(page, x, y, url)
      over = @stamp.getOverContent(page)
      image_class = Rjb::import('com.lowagie.text.Image')
      img = image_class.getInstance(url)
      img.setAbsolutePosition(x,y)
      img.scaleToFit(200,70)
      over.addImage(img)
    end
    
  end
end
