class DocumentsController < ApplicationController
  def create
    @document = Document.new(params[:document])
    @document.save!
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
