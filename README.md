# Pizza Analysis
![image](https://github.com/user-attachments/assets/a272ad93-c434-4bdf-8e7c-ef99406304d1)

## Table of Contents
- [Introduction](#Introduction)
- [Dataset Overview](#Dataset-Overview)
- [Data Cleaning and Transformation](#Data-Cleaning-and-Transformation)
- [Data Exploration and Insight](#Data-Exploration-and-Insight)
- [Recommendation](#Recommendation)
- [Conclusion](#Conclusion)

  ### Introduction
  In this presentation, I’ll walk you through my analysis of pizza data, where I examined several aspects including ingredient combinations, pricing patterns, sales performance, and customer preferences. The goal was to identify trends and insights that could help improve product offerings or marketing strategies. To achieve this, I used SQL with a focus on subqueries and Common Table Expressions (CTEs), which allowed me to break down complex queries and structure the analysis more efficiently. Let’s explore the key findings and what they reveal about the pizza business.

  ### Dataset Overview
  The dataset I used for this analysis is composed of four interconnected tables: orders, order_details, pizzas, and pizza_types. The orders table contains information about each transaction, including order ID and date and time. Order_details breaks down each order into specific pizza items and quantities. The pizzas table includes details such as pizza size and price, while pizza_types provides information on the pizza category, name, and ingredients. Together, these tables form a comprehensive view of customer behavior, product variety, and sales performance, allowing for detailed analysis using joins, subqueries, and CTEs.

    The dataset I used for this analysis is composed of four interconnected tables: orders, order_details, pizzas, and pizza_types. The orders table contains 21,350 rows, each representing a unique transaction with details such as order ID and date. The order_details table is the largest, consisting of 48,620 rows, and it breaks down each order into individual pizza items and quantities. The pizzas table contains 96 rows, providing details on the available pizza sizes and prices. The pizza_types table consists of 32 rows, describing each pizza’s name, category, and ingredients. Combined, these tables form a well-structured dataset that enables a comprehensive analysis of customer behavior, sales trends, and product performance. For this project, I used SQL—leveraging joins, subqueries, and Common Table Expressions (CTEs)—to extract and interpret the data effectively.
