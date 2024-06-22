class SubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

    def index
        @subscriptions = Subscription.all
    end

    # def create
    #     @subscription = customer.subscription.created
    #     if @subscription.save
    #         puts "sucessful"
    #     else
    #         puts "failed"
    #     end
    # end


    def update
        if @subscription.update(subscription_params)
            puts "sucessful"
        else
            puts "failed"
        end
    end

    def new; end

    def create
      event = Stripe::Event.construct_from(params.to_unsafe_h)
  
      # Handle the event
      begin
        case event.type
        when 'customer.subscription.created'
          handle_payment_succeeded(event.data.object)
        else
          raise "Unhandled event type: #{event.type}"
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
  
      puts 'Webhook received successfully'
      render 'layouts/subscriptions/new'
    end

    private

    def handle_payment_succeeded(my_data)
        subscription = my_data

        Subscription.create(
            name: "Sub1",
            status: 0,
        )
    end

    def subscription_params
        params.require(:subscription).permit(:name)
    end
end
