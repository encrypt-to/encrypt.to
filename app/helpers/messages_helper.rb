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
  
end
