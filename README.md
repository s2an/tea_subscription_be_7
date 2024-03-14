# README: Tea Subscription Service

A Rails API for a Tea Subscription Service.

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

## Endpoints

The following endpoints are available:

- Subscribe a customer to a tea subscription
`POST /customers/:customer_id/subscriptions`
- Cancel a customer's tea subscription
`DELETE /customers/:customer_id/subscriptions/:id`
- See all of a customer's subscriptions (active and canceled)
`GET /customers/:customer_id/subscriptions`

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


## Contributing

Contributions are welcome in the form of tips & tricks!