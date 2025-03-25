-- Create table
CREATE TABLE mydataset (
    image_id INT,
    score FLOAT
);

-- Insert sample data
INSERT INTO mydataset (image_id, score) VALUES
(101, 0.1234), (102, 0.8765), (103, 0.4321), (104, 0.9876), 
(105, 0.6543), (106, 0.3456), (107, 0.7654), (108, 0.2345), 
(109, 0.8764), (110, 0.4322), (111, 0.7655), (112, 0.5432), 
(113, 0.6789), (114, 0.3210), (115, 0.8901), (116, 0.5678), 
(117, 0.2109), (118, 0.9012), (119, 0.3457), (120, 0.7356);

-- Create view for ranking images in descending order of score
CREATE VIEW v1 AS
SELECT 
    image_id,
    score,
    ROW_NUMBER() OVER (ORDER BY score DESC) AS rownumber
FROM mydataset;

-- Create view for ranking images in ascending order of score
CREATE VIEW v2 AS
SELECT 
    image_id,
    score,
    ROW_NUMBER() OVER (ORDER BY score ASC) AS rownumber
FROM mydataset;

-- Select every 3rd image starting from the highest scores (positive samples)
SELECT image_id, score
FROM v1 
WHERE rownumber % 3 = 1 
LIMIT 10000;

-- Select every 3rd image starting from the lowest scores (negative samples)
SELECT image_id, score
FROM v2 
WHERE rownumber % 3 = 1 
LIMIT 10000;
