# Image Similarity Project

**Author:** Xuemei Chen & Amy Lan 
**Last updated:** 2025-08-24

This project generates synthetic 50×50 “cat” images and extracts **template-based features** via FFT cross-correlation + max-filtering. It includes a clean, looped filter (`max_filter`) and a vectorized variant (`max_filter_no_loop`), a simple processing pipeline over folders of `.mat` images. We are currently working on the template-based feature extraction.

## Current Goals

1. Generate 301 variants of a base 50×50 pattern (with or without rotation).
2. Save each variant as:
   - `.mat` file containing the raw matrix `A`
   - optional `.png` for quick viewing
3. Extract a **K-dim** feature vector by correlating a **collection of K images ** from an image collection with a **query image** and taking the **maximum response** per image.

## Functions
`gen_cat_image_rot.m`: run once. This generates all the images in `synthetic_data -> cat_image_rot`. and PNGs to `synthetic_data -> cat_image_rot -> png_rot`. 
* Run: `gen_cat_image_rot` *

`gen_cat_image.m`: run once. Same as above without rotation. Writes to `synthetic_data -> cat_image` and PNGs to `synthetic_data -> cat_image_rot -> png_rot -> png`
* Run: `gen_cat_image` *


`max_filter.m`: Loop fft cross correlation and found max per image in an M * N * K collections of images. scores(k) is the maximum response of image k
anywhere in the M×N query image. Return a K*1 vector of peak scores (one per image). Due to Matlab internal contraints, loop version is faster than loop free version for large image inputs.
* Use : `scores = max_filter(image_collection, query_image)` *


`max_filter_no_loop.m` : vectorized version of above. Compute all k scores in one go; clearer but heavier RAM in Matlab, resulting in slower computation than loop version above.
* Use : `scores = max_filter_no_loop(image_collection, query_image)`

`best_match.m` : build phi for all images using fft correlation in the collection, score the query image, find top k neighbors with their corresponding shifts. Serving as a baseline compared to the template method below. 
* Run : `best_match(image_collection, query_image, topK)`

`best_match_temp.m` : build phi for all images using fft correlation in the collection, score the query image, find top k neighbors with their corresponding shifts.
* Run: `best_match_temp(image_collection, query_image, topK, temp_mat)`