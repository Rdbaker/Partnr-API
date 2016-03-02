module V1::Helpers::ParamHelper
  def permitted_params(p)
    p = declared(p, include_missing: false)
    p.delete :page
    p.delete :per_page
    p
  end

  def get_record(cls, id)
    record = cls.find_by(id: id)
    error!("404 Not Found", 404) if record.nil?
    record
  end

  def get_collection(cls, ids)
    ids.collect { |id| get_record(cls, id) }
  end
end
