class ErrorsController < ApplicationController
  def error404
    @page_title = nil
    # render status: :not_found
  end

  def error500; end

  def invalid_record
    @page_title = nil
  end
end
