# Image Similarity Project

**Author:** Xuemei Chen & Amy Lan 
**Last updated:** 2025-08-05 

This project generates synthetic 50×50 “cat” images and extracts **template-based features** via FFT cross-correlation + max-filtering. It includes a clean, looped filter (`max_filter`) and a vectorized variant (`max_filter_no_loop`), a simple processing pipeline over folders of `.mat` images. We are currently working on the template-based feature extraction.

## Current Goals

1. Generate 301 variants of a base 50×50 pattern (with or without rotation).
2. Save each variant as:
   - `.mat` file containing the raw matrix `A`
   - optional `.png` for quick viewing
3. Extract a **K-dim** feature vector by correlating a **collection of K images ** from an image collection with a **query image** and taking the **maximum response** per image.
