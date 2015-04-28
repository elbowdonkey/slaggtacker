require "sinatra"
require 'sinatra/base'
require "tilt/erb"
require File.expand_path(File.join(File.dirname(__FILE__), "elements.rb"))


class Slaggtacker < Sinatra::Base
  get "/" do
    params[:url] = "http://collusioni.st" if params[:url].nil? or params[:url].empty?
    params[:tag] = "div" if params[:tag].nil? or params[:tag].empty?

    @elements = Elements.new params[:url], highlight_tag: params[:tag]
    @elements.add_highlights

    erb :index
  end

  get "/test" do
    erb :test
  end
end
