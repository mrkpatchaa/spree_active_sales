module Spree
  ProductsController.class_eval do
    HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/ unless defined? HTTP_REFERER_REGEXP

    def index
      redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
    end

    def show
      @product = Spree::Product.active.find_by_permalink!(params[:id])
      return unless @product

      if @product.live?
        @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
        @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

        referer = request.env['HTTP_REFERER']

        if referer && referer.match(HTTP_REFERER_REGEXP)
          @taxon = Spree::Taxon.find_by_permalink($1)
        end

        respond_with(@product)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
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