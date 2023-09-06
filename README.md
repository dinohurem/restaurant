# ReserveASeat

ReserveASeat is a project built as a simple solution to reserving and rating a restaurant/place/diner/pub.

## Functionalities

There are a few main functionalities:
1. Owner mode - Registering a restaurant.
2. Owner mode - Editing details of a restaurant as an owner.
3. User mode - Searching for restaurants on a map.
4. User mode - Sending a reservation request.
5. Owner mode - Approving a reservation request and automatic email sending.

## Diagrams

### Main sequence diagram

```mermaid
sequenceDiagram
Owner ->> ReserveASeat: Register a restaurant.
ReserveASeat ->> User: Display all registered restaurants.
Owner-->>ReserveASeat: Edit restaurant, add multiple locations.
User->>ReserveASeat: Search locations, make a reservation request.
ReserveASeat->>Owner: Show a reservation request.
Owner->>ReserveASeat: Approve a reservation request.
ReserveASeat->>User: Send a confirmation email for reservation.
Note right of User: Email contains all<br/>the details about<br/>the reservation made.
```
