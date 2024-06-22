class Subscription < ApplicationRecord
    enum status: {
        unpaid: 0,
        paid: 1,
        cancel: 2, 
    }
end
