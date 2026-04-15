module ErrorModule
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.class_eval do
      rescue_from ActiveRecord::RecordInvalid do |data|
        @model_instance = data.record
        render "errors/invalid_record"
      end

      rescue_from ActiveRecord::RecordNotFound do |_data|
        render "errors/error404"
      end
    end
  end
end
