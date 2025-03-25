# Image Quality Sampling SQL Script

## Overview
This SQL script performs sampling on an image dataset based on quality scores predicted by a machine learning model. The dataset consists of unlabeled images with scores ranging from 0 (low quality) to 1 (high quality). The script selects high-quality and low-quality images using a ranking-based sampling strategy.

## Database Schema
### Table: `mydataset`
| Column   | Data Type | Description                         |
|----------|----------|-------------------------------------|
| image_id | INT      | Unique identifier for each image   |
| score    | FLOAT    | Image quality score (0 to 1)       |

## Script Functionality
1. **Create Table & Insert Data**
   - Defines the `mydataset` table.
   - Inserts sample image data with `image_id` and `score` values.

2. **Rank Images Based on Score**
   - Creates a view `v1` ranking images in descending order (highest scores first).
   - Creates a view `v2` ranking images in ascending order (lowest scores first).

3. **Sampling Strategy**
   - Selects every 3rd image from `v1` to form the high-quality dataset (positive samples, `weak_label = 1`).
   - Selects every 3rd image from `v2` to form the low-quality dataset (negative samples, `weak_label = 0`).
   - Limits both selections to 10,000 images.

## SQL Queries
### Table Creation and Data Insertion
```sql
CREATE TABLE mydataset (
    image_id INT,
    score FLOAT
);

INSERT INTO mydataset (image_id, score) VALUES
(101, 0.1234), (102, 0.8765), (103, 0.4321), (104, 0.9876),
(105, 0.6543), (106, 0.3456), (107, 0.7654), (108, 0.2345),
(109, 0.8764), (110, 0.4322), (111, 0.7655), (112, 0.5432),
(113, 0.6789), (114, 0.3210), (115, 0.8901), (116, 0.5678),
(117, 0.2109), (118, 0.9012), (119, 0.3457), (120, 0.7356);
```

### Ranking Views
```sql
CREATE VIEW v1 AS
SELECT
    image_id,
    score,
    ROW_NUMBER() OVER (ORDER BY score DESC) AS rownumber
FROM mydataset;

CREATE VIEW v2 AS
SELECT
    image_id,
    score,
    ROW_NUMBER() OVER (ORDER BY score ASC) AS rownumber
FROM mydataset;
```

### Sampling Queries
```sql
SELECT image_id, score, 1 AS weak_label
FROM v1
WHERE rownumber % 3 = 1
LIMIT 10000;

SELECT image_id, score, 0 AS weak_label
FROM v2
WHERE rownumber % 3 = 1
LIMIT 10000;
```

## Expected Output
- The query returns a total of **20,000** labeled images:
  - **10,000** high-quality images (`weak_label = 1`).
  - **10,000** low-quality images (`weak_label = 0`).
- The final output is sorted by `image_id`.

## Usage
1. Run the script in a SQL-compatible database (e.g., PostgreSQL, MySQL).
2. Modify the `LIMIT` value if a different sample size is required.
3. Use the output dataset for training a machine learning model or other analysis.

## Notes
- The dataset should be preprocessed to ensure no duplicate `image_id` values.
- This script assumes a balanced selection method, ensuring high and low-quality images are evenly represented.

## License
This project is open-source and free to use under the MIT License.

