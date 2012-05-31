class ProtectionProxy

  def self.role(role_name)
    @current_writable_fields = []
    yield
    writable_fileds[role_name] = @current_writable_fields
  end

  def self.find_proxy(object, role)
    new(object, writable_fileds[role])
  end

  def self.writable_fileds
    @writable_fileds ||= {}
  end

  def self.writable(*names)
    names.each do |name|
      @current_writable_fields << name
    end
  end

  def initialize(object, writable_fileds)
    @object = object
    @writable_fileds = writable_fileds
  end

  def method_missing(sym, *args, &block)
    method_name = sym.to_s
    if ! method_name.end_with?("=") || @writable_fileds.include?(field_name_from(method_name))
      @object.send(sym, *args, &block)
    end
  end

  private

  def field_name_from method_name
    method_name[0...-1].to_sym
  end
require File.expand_path('../protection_proxy', __FILE__)end
