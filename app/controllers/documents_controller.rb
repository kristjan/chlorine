class DocumentsController < ApplicationController
  def create
    @document = Document.new(params[:document])
    Rails.logger.info @document.inspect
    if @document.save
      flash[:success] = "I'll just go ahead and file that for later."
    else
      flash[:failure] = "That doesn't looke like any file I've ever seen."
    end
    redirect_to @document.recruit
  end

  def show
    @document = Document.find(params[:id])
    disposition = @document.content_type =~ /^image/ ? 'inline' : 'attachment'
    send_data @document.db_file.data,
              :filename => @document.filename,
              :type => @document.content_type,
              :disposition => disposition
  end
end
