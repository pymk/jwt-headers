# Get JWT Headers for R Shiny

This chunk of R code can be used in a Shiny app to pull the JWT headers that are added by AWS' Application Load Balancer (ALB).

This can be used for user authentication through IdP. More info and Python version of this code is provided by [AWS here](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html), but I wanted to implement an R version to use in a Shiny app.

It pulls the user's email from the request header (`x-amzn-oidc-data`) and stores it in a reactive object (`user_email`). If the Shiny app is running locally, it pulls the email from `GARGLE_EMAIL` environment variable (if it exists).
