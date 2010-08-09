
class ActiveRecord::Base
  def attributise(attrs)
    ret_attrs = { }
    attrs.each do |k,v|
      k_id = k.to_s + '_id'
      if not attributes.has_key?(k.to_s) and attributes.has_key?(k_id)
        ret_attrs[k_id] = v.id
      else
        ret_attrs[k.to_s] = v
      end
    end
    ret_attrs
  end
  alias attributize attributise
end
