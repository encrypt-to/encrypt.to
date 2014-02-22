module MessagesHelper

  def receiver(to, form)
    if to.is_a?(Array) and to.size > 1
      form.select :receiver, to
    elsif to.is_a?(Array) and to.size == 1
      to[0]
    else
      to
    end
  end
  
  def keyid(keyid, form)
    if keyid.is_a?(Array) and keyid.size > 1
      form.select :keyid, keyid
    end
  end
  
end
