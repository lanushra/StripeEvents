class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

    def index
        @subscriptions = Subscription.all
    end

    def new; end

    def create
      event = Stripe::Event.construct_from(params.to_unsafe_h)
  
      # Handle the event
      begin
        case event.type
        when 'customer.subscription.created'
          create_subscription(event.data.object)
        when 'invoice.paid'
          update_subscription(event.data.object)
        when 'customer.subscription.deleted'
          update_to_cancel(event.data.object)
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
  
      puts 'Webhook received successfully'
      render 'layouts/subscriptions/new'
    end

    private

    def create_subscription(my_data)
      Subscription.create(
        name: "Sub1",
        status: 0,
        subscription_stripe_id: my_data.items.first.subscription
      )
    end

    def update_subscription(my_data)
      subscription = my_data.lines.first.subscription
      search_with_stripe_id = Subscription.find_by_subscription_stripe_id(subscription)
      search_with_stripe_id.update(
        status: 1,
      )
    end

    def update_to_cancel(my_data)
      subscription = my_data.items.first.subscription
      search_with_stripe_id = Subscription.find_by_subscription_stripe_id(subscription)
      if search_with_stripe_id.status == "paid"
        search_with_stripe_id.update(status: 2)
      end
    end
end
