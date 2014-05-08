module Spree
  module Admin
    class SaleImagesController < ResourceController
      belongs_to 'spree/active_sale_event', :find_by => :id
      before_filter :load_data

      create.before :set_viewable
      update.before :set_viewable
      destroy.before :destroy_before

      private

        def location_after_save
          edit_admin_active_sale_active_sale_event_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def load_data
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
          @active_sale_event = Spree::ActiveSaleEvent.find(params[:active_sale_event_id])
        end

        def set_viewable
          @sale_image.viewable_type = 'Spree::ActiveSaleEvent'
          @sale_image.viewable_id = @active_sale_event.id
        end

        def destroy_before
          @viewable = @sale_image.viewable
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
