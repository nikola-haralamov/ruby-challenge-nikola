# Backstory

The app currently fulfills orders with a single supplier.

In terms of data models the app has the following:
* Product
* Order (has one product)
* Supplier (the entity that will fulfill the order)

It has a background job that is responsible for processing orders that need fulfilling.

# PR Goal

* Fulfill only pending orders
* For each order, choose the supplier that has stock for the order's product

# Review guidelines

Please go through all the PR changes and leave a PR review that includes whether the code is ready to merge and any points that need refinements.

**HINT:** We have planted several traps of varying importance in this PR's code. Don't worry about making a large number of comments, if you find all those traps.

**NOTE:** The supplier API clients are mocks. They're not part of the review process but their behaviour might affect the outcome of the job.
