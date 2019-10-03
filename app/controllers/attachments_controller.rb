class AttachmentsController < ApplicationController
  skip_authorization_check

  def destroy
    resource = attachment.record

    if current_user.author_of?(resource)
      attachment.purge
      message = { notice: 'Your file succesfully removed.' }
    else
      message = { alert: 'You are not the author of this file' }
    end

    path = resource.is_a?(Answer) ? resource.question : resource

    redirect_to path, message
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
end
