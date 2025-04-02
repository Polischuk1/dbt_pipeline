# dbt Airbnb Project

## Project Overview
This dbt project is designed to transform and model Airbnb data for analytics and reporting. It includes dimension tables, fact tables, and marts to provide insights into Airbnb listings, hosts, and reviews.

## Folder Structure
```
dbt_course/
├── dbtlearn/
│   ├── assets/
│   │   ├── input_schema.png
│   ├── macros/
│   │   ├── no_nulls_in_columns.sql
│   │   ├── positive_value.sql
│   │   ├── variables.sql
│   ├── models/
│   │   ├── dim/
│   │   │   ├── dim_hosts_cleansed.sql
│   │   │   ├── dim_listings_cleansed.sql
│   │   │   ├── dim_listings_with_hosts.sql
│   │   ├── fact/
│   │   │   ├── fact_reviews.sql
│   │   ├── mart/
│   │   │   ├── mart_full_moon_reviews.sql
│   │   ├── src/
│   │   │   ├── src_hosts.sql
│   │   │   ├── src_listings.sql
│   │   │   ├── src_reviews.sql
│   ├── snapshots/
│   │   ├── scd_raw_hosts.sql
│   │   ├── scd_raw_listings.sql
│   ├── tests/
│   │   ├── consistent_created_at.sql
│   │   ├── no_nulls_in_dim_listings.sql
│   ├── dashboards.yml
│   ├── schema.yml
│   ├── sources.yml
```

## Key Components
### Macros
- **`no_nulls_in_columns.sql`**: Ensures that no null values exist in a given model's columns.
- **`positive_value.sql`**: Tests if a specified column contains only positive values.
- **`variables.sql`**: Demonstrates the use of dbt variables.

### Models
#### Dimensions
- `dim_listings_cleansed.sql`: Contains cleansed Airbnb listing data.
- `dim_hosts_cleansed.sql`: Contains cleansed Airbnb host data.
- `dim_listings_with_hosts.sql`: Joins listings with host data.

#### Facts
- `fact_reviews.sql`: Stores review data linked to listings.

#### Marts
- `mart_full_moon_reviews.sql`: Aggregated reviews for full-moon nights.

### Sources
- `src_hosts.sql`: Raw host data source.
- `src_listings.sql`: Raw listings data source.
- `src_reviews.sql`: Raw reviews data source.

### Tests
- `consistent_created_at.sql`: Ensures created_at timestamps are consistent.
- `no_nulls_in_dim_listings.sql`: Ensures no nulls in `dim_listings_cleansed`.

## Dashboard
- **Executive Dashboard**
  - URL: [Airbnb Executive Dashboard](https://a55ca35d.us2a.app.preset.io/superset/dashboard/10/?edit=true&native_filters_key=Ib1BqORZPD1OJfBDf2dDdvlBl8MbYabXROEicrejshycdy-d8oPdqBK7ijyY6elM)
  - Provides insights into Airbnb listings and hosts.
  - Depends on `dim_listings_with_hosts` and `mart_full_moon_reviews`.

## Ownership
- **Project Owner**: Olha Polishchuk  
- **Email**: polischuk280603@gmail.com

## How to Run
1. Install dbt and dependencies.
2. Navigate to the `dbtlearn` directory.
3. Run `dbt deps` to download dbt modules.
4. Run `dbt run` to execute models.
5. Run `dbt test` to validate data integrity.
6. Use `dbt docs generate` to create documentation.
7. Access the dashboard for insights.

---
This dbt project enables structured Airbnb data analysis through robust transformation models and quality tests.
