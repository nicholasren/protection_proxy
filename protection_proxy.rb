class ProtectionProxy
  @@writable_fields = {}

  def initialize(object, role)
    @object = object
    @role = role
  end

  def self.create_proxy(object, role)
    new(object, role)
  end

  def self.writable(role, fields)
    @@writable_fields[role] = fields
  end

  def method_missing(sym, *args, &block)
    method_name = sym.to_s
    if ! method_name.end_with?("=") || @@writable_fields[@role].include?(field_name_from(method_name))
      @object.send(sym, *args, &block)
    end
  end

  private

  def field_name_from method_name
    method_name[0...-1].to_sym
  end

end
