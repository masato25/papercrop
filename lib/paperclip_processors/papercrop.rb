require "paperclip"

module Paperclip
  class Papercrop < Thumbnail

    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end


    def crop_command
      target = @attachment.instance

      ::Paperclip.log("[papercrop] attachment.name: #{@attachment.name}")
      ::Paperclip.log("[papercrop] target: #{target.methods}")
      if target.cropping?(@attachment.name)
        begin
          w = Integer(target.send :"#{@attachment.name}_crop_w")
          h = Integer(target.send :"#{@attachment.name}_crop_h")
          x = Integer(target.send :"#{@attachment.name}_crop_x")
          y = Integer(target.send :"#{@attachment.name}_crop_y")
          ["-crop", "#{w}x#{h}+#{x}+#{y}"]
        rescue Exception => e
          ::Papercrop.log("[papercrop] #{@attachment.name} crop w/h/x/y were non-integer. Error: #{e.to_s}")
          return 
        end
      end
    end

  end
end
