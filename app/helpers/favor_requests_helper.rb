module FavorRequestsHelper
  def format_favor_request_details(favor_request)
    details = []
    details << "Catégorie : #{favor_request.category_title}" if favor_request.category.present?

    if favor_request.convocation_detail
      convocation = favor_request.convocation_detail
      details << "Lieu : #{convocation.location}" if convocation.location.present?
      details << "Quand : #{convocation.timing}" if convocation.timing.present?
      details << "Tenue : #{convocation.attire}" if convocation.attire.present?
      details << "Mood : #{convocation.mood}" if convocation.mood.present?
    end

    details << "Détails : \"#{favor_request.message}\"" if favor_request.message.present?
    details.join(' | ')
  end
end
