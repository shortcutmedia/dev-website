class DocsPagesController < ApplicationController
  def show
    logger.debug "Params: #{Rails.root + "app/views/pages/#{params[:docs_page]}.html.haml"}"

    if valid_page?
      render template: "docs_pages/#{params[:docs_page]}.html"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private
   def valid_page?
     File.exist?(Pathname.new(Rails.root + "app/views/docs_pages/#{params[:docs_page]}.html.haml"))
   end

end
