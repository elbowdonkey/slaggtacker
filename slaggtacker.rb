require "sinatra"
require "sinatra/base"
require "tilt/erb"
require File.expand_path("elements.rb")



class Slaggtacker < Sinatra::Base
  get "/" do
    params[:url] = "http://collusioni.st" if blank? :url
    params[:tag] = "div" if blank? :tag

    @errors = []

    begin
      @elements = Elements.new params[:url], highlight_tag: params[:tag]
      @elements.add_highlights
    rescue
      @errors << "Couldn't parse the given URL for some reason."
    end

    erb :index
  end

  ## enable to allow spec suite to hit
  ## when generating new VCR cassettes
  # get "/test" do
  #   erb :test
  # end

  def blank? key
    params[key].nil? or params[key].empty?
  end
end
