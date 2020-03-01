require 'mini_magick'
require 'uri'

class ThumbnailController < ApplicationController

  class InvalidURLError < StandardError
    def message
      "Invalid URL Received"
    end
  end

  class InvalidImageError < StandardError
    def message
      "Invalid Image Received"
    end
  end

  def api
      url = params["url"]
      width = params["width"]
      height = params["height"]

      if width.nil? or height.nil?
        raise ArgumentError.new("Please provide both width and height")
        # optional set default values for width and height
      end

      if url.is_valid_url?
        image = get_remote_image url
      else
        raise InvalidURLError
      end

      image.format("jpg")
      image = resize_image image, width, height, 'blue'
      temp_file_name = generate_temp_file_name
      image.write temp_file_name
      send_file Rails.root.join("public", temp_file_name), type: "image/jpeg", disposition: "inline"

    rescue StandardError => e
      puts e.message
      #puts e.backtrace.inspect
      render json: {
        error: e.to_s
      }, status: :not_found
  end

  def generate_temp_file_name
    return "#{Rails.root}/app/assets/images/#{rand(10000000000)}.jpg"
  end

  def get_remote_image url
    fetched_image = MiniMagick::Image.open(url)
  end

  def resize_image image, new_width, new_height, pad_color
    thumbnail_size = "#{new_width}x#{new_height}"
    image.combine_options do |c|
      c.thumbnail thumbnail_size+'>'
      c.gravity 'center'
      c.extent thumbnail_size
      c.background pad_color
    end
    image
  end

  String.class_eval do
    def is_valid_url?
        uri = URI.parse self
        uri.kind_of? URI::HTTP
    rescue URI::InvalidURIError
        false
    end
  end
end
