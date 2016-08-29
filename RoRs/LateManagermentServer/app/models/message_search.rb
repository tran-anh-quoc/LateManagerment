# To do: Search criteria in softwares
class MessageSearch
  def self.search(params)
    joins = []
    merges = []
    scopes = []
    params.each do |key, value|
      next if value.blank?
      if value.is_a?(String)
        value = StripAttributes.strip(value)
        value = value.split(',').map { |i| StripAttributes.strip(i) } if value.include?(',')
      end

      case key.to_s
      when 'name_phone'
        joins << :user
        merges << User.with_name_phone(value)
      when 'time'
        scopes << ['with_time', value]
      end
    end
    relation = Message.all
    joins.each do |join|
      relation = relation.joins(join)
    end
    merges.each do |merge|
      relation = relation.merge(merge)
    end
    scopes.each { |scope| relation = relation.send scope.first, scope.last }
    relation
  end
end
