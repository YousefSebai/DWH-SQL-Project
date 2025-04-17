# DWH-SQL-Project
# 📊 Data Warehouse Project with SQL Server

This project implements a **Data Warehouse (DWH)** using **SQL Server**, following the principles of the **Medallion Data Architecture** (Bronze, Silver, Gold layers). The goal is to design a scalable and maintainable data platform for efficient data ingestion, transformation, and analytics.

## 🏗️ Architecture Overview

- **Bronze Layer**: Raw data ingestion from source systems, preserving original data with minimal transformations.
- **Silver Layer**: Cleansed and structured data with applied business logic and standardization.
- **Gold Layer**: Aggregated and curated datasets ready for analytics and reporting.

## 🗂️ Data Model

The data warehouse follows a **Star Schema** model to optimize data for querying and reporting. The schema consists of fact tables (measurable data) and dimension tables (descriptive data). 

- **Fact Tables**: Contain the quantitative data and metrics.
- **Dimension Tables**: Contain descriptive attributes that provide context to the facts.

## 🖼️ Diagrams

To visually represent the architecture and data model, the following diagrams were created using **draw.io**:

- **Medallion Architecture**: Shows the flow from raw data (Bronze) to transformed (Silver) and aggregated datasets (Gold).
- **Star Schema Model**: A clear representation of the fact and dimension tables used within the warehouse.

## 🔧 Tools & Technologies

- **SQL Server**: For the relational database and DWH implementation.
- **draw.io**: For designing the Medallion Architecture and Star Schema model diagrams.
