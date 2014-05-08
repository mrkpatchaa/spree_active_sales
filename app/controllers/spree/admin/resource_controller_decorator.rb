module Spree
  module Admin
    ResourceController.class_eval do

      private
        def get_eventable_object(object_name = {})
          unless object_name[:eventable_type].nil?
            eventable = "#{object_name[:eventable_type]}".constantize.find_by_name(object_name[:eventable_name])
            object_name.delete(:eventable_name)
            unless eventable.nil?
                if object_name[:eventable_type] = "Spree::Product"
                  object_name.merge!(:eventable_id => eventable.id, :permalink => eventable.slug)
                else
                  object_name.merge!(:eventable_id => eventable.id, :permalink => eventable.permalink)
                end
            else
              object_name.merge!(:eventable_id => nil)
            end
          end
        end

      private
      # Using a private method to encapsulate the permissible parameters is just a good pattern
      # since you'll be able to reuse the same permit list between create and update. Also, you
      # can specialize this method with per-user checking of permissible attributes.
      def saleevent_params
        params.require(:saleevent).permit(:description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :type, :parent_id, :position)
      end

      def activesaleevent_params
        params.require(:activesaleevent).permit(:description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount, :parent_id)
      end

      def saleimage_params
        params.require(:saleimage).permit(:alt, :attachment, :position, :viewable_type, :viewable_id)
      end
    end
  end
end