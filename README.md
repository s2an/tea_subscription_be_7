# README: Tea Subscription Service

A Rails API for a Tea Subscription Service. Allows a user to subscribe to various tea subscriptions, with a MVP amount of teas and plans offered.

## Prerequisites

- Ruby (version 3.2.X)
- Rails (version 7.1.X)
- PostgreSQL (or equivalent)

## Installation / Running the App

1. Clone the repository
`git clone git@github.com:s2an/tea_subscription_be_7.git`

1. Navigate to the project directory
`cd tea_subscription_be_7`

1. Install required gems
`bundle install`

1. Create / Migrate the database
`rails db:{create,migrate}`

1. Start the rails server
`rails s`

## Testing

- Testing (through RSpec) is achieved through the following terminal command:
`bundle exec rspec`

## Endpoints

The following endpoints (without requiring payloads) are available:

- Customer Show
`GET api/v1/customer/:id`
- Tea Show
`GET api/v1/tea/:id`
- See all of a customer's subscriptions (active and canceled)
`GET /customers/:customer_id/subscriptions`
- Delete a tea subscription from the database
`DELETE api/v1/customers/:customer_id/subscriptions/:id`

The following endpoints (that require payloads) are also available:

- Create a customer
`POST api/v1/customers`

JSON body:
{
      "customer": {
            "first_name": "John",
            "last_name": "Jane",
            "email": "johnjane@test.com",
            "address": "123 Main St."
      }
}

- Create a tea
`POST api/v1/teas`

JSON body:
{
  "tea": {
    "title": "Green Tea",
    "description": "Green tea is lighter than Black Tea.",
    "temperature": 180,
    "brew_time": 5
  }
}

- Subscribe a customer to a tea subscription
`POST api/v1/customers/:customer_id/subscriptions`

{
  "subscription": {
    "title": "The Green Box",
    "price": 9.99,
    "status": "active",
    "frequency": "monthly",
    "tea_id": 1
  }
}

- Cancel a customer's tea subscription
`PATCH api/v1/customers/:customer_id/subscriptions/:id`

JSON Body:
{
  "subscription": {
    "status": "cancelled"
  }
}

## Database Schema

__Tea__
- Title
- Description
- Temperature
- Brew Time

__Customer__
- First Name
- Last Name
- Email
- Address

__Subscription__
- Title
- Price
- Status
- Frequency
- tea_id
- customer_id


## Contributing

Contributions are welcome in the form of tips & tricks!